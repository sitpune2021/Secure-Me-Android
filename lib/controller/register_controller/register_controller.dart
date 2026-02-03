import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

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

      print("Register Response Status: ${response.statusCode}");
      print("Register Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['status'] == true) {
          Get.snackbar(
            "Success",
            data['message'] ?? "Account created successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );
          // Navigate to Login or Home. User prompt example implies success leads to a token.
          // For now, navigate to Login as per original UI flow, or maybe directly home if we save token.
          Get.offAllNamed(AppRoutes.loginView);
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
      print("Register Error: $e");
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
