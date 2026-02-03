import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

class LoginController extends GetxController {
  var keepLoggedIn = false.obs;
  var mobileNumber = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var isEmailLogin = true.obs;
  var isLoading = false.obs;

  void toggleKeepLoggedIn(bool? value) {
    keepLoggedIn.value = value ?? false;
  }

  Future<void> login() async {
    if (isEmailLogin.value) {
      await _loginWithEmail();
    } else {
      await _loginWithMobile();
    }
  }

  Future<void> _loginWithEmail() async {
    if (email.value.trim().isEmpty || password.value.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter email and password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    print('🔄 Starting email login for: ${email.value}');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": email.value.trim(),
          "password": password.value,
        }),
      );

      isLoading.value = false;

      print("📡 Login Response Status: ${response.statusCode}");
      print("📡 Login Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          print('✅ Login successful for: ${email.value}');

          // Store token and user data
          if (data['token'] != null) {
            await PreferenceHelper.saveToken(data['token']);
          }

          if (data['user'] != null) {
            final user = data['user'];
            if (user['id'] != null) {
              await PreferenceHelper.saveUserId(user['id'].toString());
            }
            if (user['name'] != null) {
              await PreferenceHelper.saveUserName(user['name']);
            }
            if (user['email'] != null) {
              await PreferenceHelper.saveUserEmail(user['email']);
            }
            if (user['phone_no'] != null) {
              await PreferenceHelper.saveUserPhone(user['phone_no']);
            }
          }

          await PreferenceHelper.saveLoginStatus(true);

          Get.snackbar(
            "Success",
            data['message'] ?? "Login successful",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );

          print('🚀 Navigating to home screen');
          Get.offAllNamed(AppRoutes.homeView);
        } else {
          print('❌ Login failed: ${data['message']}');
          Get.snackbar(
            "Error",
            data['message'] ?? "Login failed",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized: Invalid credentials');
        Get.snackbar(
          "Error",
          "Invalid email or password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('❌ Login failed with status: ${response.statusCode}');
        Get.snackbar(
          "Error",
          data['message'] ?? "Login failed with status ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      print("❌ Login Error: $e");
      Get.snackbar(
        "Error",
        "Network error. Please check your connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loginWithMobile() async {
    if (mobileNumber.value.isEmpty || mobileNumber.value.length != 10) {
      Get.snackbar(
        "Error",
        "Please enter a valid 10-digit mobile number",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(AppUrl.sendOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"phone_no": mobileNumber.value}),
      );

      isLoading.value = false;

      print("📡 Send OTP Response Status: ${response.statusCode}");
      print("📡 Send OTP Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          Get.snackbar(
            "Success",
            data['message'] ?? "OTP sent successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );

          // Navigate to OTP screen
          Get.toNamed(
            AppRoutes.otpView,
            arguments: {'phone_no': mobileNumber.value},
          );
        } else {
          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to send OTP",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          data['message'] ??
              "Failed to send OTP with status ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      print("Send OTP Error: $e");
      Get.snackbar(
        "Error",
        "Network error. Please check your connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
