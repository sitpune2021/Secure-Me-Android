import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

class LoginController extends GetxController {
  var mobileNumber = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var isEmailLogin = true.obs;
  var isLoading = false.obs;

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
    dev.log(
      '🔄 Starting email login for: ${email.value}',
      name: 'LoginController',
    );

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

      dev.log(
        "📡 Login Response Status: ${response.statusCode}",
        name: 'LoginController',
      );
      dev.log(
        "📡 Login Response Body: ${response.body}",
        name: 'LoginController',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        dev.log('🔍 Response is 200 OK', name: 'LoginController');
        dev.log('🔍 Checking data[status]...', name: 'LoginController');

        if (data['status'] == true) {
          dev.log(
            '✅ Login successful for: ${email.value}',
            name: 'LoginController',
          );

          dev.log(
            '🔍 Checking user data in response...',
            name: 'LoginController',
          );
          dev.log('🔍 Full data object: $data', name: 'LoginController');
          dev.log('🔍 Data keys: ${data.keys}', name: 'LoginController');
          dev.log('🔍 Data type: ${data.runtimeType}', name: 'LoginController');

          // Try to find token in different locations
          String? token;
          Map<String, dynamic>? user;

          if (data['token'] != null) {
            token = data['token'];
            dev.log('✅ Found token at data["token"]', name: 'LoginController');
          } else if (data['data'] != null && data['data']['token'] != null) {
            token = data['data']['token'];
            dev.log(
              '✅ Found token at data["data"]["token"]',
              name: 'LoginController',
            );
          } else if (data['access_token'] != null) {
            token = data['access_token'];
            dev.log(
              '✅ Found token at data["access_token"]',
              name: 'LoginController',
            );
          }

          // Try to find user in different locations
          if (data['user'] != null) {
            user = data['user'];
            dev.log('✅ Found user at data["user"]', name: 'LoginController');
          } else if (data['data'] != null && data['data']['user'] != null) {
            user = data['data']['user'];
            dev.log(
              '✅ Found user at data["data"]["user"]',
              name: 'LoginController',
            );
          } else if (data['data'] != null) {
            user = data['data'];
            dev.log(
              '✅ Using data["data"] as user object',
              name: 'LoginController',
            );
          }

          dev.log('🔍 Token found: ${token != null}', name: 'LoginController');
          dev.log('🔍 User found: ${user != null}', name: 'LoginController');

          if (user != null && token != null) {
            dev.log('🔍 User object: $user', name: 'LoginController');
            dev.log('🔍 User keys: ${user.keys}', name: 'LoginController');
            dev.log('🔍 User ID: ${user['id']}', name: 'LoginController');
            dev.log('🔍 User name: ${user['name']}', name: 'LoginController');
            dev.log('🔍 User email: ${user['email']}', name: 'LoginController');
            dev.log(
              '🔍 User phone: ${user['phone_no'] ?? user['phone']}',
              name: 'LoginController',
            );

            // Use centralized saveUserData method which creates session automatically
            await PreferenceHelper.saveUserData(
              token: token,
              userId: user['id']?.toString() ?? '',
              name: user['name'],
              email: user['email'],
              phone: user['phone_no'] ?? user['phone'],
              profileImage: user['profile_image'],
            );

            dev.log(
              '✅ All user data and session saved successfully',
              name: 'LoginController',
            );
          } else {
            dev.log(
              '⚠️ Missing user object or token in API response!',
              name: 'LoginController',
            );
            dev.log(
              '⚠️ Has user key: ${data.containsKey('user')}',
              name: 'LoginController',
            );
            dev.log(
              '⚠️ Has token key: ${data.containsKey('token')}',
              name: 'LoginController',
            );
            dev.log('⚠️ User value: ${data['user']}', name: 'LoginController');
            dev.log(
              '⚠️ Token value: ${data['token']}',
              name: 'LoginController',
            );
            dev.log(
              '⚠️ Full response for debugging: $data',
              name: 'LoginController',
            );

            // Fallback: save token only if available
            if (token != null) {
              await PreferenceHelper.saveToken(token);
              await PreferenceHelper.saveLoginStatus(true);
              dev.log('✅ Token saved from fallback', name: 'LoginController');
            } else {
              dev.log(
                '❌ Cannot proceed without token!',
                name: 'LoginController',
              );
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

          dev.log('🚀 Navigating to home screen', name: 'LoginController');
          Get.offAllNamed(AppRoutes.homeView);
        } else {
          dev.log(
            '❌ Login failed: ${data['message']}',
            name: 'LoginController',
          );
          Get.snackbar(
            "Error",
            data['message'] ?? "Login failed",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        dev.log('❌ Unauthorized: Invalid credentials', name: 'LoginController');
        Get.snackbar(
          "Error",
          "Invalid email or password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        dev.log(
          '❌ Login failed with status: ${response.statusCode}',
          name: 'LoginController',
        );
        Get.snackbar(
          "Error",
          data['message'] ?? "Login failed with status ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      dev.log("❌ Login Error: $e", name: 'LoginController');
      Get.snackbar(
        "Error",
        "Network error. Please check your connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loginWithMobile() async {
    if (email.value.trim().isEmpty || !email.value.contains('@')) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    dev.log(
      '🔄 Starting OTP request for: ${email.value}',
      name: 'LoginController',
    );
    try {
      final response = await http.post(
        Uri.parse(AppUrl.sendOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"email": email.value.trim()}),
      );

      isLoading.value = false;

      dev.log(
        "📡 Send OTP Response Status: ${response.statusCode}",
        name: 'LoginController',
      );
      dev.log(
        "📡 Send OTP Response Body: ${response.body}",
        name: 'LoginController',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          dev.log(
            '✅ OTP sent successfully to: ${email.value}',
            name: 'LoginController',
          );
          Get.snackbar(
            "Success",
            data['message'] ?? "OTP sent successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );

          // Navigate to OTP screen
          Get.toNamed(
            AppRoutes.otpView,
            arguments: {'email': email.value.trim()},
          );
        } else {
          dev.log(
            '❌ Failed to send OTP: ${data['message']}',
            name: 'LoginController',
          );
          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to send OTP",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        dev.log(
          '❌ Send OTP failed with status: ${response.statusCode}',
          name: 'LoginController',
        );
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
      dev.log("Send OTP Error: $e", name: 'LoginController');
      Get.snackbar(
        "Error",
        "Network error. Please check your connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
