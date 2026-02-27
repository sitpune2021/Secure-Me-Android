import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;

  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(AppUrl.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone_no": phone,
          "password": password,
          "user_role": "bouncer",
        }),
      );

      isLoading.value = false;

      print("📡 Register Response Status: ${response.statusCode}");
      print("📡 Register Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['status'] == true) {
          print('✅ Registration successful for: $email');

          // Extract token and user data similar to login behavior
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
            // Save all user data and initiate session
            await PreferenceHelper.saveUserData(
              token: token,
              userId: user['id']?.toString() ?? '',
              name: user['name'],
              email: user['email'],
              phone: user['phone_no'] ?? user['phone'],
            );
            print('✅ Token and User ID saved successfully');
          } else if (token != null) {
            // Fallback: just save the token and login status
            await PreferenceHelper.saveToken(token);
            await PreferenceHelper.saveLoginStatus(true);
            print('✅ Token saved (user data missing in response)');
          }

          Get.snackbar(
            "Success",
            data['message'] ?? "Account created successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );

          // If session is created, navigate to Home, otherwise Login
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
          data['message'] ??
              "Registration failed with status ${response.statusCode}",
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
