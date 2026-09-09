import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/app/routes/app_pages.dart';
import 'package:secure_me/core/utils/preference_helper.dart';
import 'package:secure_me/view/common/app_snackbar.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/core/utils/validator.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchUserRole();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    dev.log('🔄 Fetching user profile...', name: 'ProfileController');

    try {
      // First, load cached user data
      String? cachedName = await PreferenceHelper.getUserName();
      String? cachedEmail = await PreferenceHelper.getUserEmail();
      String? cachedPhone = await PreferenceHelper.getUserPhone();
      String? cachedRole = await PreferenceHelper.getUserRole();
      String? cachedImage = await PreferenceHelper.getUserProfileImage();
      String? cachedCreatedAt = await PreferenceHelper.getUserCreatedAt();

      if (cachedName != null) {
        userData.value = {
          'name': cachedName,
          'email': cachedEmail,
          'phone_no': cachedPhone,
          'user_role': cachedRole,
          'profile_image': cachedImage,
          'created_at': cachedCreatedAt,
        };
      }

      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        dev.log(
          '❌ No token found, cannot fetch profile.',
          name: 'ProfileController',
        );
        isLoading.value = false;
        return;
      }

      final response = await http
          .get(
            Uri.parse(AppUrl.profile),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
          )
          .timeout(const Duration(seconds: 15));

      isLoading.value = false;
      dev.log(
        '📡 Profile Response Status: ${response.statusCode}',
        name: 'ProfileController',
      );

      if (response.statusCode == 401) {
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        isLoading.value = false;
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        // 🔹 API nests the actual user object under data['data']['user'] —
        // unwrap it here rather than assuming data['data'] is the user map.
        final Map<String, dynamic> rawData =
            (data['data'] as Map<String, dynamic>?) ?? {};
        final Map<String, dynamic> apiUser =
            (rawData['user'] as Map<String, dynamic>?) ?? rawData;

        userData.value = apiUser;
        dev.log(
          '✅ Profile retrieved successfully: ${userData['name']}',
          name: 'ProfileController',
        );

        // Sync local storage with latest data from server
        await PreferenceHelper.saveUserName(userData['name'] ?? '');
        await PreferenceHelper.saveUserEmail(userData['email'] ?? '');
        await PreferenceHelper.saveUserPhone(userData['phone_no'] ?? '');
        if (userData['profile_image'] != null) {
          await PreferenceHelper.saveUserProfileImage(
            userData['profile_image'],
          );
        }
        // Normalize role-related keys to ensure consistent lookup in views
        final String? rawRole = userData['user_role'] ?? userData['role'];
        if (rawRole != null) {
          userData['user_role'] = rawRole;
          await PreferenceHelper.saveUserRole(rawRole);
        }
        if (userData['created_at'] != null) {
          await PreferenceHelper.saveUserCreatedAt(userData['created_at']);
        }

        // --- Trust & Verification (Safety System) ---
        // 🔹 Backend doesn't currently return is_verified/trust_score/
        // people_helped (only is_active/is_available seen so far) — these
        // fall back to defaults until those fields exist or their real
        // names are confirmed.
        final bool isVerified = userData['is_verified'] == true;
        final int trustScore =
            int.tryParse('${userData['trust_score'] ?? 50}') ?? 50;
        final int peopleHelped =
            int.tryParse('${userData['people_helped'] ?? 0}') ?? 0;

        // --- Sync with global AuthController ---
        if (Get.isRegistered<AuthController>()) {
          final auth = Get.find<AuthController>();
          UserRole roleEnum = UserRole.Manager;
          if (rawRole != null) {
            final norm = rawRole.toLowerCase();
            if (norm.contains('gym')) {
              roleEnum = UserRole.Gym_Person;
            } else if (norm.contains('police')) {
              roleEnum = UserRole.Police;
            }
          }

          auth.updateUserData(
            id: userData['id']?.toString(),
            name: userData['name'],
            email: userData['email'],
            phone: userData['phone_no'],
            profileImage: userData['profile_image'],
            roleString: rawRole,
            role: roleEnum,
            isVerified: isVerified,
            trustScore: trustScore,
            peopleHelped: peopleHelped,
          );
        }
      } else {
        dev.log(
          '❌ Failed to retrieve profile: ${data['message']}',
          name: 'ProfileController',
        );
      }
    } catch (e) {
      isLoading.value = false;
      dev.log('❌ Error fetching profile: $e', name: 'ProfileController');
      AppSnackbar.show(
        title: "Connection Error",
        message:
            "Failed to load profile. Please check your network connection.",
        isError: true,
      );
    }
  }

  Future<void> fetchUserRole() async {
    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) return;

      final response = await http
          .get(
            Uri.parse(AppUrl.userRole),
            headers: {
              // 'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 401) {
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        String role = data['user_role'] ?? 'User';
        userData['user_role'] = role;
        userData.refresh();
        await PreferenceHelper.saveUserRole(role);

        dev.log(
          '✅ User role fetched successfully: $role',
          name: 'ProfileController',
        );
      }
    } catch (e) {
      dev.log('❌ Error fetching user role: $e', name: 'ProfileController');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  }) async {
    final nameError = Validator.validateName(name);
    final emailError = Validator.validateEmail(email);
    final phoneError = Validator.validatePhone(phone);

    if (nameError != null || emailError != null || phoneError != null) {
      final msg = nameError ?? emailError ?? phoneError!;
      return {'success': false, 'message': msg};
    }

    isLoading.value = true;
    dev.log('🔄 Updating user profile...', name: 'ProfileController');

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return {'success': false, 'message': 'No auth token found'};
      }

      final uri = Uri.parse(AppUrl.updateProfile);
      dev.log('🌐 PROFILE UPDATE URL: $uri', name: 'ProfileController');

      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone_no'] = phone;

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profile_image', image.path),
        );
        dev.log(
          '📸 Profile image attached: ${image.path}',
          name: 'ProfileController',
        );
      }

      dev.log(
        '📤 Request fields: ${request.fields}',
        name: 'ProfileController',
      );

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      var response = await http.Response.fromStream(streamedResponse);

      dev.log(
        '📡 Update Profile Status: ${response.statusCode}',
        name: 'ProfileController',
      );
      dev.log(
        '📥 Update Profile RAW body: ${response.body}',
        name: 'ProfileController',
      );

      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        dev.log('❌ Response was not valid JSON: $e', name: 'ProfileController');
        isLoading.value = false;
        return {
          'success': false,
          'message':
              'Unexpected server response (status ${response.statusCode})',
        };
      }

      final String? apiMessage = data['message']?.toString();
      dev.log('💬 Parsed apiMessage: $apiMessage', name: 'ProfileController');

      if (response.statusCode == 200 && data['status'] == true) {
        dev.log(
          '✅ Profile updated successfully: $apiMessage',
          name: 'ProfileController',
        );
        await fetchProfile();
        return {
          'success': true,
          'message': apiMessage ?? 'Profile updated successfully',
        };
      } else {
        isLoading.value = false;
        dev.log(
          '❌ Failed to update profile: $apiMessage',
          name: 'ProfileController',
        );
        return {
          'success': false,
          'message':
              apiMessage ??
              'Failed to update profile (status ${response.statusCode})',
        };
      }
    } catch (e) {
      isLoading.value = false;
      dev.log('❌ Error updating profile: $e', name: 'ProfileController');
      return {
        'success': false,
        'message': 'Could not connect to the server: $e',
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    isLoading.value = true;
    dev.log('🔄 Logging out...', name: 'ProfileController');

    try {
      String? token = await PreferenceHelper.getToken();
      String? apiMessage;
      bool apiSuccess = true;

      if (token != null && token.isNotEmpty) {
        final uri = Uri.parse(AppUrl.logout);
        dev.log('🌐 LOGOUT URL: $uri', name: 'ProfileController');

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
          name: 'ProfileController',
        );
        dev.log(
          '📥 Logout RAW body: ${response.body}',
          name: 'ProfileController',
        );

        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          apiMessage = data['message']?.toString();
          apiSuccess =
              (response.statusCode == 200) && (data['status'] != false);
        } catch (e) {
          dev.log(
            '❌ Logout response not valid JSON: $e',
            name: 'ProfileController',
          );
          apiMessage = null;
        }
      }

      await PreferenceHelper.clearUserData();
      isLoading.value = false;
      dev.log(
        '✅ Logout successful (local data cleared)',
        name: 'ProfileController',
      );

      Get.offAllNamed(AppRoutes.loginView);

      return {
        'success': apiSuccess,
        'message':
            apiMessage ?? 'Successfully logged out from current session.',
      };
    } catch (e) {
      isLoading.value = false;
      dev.log('❌ Error during logout: $e', name: 'ProfileController');
      await PreferenceHelper.clearUserData();
      Get.offAllNamed(AppRoutes.loginView);
      return {
        'success': false,
        'message': 'Logged out locally, but server request failed: $e',
      };
    }
  }
}
