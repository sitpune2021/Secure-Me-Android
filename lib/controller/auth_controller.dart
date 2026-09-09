
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/app/routes/app_pages.dart';
import 'package:secure_me/app/theme/app_theme.dart';
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/core/utils/preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_me/core/utils/validator.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  // New fields for managing login/registration state
  final Rx<UserRole> selectedRole = UserRole.None.obs;
  bool _isPhoneLogin =
      false; // Tracks if the user is trying to login with phone
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Getters for the new fields
  bool get isPhoneLogin => _isPhoneLogin;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get passwordController => _passwordController;

  // Setters for the new fields
  void setSelectedRole(UserRole role) {
    selectedRole.value = role;
  }

  void toggleLoginMethod() {
    _isPhoneLogin = !_isPhoneLogin;
    update(); // Notify listeners
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserSession();

    requestInitialPermissions();
  }

  @override
  void onClose() {
    // 🔹 Dispose controllers owned by this GetxController to avoid leaks
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.onClose();
  }

  void _loadUserSession() async {
    final token = await PreferenceHelper.getToken();
    final isLoggedIn = await PreferenceHelper.isLoggedIn();

    if (token != null && isLoggedIn) {
      final id = await PreferenceHelper.getUserId() ?? '';
      final name = await PreferenceHelper.getUserName() ?? 'User';
      final email = await PreferenceHelper.getUserEmail() ?? '';
      final phone = await PreferenceHelper.getUserPhone() ?? '';
      final roleStr = await PreferenceHelper.getUserRole() ?? 'user';
      final profileImage = await PreferenceHelper.getUserProfileImage();

      UserRole role = UserRole.Manager;
      final normalizedRole = roleStr.toLowerCase();
      if (normalizedRole.contains('gym')) {
        role = UserRole.Gym_Person;
      } else if (normalizedRole.contains('police')) {
        role = UserRole.Police;
      } else {
        role = UserRole.Manager;
      }

      user.value = UserModel(
        id: id,
        name: name,
        email: email,
        phone: phone,
        role: role,
        roleString: roleStr,
        profileImage: profileImage,
      );
    }
  }

  void setUser(UserModel? newUser) {
    user.value = newUser;
  }

  void updateUserData({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? roleString,
    UserRole? role,
    bool? isVerified,
    int? trustScore,
    int? peopleHelped,
  }) {
    if (user.value != null) {
      user.value = user.value!.copyWith(
        id: id,
        name: name,
        email: email,
        phone: phone,
        profileImage: profileImage,
        roleString: roleString,
        role: role,
        isVerified: isVerified,
        trustScore: trustScore,
        peopleHelped: peopleHelped,
      );
    }
  }

  void forgotPassword(String email) async {
    final emailError = Validator.validateEmail(email);
    if (emailError != null) {
      Get.snackbar(
        "Invalid Email",
        emailError,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    // Mock Forgot Password delay
    await Future.delayed(const Duration(seconds: 1));
    Get.snackbar(
      "Reset Link Sent",
      "A password reset link has been sent to $email",
      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    isLoading.value = false;
    Get.back();
  }

  Future<Map<String, dynamic>> logout() async {
    isLoading.value = true;
    dev.log('🔄 Logging out...', name: 'AuthController');

    try {
      String? token = await PreferenceHelper.getToken();
      String? apiMessage;
      bool apiSuccess = true;

      if (token != null && token.isNotEmpty) {
        final uri = Uri.parse(AppUrl.logout);
        dev.log('🌐 LOGOUT URL: $uri', name: 'AuthController');

        final response = await http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            )
            .timeout(const Duration(seconds: 15));

        dev.log(
          '📡 Logout Status: ${response.statusCode}',
          name: 'AuthController',
        );
        dev.log('📥 Logout RAW body: ${response.body}', name: 'AuthController');

        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          apiMessage = data['message']?.toString();
          apiSuccess =
              (response.statusCode == 200) && (data['status'] != false);
        } catch (e) {
          dev.log(
            '❌ Logout response not valid JSON: $e',
            name: 'AuthController',
          );
          apiMessage = null;
        }
      }

      await PreferenceHelper.clearUserData();
      user.value = null;
      isLoading.value = false;
      dev.log(
        '✅ Logout successful (local data cleared)',
        name: 'AuthController',
      );

      Get.offAllNamed(AppRoutes.loginView);

      return {
        'success': apiSuccess,
        'message':
            apiMessage ?? 'Successfully logged out from current session.',
      };
    } catch (e) {
      isLoading.value = false;
      dev.log('❌ Logout Error: $e', name: 'AuthController');
      await PreferenceHelper.clearUserData();
      user.value = null;
      Get.offAllNamed(AppRoutes.loginView);
      return {
        'success': false,
        'message': 'Logged out locally, but server request failed: $e',
      };
    }
  }

  // --- Early Permission Onboarding ---
  // Location permission intentionally excluded here — see onInit() note above.
  Future<void> requestInitialPermissions() async {
    dev.log(
      "🔐 Checking initial safety permissions...",
      name: 'AuthController',
    );

    // Core permissions required for the app to function properly
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.contacts,
    ].request();

    if (statuses[Permission.microphone] != PermissionStatus.granted) {
      dev.log("⚠️ Microphone permission not granted initially.");
    }
  }
}
