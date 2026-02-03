import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

class OtpController extends GetxController {
  var otp = "".obs;
  var isLoading = false.obs;
  var phoneNumber = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Get phone number from arguments
    final args = Get.arguments;
    if (args != null && args['phone_no'] != null) {
      phoneNumber.value = args['phone_no'];
      print('📱 Phone number received: ${phoneNumber.value}');
    }
  }

  void setOtp(String value) {
    otp.value = value;
  }

  Future<void> verifyOtp() async {
    if (otp.value.length < 6) {
      Get.snackbar(
        "Error",
        "Please enter 6 digit OTP",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    print('🔄 Verifying OTP for: ${phoneNumber.value}');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.verifyOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"phone_no": phoneNumber.value, "otp": otp.value}),
      );

      isLoading.value = false;

      print("📡 Verify OTP Response Status: ${response.statusCode}");
      print("📡 Verify OTP Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          print('✅ OTP verified successfully for: ${phoneNumber.value}');

          print('🔍 Checking user data in OTP response...');
          print('🔍 Full data object: $data');
          print('🔍 Data keys: ${data.keys}');

          // Try to find token in different locations
          String? token;
          Map<String, dynamic>? user;

          if (data['token'] != null) {
            token = data['token'];
            print('✅ Found token at data["token"]');
          } else if (data['data'] != null && data['data']['token'] != null) {
            token = data['data']['token'];
            print('✅ Found token at data["data"]["token"]');
          }

          // Try to find user in different locations
          if (data['user'] != null) {
            user = data['user'];
            print('✅ Found user at data["user"]');
          } else if (data['data'] != null && data['data']['user'] != null) {
            user = data['data']['user'];
            print('✅ Found user at data["data"]["user"]');
          }

          print('🔍 Token found: ${token != null}');
          print('🔍 User found: ${user != null}');

          if (user != null && token != null) {
            print('🔍 User object: $user');
            print('🔍 User keys: ${user.keys}');

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
            print('⚠️ Missing user object or token in OTP API response!');

            // Fallback: save token only if available
            if (token != null) {
              await PreferenceHelper.saveToken(token);
              await PreferenceHelper.saveLoginStatus(true);
              print('✅ Token saved from fallback');
            }
          }

          Get.snackbar(
            "Success",
            data['message'] ?? "OTP verified successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );

          print('🚀 Navigating to home screen');
          Get.offAllNamed(AppRoutes.homeView);
        } else {
          print('❌ OTP verification failed: ${data['message']}');
          Get.snackbar(
            "Error",
            data['message'] ?? "Invalid OTP",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized: Invalid or expired OTP');
        Get.snackbar(
          "Error",
          "Invalid or expired OTP",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('❌ Verification failed with status: ${response.statusCode}');
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
      print("❌ Verify OTP Error: $e");
      Get.snackbar(
        "Error",
        "Network error. Please check your connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> resendOtp() async {
    if (phoneNumber.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Phone number not found",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    print('🔄 Resending OTP to: ${phoneNumber.value}');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.resendOtp),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"phone_no": phoneNumber.value}),
      );

      isLoading.value = false;

      print("📡 Resend OTP Response Status: ${response.statusCode}");
      print("📡 Resend OTP Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          print('✅ OTP resent successfully to: ${phoneNumber.value}');

          Get.snackbar(
            "Success",
            data['message'] ?? "OTP sent successfully",
            backgroundColor: AppColors.lightPrimary,
            colorText: Colors.white,
          );
        } else {
          print('❌ Failed to resend OTP: ${data['message']}');
          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to resend OTP",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print('❌ Resend OTP failed with status: ${response.statusCode}');
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
      print("❌ Resend OTP Error: $e");
      Get.snackbar(
        "Error",
        "Network error. Please check your connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
