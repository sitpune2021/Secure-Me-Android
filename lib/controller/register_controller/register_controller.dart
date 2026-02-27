import 'dart:convert';
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

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
        print("📸 Image selected: ${image.path}");
      }
    } catch (e) {
      print("❌ Error picking image: $e");
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      // Use MultipartRequest for image upload
      var request = http.MultipartRequest('POST', Uri.parse(AppUrl.register));

      // Add text fields
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone_no'] = phone;
      request.fields['password'] = password;
      request.fields['user_role'] = 'bouncer';

      // Add image if selected
      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image', // Adjust field name according to your API
            selectedImage.value!.path,
          ),
        );
        print("📸 Attached image to request");
      }

      request.headers.addAll({'Accept': 'application/json'});

      print("🚀 Sending Multipart Registration Request...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      isLoading.value = false;

      print("📡 Register Response Status: ${response.statusCode}");
      print("📡 Register Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['status'] == true) {
          print('✅ Registration successful for: $email');

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
          );

          if (token != null) {
            Get.offAllNamed(AppRoutes.homeView);
          } else {
            Get.offAllNamed(AppRoutes.loginView);
          }
        } else {
          Get.snackbar(
            "Error",
            data['message'] ?? "Registration failed",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Registration failed (${response.statusCode})",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      print("❌ Register Error: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
