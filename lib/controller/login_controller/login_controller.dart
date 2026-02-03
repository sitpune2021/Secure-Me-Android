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
        print('🔍 Response is 200 OK');
        print('🔍 Checking data[status]...');

        if (data['status'] == true) {
          print('✅ Login successful for: ${email.value}');

          print('🔍 Checking user data in response...');
          print('🔍 Full data object: $data');
          print('🔍 Data keys: ${data.keys}');
          print('🔍 Data type: ${data.runtimeType}');

          // Try to find token in different locations
          String? token;
          Map<String, dynamic>? user;

          if (data['token'] != null) {
            token = data['token'];
            print('✅ Found token at data["token"]');
          } else if (data['data'] != null && data['data']['token'] != null) {
            token = data['data']['token'];
            print('✅ Found token at data["data"]["token"]');
          } else if (data['access_token'] != null) {
            token = data['access_token'];
            print('✅ Found token at data["access_token"]');
          }

          // Try to find user in different locations
          if (data['user'] != null) {
            user = data['user'];
            print('✅ Found user at data["user"]');
          } else if (data['data'] != null && data['data']['user'] != null) {
            user = data['data']['user'];
            print('✅ Found user at data["data"]["user"]');
          } else if (data['data'] != null) {
            user = data['data'];
            print('✅ Using data["data"] as user object');
          }

          print('🔍 Token found: ${token != null}');
          print('🔍 User found: ${user != null}');

          if (user != null && token != null) {
            print('🔍 User object: $user');
            print('🔍 User keys: ${user.keys}');
            print('🔍 User ID: ${user['id']}');
            print('🔍 User name: ${user['name']}');
            print('🔍 User email: ${user['email']}');
            print('🔍 User phone: ${user['phone_no'] ?? user['phone']}');

            // Use centralized saveUserData method which creates session automatically
            await PreferenceHelper.saveUserData(
              token: token,
              userId: user['id']?.toString() ?? '',
              name: user['name'],
              email: user['email'],
              phone: user['phone_no'] ?? user['phone'],
            );

            print('✅ All user data and session saved successfully');
          } else {
            print('⚠️ Missing user object or token in API response!');
            print('⚠️ Has user key: ${data.containsKey('user')}');
            print('⚠️ Has token key: ${data.containsKey('token')}');
            print('⚠️ User value: ${data['user']}');
            print('⚠️ Token value: ${data['token']}');
            print('⚠️ Full response for debugging: $data');

            // Fallback: save token only if available
            if (token != null) {
              await PreferenceHelper.saveToken(token);
              await PreferenceHelper.saveLoginStatus(true);
              print('✅ Token saved from fallback');
            } else {
              print('❌ Cannot proceed without token!');
              Get.snackbar(
                "Error",
                "Login response is missing required data. Please contact support.",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
          }

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
