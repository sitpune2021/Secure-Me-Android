import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/utils/preference_helper.dart';

class SettingsController extends GetxController {
  var autoCallOnSos = false.obs;
  var isLoading = false.obs;

  void toggleAutoCall(bool value) {
    autoCallOnSos.value = value;
  }

  Future<void> logout() async {
    isLoading.value = true;
    print('🔄 Starting logout process...');

    try {
      final token = await PreferenceHelper.getToken();
      print('📖 Using token for logout: ${token?.substring(0, 10)}...');

      // Call Logout API
      final response = await http.post(
        Uri.parse(AppUrl.logout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print("📡 Logout Response Status: ${response.statusCode}");
      print("📡 Logout Response Body: ${response.body}");
      isLoading.value = false; // Set to false before snackbar/navigation

      // Even if API fails or returns 401 (Unauthenticated), we clear local data
      await PreferenceHelper.clearUserData();
      print('✅ Local session cleared');

      Get.snackbar(
        "Logged Out",
        "You have been successfully logged out",
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );

      // Redirect to Login
      Get.offAllNamed(AppRoutes.loginView);
    } catch (e) {
      print("❌ Logout Error: $e");
      // Fallback: Clear local data anyway to prevent being stuck
      await PreferenceHelper.clearUserData();
      Get.offAllNamed(AppRoutes.loginView);
    } finally {
      isLoading.value = false;
    }
  }
}
