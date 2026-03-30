import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/main.dart';
import 'package:secure_me/view/common/app_snackbar.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/utils/preference_helper.dart';
import 'package:secure_me/utils/error_helper.dart';
import 'package:secure_me/utils/validator.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;
  var selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Compress image for faster upload
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        dev.log("✅ Image selected: ${image.path}", name: 'RegisterController');
      }
    } catch (e) {
      dev.log("❌ Error picking image: $e", name: 'RegisterController');
      AppSnackbar.show(
        title: "Selection Failed",
        message: "Failed to pick image from source.",
        isError: true,
      );
    }
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    double? latitude,
    double? longitude,
  }) async {
    isLoading.value = true;

    final nameError = Validator.validateName(name);
    final emailError = Validator.validateEmail(email);
    final phoneError = Validator.validatePhone(phone);
    final passwordError = Validator.validatePassword(password);

    if (nameError != null || emailError != null || phoneError != null || passwordError != null) {
      isLoading.value = false;
      AppSnackbar.show(
        title: "Validation Error",
        message: nameError ?? emailError ?? phoneError ?? passwordError!,
        isError: true,
      );
      return;
    }

    try {
      dev.log(
        "🚀 Starting Registration for: $email",
        name: 'RegisterController',
      );
      // Use MultipartRequest for image upload
      var request = http.MultipartRequest('POST', Uri.parse(AppUrl.register));

      // Add text fields
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone_no'] = phone;
      request.fields['password'] = password;
      request.fields['user_role'] = role;
      
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();

      // Add image if selected
      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', selectedImage.value!.path),
        );
        dev.log(
          "📸 Image attached: ${selectedImage.value!.path}",
          name: 'RegisterController',
        );
      }

      request.headers.addAll({'Accept': 'application/json'});

      dev.log(
        "📡 Sending Multipart Request to ${AppUrl.register}...",
        name: 'RegisterController',
      );

      // Set a timeout for the request
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      var response = await http.Response.fromStream(streamedResponse);

      dev.log("📡 Status: ${response.statusCode}", name: 'RegisterController');
      dev.log("📡 Body: ${response.body}", name: 'RegisterController');

      if (response.body.isEmpty) {
        throw Exception("Server returned an empty response");
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['status'] == true) {
          dev.log('✅ Registration success full', name: 'RegisterController');

          // Extract token and user data fallback logic
          String? token;
          Map<String, dynamic>? user;

          if (data['token'] != null) {
            token = data['token'];
          } else if (data['data'] != null && data['data']['token'] != null) {
            token = data['data']['token'];
          } else if (data['access_token'] != null) {
            token = data['access_token'];
          }

          if (data['user'] != null) {
            user = data['user'];
          } else if (data['data'] != null && data['data']['user'] != null) {
            user = data['data']['user'];
          } else if (data['data'] != null) {
            user = data['data'];
          }

          if (user != null && token != null) {
            await PreferenceHelper.saveUserData(
              token: token,
              userId: user['id']?.toString() ?? '',
              name: user['name'] ?? 'User',
              email: user['email'],
              phone: user['phone_no'] ?? user['phone'],
              profileImage: user['profile_image'],
              userRole: user['user_role'] ?? user['role'] ?? 'user',
            );

            // Notify global AuthController
            if (Get.isRegistered<AuthController>()) {
              final authController = Get.find<AuthController>();
              UserRole role;
              final roleStr = (user['user_role'] ?? user['role'])?.toString() ?? 'Manager';
              final normalizedRole = roleStr.toLowerCase();
              
              if (normalizedRole.contains('gym')) {
                role = UserRole.Gym_Person;
              } else if (normalizedRole.contains('police')) {
                role = UserRole.Police;
              } else {
                role = UserRole.Manager;
              }

              authController.setUser(UserModel(
                 id: user['id']?.toString() ?? '',
                 name: user['name'] ?? 'User',
                 email: user['email'] ?? '',
                 phone: (user['phone_no'] ?? user['phone']) ?? '',
                 role: role,
                 roleString: roleStr,
                 profileImage: user['profile_image'],
              ));
            }
          } else if (token != null) {
            await PreferenceHelper.saveToken(token);
            await PreferenceHelper.saveLoginStatus(true);
          }

          AppSnackbar.show(
            title: "Identity Secured",
            message: data['message'] ?? "Account created successfully",
            isSuccess: true,
          );

          if (token != null) {
            Get.offAll(() => AppRouter());
          } else {
            Get.offAllNamed(AppRoutes.loginView);
          }
        } else {
          AppSnackbar.show(
            title: "Registry Failed",
            message: data['message'] ?? "Please check your details",
            isError: true,
          );
        }
      } else {
        dev.log(
          '❌ Registration failed with status: ${response.statusCode}',
          name: 'RegisterController',
        );
        AppSnackbar.show(
          title: ErrorHelper.getErrorTitle(response.statusCode),
          message: ErrorHelper.getFriendlyMessage(response),
          isError: true,
        );
      }
    } catch (e) {
      dev.log("❌ Connection Error: $e", name: 'RegisterController');
      AppSnackbar.show(
        title: "Connection Error",
        message: "Could not reach server. Please check your internet.",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
