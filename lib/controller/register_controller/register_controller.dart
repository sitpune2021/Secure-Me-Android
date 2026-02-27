import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

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
      Get.snackbar(
        "Error",
        "Failed to pick image",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    isLoading.value = true;
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
              name: user['name'],
              email: user['email'],
              phone: user['phone_no'] ?? user['phone'],
              profileImage: user['profile_image'],
            );
          } else if (token != null) {
            await PreferenceHelper.saveToken(token);
            await PreferenceHelper.saveLoginStatus(true);
          }

          Get.snackbar(
            "Success",
            data['message'] ?? "Account created successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          if (token != null) {
            Get.offAllNamed(AppRoutes.homeView);
          } else {
            Get.offAllNamed(AppRoutes.loginView);
          }
        } else {
          Get.snackbar(
            "Registration Failed",
            data['message'] ?? "Please check your details",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        String errorMessage = "Registration failed";
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        } else if (data is Map && data.containsKey('errors')) {
          // Handle validation errors from Laravel if present
          errorMessage = data['errors'].toString();
        }

        Get.snackbar(
          "Error ${response.statusCode}",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      dev.log("❌ Connection Error: $e", name: 'RegisterController');
      Get.snackbar(
        "Connection Error",
        "Could not reach server. Please check your internet.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
