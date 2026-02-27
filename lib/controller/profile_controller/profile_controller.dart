import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    dev.log('🔄 Fetching user profile...', name: 'ProfileController');

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        dev.log(
          '❌ No token found, cannot fetch profile.',
          name: 'ProfileController',
        );
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(AppUrl.profile),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      isLoading.value = false;
      dev.log(
        '📡 Profile Response Status: ${response.statusCode}',
        name: 'ProfileController',
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        userData.value = data['data']['user'];
        dev.log(
          '✅ Profile retrieved successfully: ${userData['name']}',
          name: 'ProfileController',
        );

        // Sync local storage with latest data from server
        await PreferenceHelper.saveUserName(userData['name']);
        await PreferenceHelper.saveUserEmail(userData['email']);
        await PreferenceHelper.saveUserPhone(userData['phone_no']);
        await PreferenceHelper.saveUserProfileImage(userData['profile_image']);
      } else {
        dev.log(
          '❌ Failed to retrieve profile: ${data['message']}',
          name: 'ProfileController',
        );
      }
    } catch (e) {
      isLoading.value = false;
      dev.log('❌ Error fetching profile: $e', name: 'ProfileController');
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    dev.log('🔄 Logging out...', name: 'ProfileController');

    try {
      String? token = await PreferenceHelper.getToken();
      if (token != null && token.isNotEmpty) {
        // According to user request #6, logout is a GET request to /api/auth/logout
        await http.get(
          Uri.parse(AppUrl.logout),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      await PreferenceHelper.clearUserData();
      isLoading.value = false;
      dev.log('✅ Logout successful', name: 'ProfileController');

      Get.snackbar(
        "Logout",
        "Successfully logged out from current session.",
        backgroundColor: AppColors.lightPrimary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(AppRoutes.loginView);
    } catch (e) {
      isLoading.value = false;
      dev.log('❌ Error during logout: $e', name: 'ProfileController');
      // Even if API fails, clear local data and go to login
      await PreferenceHelper.clearUserData();
      Get.offAllNamed(AppRoutes.loginView);
    }
  }
}
