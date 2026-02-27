import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
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
    fetchUserRole();
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
        userData.value = data['data'];
        dev.log(
          '✅ Profile retrieved successfully: ${userData['name']}',
          name: 'ProfileController',
        );

        // Sync local storage with latest data from server
        await PreferenceHelper.saveUserName(userData['name'] ?? '');
        await PreferenceHelper.saveUserEmail(userData['email'] ?? '');
        await PreferenceHelper.saveUserPhone(userData['phone_no'] ?? '');
        if (userData['profile_image'] != null) {
          await PreferenceHelper.saveUserProfileImage(
            userData['profile_image'],
          );
        }
        if (userData['user_role'] != null) {
          await PreferenceHelper.saveUserRole(userData['user_role']);
        }
        if (userData['created_at'] != null) {
          await PreferenceHelper.saveUserCreatedAt(userData['created_at']);
        }
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

  Future<void> fetchUserRole() async {
    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(AppUrl.userRole),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        String role = data['user_role'] ?? 'User';
        userData['user_role'] = role;
        userData.refresh();
        await PreferenceHelper.saveUserRole(role);

        dev.log(
          '✅ User role fetched successfully: $role',
          name: 'ProfileController',
        );
      }
    } catch (e) {
      dev.log('❌ Error fetching user role: $e', name: 'ProfileController');
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  }) async {
    isLoading.value = true;
    dev.log('🔄 Updating user profile...', name: 'ProfileController');

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return false;
      }

      // Use MultipartRequest for profile update to support image
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.updateProfile),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone_no'] = phone;
      request.fields['_method'] =
          'PUT'; // Common requirement for Laravel multipart updates

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
        dev.log(
          '📸 Profile image attached: ${image.path}',
          name: 'ProfileController',
        );
      }

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      var response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        dev.log(
          '✅ Profile updated successfully: ${data['message']}',
          name: 'ProfileController',
        );

        // Fetch fresh profile data to sync everything
        await fetchProfile();

        return true;
      } else {
        isLoading.value = false;
        dev.log(
          '❌ Failed to update profile: ${data['message']}',
          name: 'ProfileController',
        );
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to update profile",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      dev.log('❌ Error updating profile: $e', name: 'ProfileController');
      Get.snackbar(
        "Error",
        "Could not connect to the server",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
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
