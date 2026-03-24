import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/model/user_model.dart';

class OtpController extends GetxController {
  var otp = "".obs;
  var isLoading = false.obs;
  var identifier = "".obs;
  var isPhone = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args['email'] != null) {
        identifier.value = args['email'];
        isPhone.value = false;
      } else if (args['phone'] != null) {
        identifier.value = args['phone'];
        isPhone.value = true;
      }
      dev.log('📱 Identifier received: ${identifier.value}', name: 'OtpController');
    }
  }

  void setOtp(String value) {
    otp.value = value;
  }

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      Get.snackbar("Error", "Please enter 6 digit OTP", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    dev.log('🔄 Verifying OTP for: ${identifier.value}', name: 'OtpController');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.verifyOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
        isPhone.value ? "phone" : "email": identifier.value, 
        "otp": otp.value
      }),
      );

      isLoading.value = false;

      dev.log(
        "📡 Verify OTP Response Status: ${response.statusCode}",
        name: 'OtpController',
      );
      dev.log(
        "📡 Verify OTP Response Body: ${response.body}",
        name: 'OtpController',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          dev.log(
            '✅ OTP verified successfully for: ${identifier.value}',
            name: 'OtpController',
          );

          dev.log(
            '🔍 Checking user data in OTP response...',
            name: 'OtpController',
          );
          dev.log('🔍 Full data object: $data', name: 'OtpController');
          dev.log('🔍 Data keys: ${data.keys}', name: 'OtpController');

          // Try to find token in different locations
          String? token;
          Map<String, dynamic>? user;

          if (data['token'] != null) {
            token = data['token'];
            dev.log('✅ Found token at data["token"]', name: 'OtpController');
          } else if (data['data'] != null && data['data']['token'] != null) {
            token = data['data']['token'];
            dev.log(
              '✅ Found token at data["data"]["token"]',
              name: 'OtpController',
            );
          }

          // Try to find user in different locations
          if (data['user'] != null) {
            user = data['user'];
            dev.log('✅ Found user at data["user"]', name: 'OtpController');
          } else if (data['data'] != null && data['data']['user'] != null) {
            user = data['data']['user'];
            dev.log(
              '✅ Found user at data["data"]["user"]',
              name: 'OtpController',
            );
          }

          dev.log('🔍 Token found: ${token != null}', name: 'OtpController');
          dev.log('🔍 User found: ${user != null}', name: 'OtpController');

          if (user != null && token != null) {
            dev.log('🔍 User object: $user', name: 'OtpController');
            dev.log('🔍 User keys: ${user.keys}', name: 'OtpController');

            // Use centralized saveUserData method which creates session automatically
            await PreferenceHelper.saveUserData(
              token: token,
              userId: user['id']?.toString() ?? '',
              name: user['name'],
              email: user['email'],
              phone: user['phone_no'] ?? user['phone'],
              profileImage: user['profile_image'],
              userRole: user['role'] ?? 'user',
            );

             // Update AuthController state
             if (Get.isRegistered<AuthController>()) {
                final auth = Get.find<AuthController>();
                UserRole role = UserRole.user;
                final roleStr = user['role'] ?? 'user';
                if (roleStr == 'helper') role = UserRole.helper;
                if (roleStr == 'police') role = UserRole.police;

                auth.user.value = UserModel(
                  id: user['id']?.toString() ?? '',
                  name: user['name'] ?? 'Verified User',
                  email: user['email'] ?? '',
                  phone: (user['phone_no'] ?? user['phone']) ?? '',
                  role: role,
                  profileImage: user['profile_image'],
                );
             }

            dev.log(
              '✅ All user data and session saved successfully',
              name: 'OtpController',
            );
          } else {
            dev.log(
              '⚠️ Missing user object or token in OTP API response!',
              name: 'OtpController',
            );

            // Fallback: save token only if available
            if (token != null) {
              await PreferenceHelper.saveToken(token);
              await PreferenceHelper.saveLoginStatus(true);
              dev.log('✅ Token saved from fallback', name: 'OtpController');
            }
          }

          Get.snackbar(
            "Success",
            data['message'] ?? "OTP verified successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );

          dev.log('🚀 Navigating to home screen', name: 'OtpController');
          Get.offAllNamed(AppRoutes.homeView);
        } else {
          dev.log(
            '❌ OTP verification failed: ${data['message']}',
            name: 'OtpController',
          );
          Get.snackbar(
            "Error",
            data['message'] ?? "Invalid OTP",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        dev.log(
          '❌ Unauthorized: Invalid or expired OTP',
          name: 'OtpController',
        );
        Get.snackbar(
          "Error",
          "Invalid or expired OTP",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        dev.log(
          '❌ Verification failed with status: ${response.statusCode}',
          name: 'OtpController',
        );
        Get.snackbar(
          "Error",
          data['message'] ??
              "Verification failed with status ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      dev.log("❌ Verify OTP Error: $e", name: 'OtpController');
      Get.snackbar(
        "Error",
        "Network error. Please check your connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> resendOtp() async {
    if (identifier.value.isEmpty) {
      Get.snackbar(
        "Error",
        "${isPhone.value ? 'Phone' : 'Email'} not found",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    dev.log('🔄 Resending OTP to: ${identifier.value}', name: 'OtpController');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.resendOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({isPhone.value ? "phone" : "email": identifier.value}),
      );

      isLoading.value = false;

      dev.log(
        "📡 Resend OTP Response Status: ${response.statusCode}",
        name: 'OtpController',
      );
      dev.log(
        "📡 Resend OTP Response Body: ${response.body}",
        name: 'OtpController',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          dev.log(
            '✅ OTP resent successfully to: ${identifier.value}',
            name: 'OtpController',
          );

          Get.snackbar(
            "Success",
            data['message'] ?? "OTP sent successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );
        } else {
          dev.log(
            '❌ Failed to resend OTP: ${data['message']}',
            name: 'OtpController',
          );
          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to resend OTP",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        dev.log(
          '❌ Resend OTP failed with status: ${response.statusCode}',
          name: 'OtpController',
        );
        Get.snackbar(
          "Error",
          data['message'] ??
              "Failed to resend OTP with status ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      dev.log("❌ Resend OTP Error: $e", name: 'OtpController');
      Get.snackbar(
        "Error",
        "Network error. Please check your connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
