import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/model/community_model.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/utils/preference_helper.dart';

class CommunityController extends GetxController {
  var communities = <CommunityModel>[].obs;
  var isCreating = false.obs;
  var isAddingContact = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCommunities();
  }

  void loadCommunities() {
    communities.value = [
      CommunityModel(name: "Emergency Helping Group", members: "10 K members"),
      CommunityModel(name: "Be Women Society", members: "10 K members"),
      CommunityModel(name: "Family Members", members: "50 members"),
      CommunityModel(name: "My Friends", members: "100 Members"),
      CommunityModel(name: "League Lady Power", members: "1k Members"),
      CommunityModel(name: "World Of Angels", members: "2k Members"),
    ];
  }

  Future<void> createCommunity(String communityName) async {
    isCreating.value = true;
    dev.log(
      'Creating community: $communityName...',
      name: 'CommunityController',
    );

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        dev.log(
          '❌ No token found, cannot create community.',
          name: 'CommunityController',
        );
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final Map<String, dynamic> body = {"community_name": communityName};

      final response = await http
          .post(
            Uri.parse(AppUrl.createCommunity),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      dev.log(
        '📡 Create Community Status: ${response.statusCode}',
        name: 'CommunityController',
      );
      dev.log(
        '📡 Create Community Body: ${response.body}',
        name: 'CommunityController',
      );

      if (response.statusCode == 401) {
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['status'] == true ||
            data['status'] == 1 ||
            data['status'] == "true") {
          dev.log(
            '✅ Community Created Successfully!',
            name: 'CommunityController',
          );

          // Optionally add it locally to bypass reloading temporarily or reload the list
          // communities.insert(0, CommunityModel(name: communityName, members: "1 Member"));

          Get.snackbar(
            "Success",
            data['message'] ?? "Community created successfully.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
        } else {
          dev.log(
            '❌ Failed to create community: ${data['message']}',
            name: 'CommunityController',
          );

          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to create community",
            backgroundColor: Get.theme.colorScheme.errorContainer,
            colorText: Get.theme.colorScheme.onErrorContainer,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to create community",
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      dev.log('❌ Error creating community: $e', name: 'CommunityController');
      Get.snackbar(
        "Network Error",
        "Error connecting to server",
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> addCommunityContact({
    required String name,
    required String phoneNo,
    required String communityId,
  }) async {
    isAddingContact.value = true;
    dev.log(
      'Adding contact to community $communityId: $name ($phoneNo)',
      name: 'CommunityController',
    );

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        dev.log(
          '❌ No token found, cannot add community contact.',
          name: 'CommunityController',
        );
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final Map<String, dynamic> body = {
        "name": name,
        "phone_no": phoneNo,
        "community_id": communityId,
      };

      final response = await http
          .post(
            Uri.parse(AppUrl.addCommunityContact),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      dev.log(
        '📡 Add Community Contact Status: ${response.statusCode}',
        name: 'CommunityController',
      );
      dev.log(
        '📡 Add Community Contact Body: ${response.body}',
        name: 'CommunityController',
      );

      if (response.statusCode == 401) {
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['status'] == true ||
            data['status'] == 1 ||
            data['status'] == "true") {
          dev.log(
            '✅ Contact added to community successfully!',
            name: 'CommunityController',
          );
          Get.back();
          Get.snackbar(
            "✅ Success",
            data['message'] ?? "Contact added to community successfully.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 14,
          );
        } else {
          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to add contact.",
            backgroundColor: Get.theme.colorScheme.errorContainer,
            colorText: Get.theme.colorScheme.onErrorContainer,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
        }
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to add contact.",
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      dev.log(
        '❌ Error adding community contact: $e',
        name: 'CommunityController',
      );
      Get.snackbar(
        "Network Error",
        "Error connecting to server. Please try again.",
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isAddingContact.value = false;
    }
  }
}
