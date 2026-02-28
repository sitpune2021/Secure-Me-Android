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
  var isLoading = false.obs;
  var isCreating = false.obs;
  var isAddingContact = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCommunities();
  }

  // ── Fetch communities (local storage only) ──────────────────────────────────
  // NOTE: Backend has no GET /community list endpoint yet.
  // Communities are saved locally when created and loaded here on startup.
  Future<void> fetchCommunities() async {
    isLoading.value = true;
    dev.log(
      '🔄 Loading communities from local storage...',
      name: 'CommunityController',
    );

    try {
      final localList = await PreferenceHelper.loadCommunities();
      communities.value = localList
          .map((e) => CommunityModel.fromJson(e))
          .toList();
      dev.log(
        '📦 Loaded ${communities.length} communities from local storage',
        name: 'CommunityController',
      );
    } catch (e) {
      dev.log(
        '❌ Error loading local communities: $e',
        name: 'CommunityController',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Create community ────────────────────────────────────────────────────────
  Future<void> createCommunity(String communityName) async {
    isCreating.value = true;
    dev.log(
      'Creating community: $communityName...',
      name: 'CommunityController',
    );

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final response = await http
          .post(
            Uri.parse(AppUrl.createCommunity),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
            body: jsonEncode({"community_name": communityName}),
          )
          .timeout(const Duration(seconds: 30));

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

      dev.log(
        '🔑 Create response keys: ${data.keys.toList()}',
        name: 'CommunityController',
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          (data['status'] == true ||
              data['status'] == 1 ||
              data['status'] == 'true')) {
        dev.log(
          '✅ Community Created Successfully!',
          name: 'CommunityController',
        );

        // ── Extract ID from the actual response structure ────────────────────
        // API response: { "data": { "community": { "id": 8, ... }, "user_community_id": 8 } }
        String? realId;
        String? realName;

        final outerData = data['data'];

        if (outerData is Map) {
          // 1. Check data['community']
          final communityNode = outerData['community'];
          if (communityNode is Map) {
            realId ??= communityNode['id']?.toString();
            realName ??=
                communityNode['community_name']?.toString() ??
                communityNode['name']?.toString();
          }

          // 2. Check data['user_community_id']
          realId ??= outerData['user_community_id']?.toString();

          // 3. Check data['id'] directly
          realId ??= outerData['id']?.toString();
          realId ??= outerData['community_id']?.toString();
          realName ??=
              outerData['community_name']?.toString() ??
              outerData['name']?.toString();
        }

        // 4. Top-level Fallbacks
        realId ??= data['id']?.toString();
        realId ??= data['community_id']?.toString();
        realId ??= data['user_community_id']?.toString();
        realName ??=
            data['community_name']?.toString() ?? data['name']?.toString();

        dev.log(
          '🆔 Extracted realId: $realId, realName: $realName',
          name: 'CommunityController',
        );

        if (realId == null || realId.isEmpty) {
          dev.log(
            '⚠️ Could not extract community id. Full body: ${response.body}',
            name: 'CommunityController',
          );
          Get.snackbar(
            "⚠️ Community Created",
            "Community was created but could not retrieve its ID. "
                "Please delete it and re-create.",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.all(16),
          );
          isCreating.value = false;
          return;
        }

        final newCommunity = CommunityModel(
          id: realId,
          name: realName ?? communityName,
          memberCount: 1,
          memberNames: ["You (Creator)"],
        );

        // Insert at top and force Obx to rebuild
        communities.insert(0, newCommunity);
        communities.refresh(); // ensures RxList notifies all Obx listeners

        // Persist locally so it survives app restarts
        await PreferenceHelper.saveCommunities(
          communities.map((c) => c.toJson()).toList(),
        );
        dev.log(
          '📌 Added & saved community with real id=${newCommunity.id}',
          name: 'CommunityController',
        );

        Get.snackbar(
          "✅ Community Created",
          data['message'] ??
              "Community \"${newCommunity.name}\" created successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      } else {
        final msg = data['message'] ?? "Failed to create community";
        Get.snackbar(
          "Error",
          msg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      dev.log('❌ Error creating community: $e', name: 'CommunityController');
      Get.snackbar(
        "Network Error",
        "Error connecting to server",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isCreating.value = false;
    }
  }

  // ── Delete community from local list ─────────────────────────────────────────
  Future<void> deleteCommunity(String communityId) async {
    communities.removeWhere((c) => c.id == communityId);
    communities.refresh();
    await PreferenceHelper.saveCommunities(
      communities.map((c) => c.toJson()).toList(),
    );
    dev.log(
      '🗑️ Deleted community $communityId from local list',
      name: 'CommunityController',
    );
  }

  // ── Add contact to a community ──────────────────────────────────────────────
  Future<void> addCommunityContact({
    required String name,
    required String phoneNo,
    required String communityId,
  }) async {
    isAddingContact.value = true;
    dev.log(
      '📤 Sending add-contact: community_id=$communityId  name=$name  phone=$phoneNo',
      name: 'CommunityController',
    );

    // ── Guard: detect fake timestamp IDs before hitting the API ────────────────
    // Real DB ids are small integers (1-9999). Timestamps are 13 digits.
    final isFakeId =
        communityId.length >= 10 &&
        int.tryParse(communityId) != null &&
        int.parse(communityId) > 9999999999;

    if (isFakeId) {
      isAddingContact.value = false;
      Get.back(); // close the sheet
      Get.snackbar(
        "⚠️ Invalid Community",
        "This community was saved with a temporary ID. "
            "Please swipe left to delete it, then re-create it.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final requestBody = {
        "community_id": communityId,
        "contacts": [
          {"name": name, "phone_no": phoneNo},
        ],
      };
      dev.log(
        '📦 Request body: ${jsonEncode(requestBody)}',
        name: 'CommunityController',
      );

      final response = await http
          .post(
            Uri.parse(AppUrl.addCommunityContact),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
            body: jsonEncode(requestBody),
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

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          (data['status'] == true ||
              data['status'] == 1 ||
              data['status'] == 'true')) {
        // ── Update local community count and members ───────────────────────
        final index = communities.indexWhere((c) => c.id == communityId);
        if (index != -1) {
          final community = communities[index];
          final updatedMemberNames = List<String>.from(community.memberNames);
          if (!updatedMemberNames.contains(name)) {
            updatedMemberNames.add(name);
          }
          communities[index] = community.copyWith(
            memberCount: community.memberCount + 1,
            memberNames: updatedMemberNames,
          );
          communities.refresh();
          PreferenceHelper.saveCommunities(
            communities.map((c) => c.toJson()).toList(),
          );
        }

        Get.back(); // Close bottom sheet
        Get.snackbar(
          "✅ Contact Added",
          data['message'] ?? "Contact added to community successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 14,
        );
      } else {
        final msg = data['message'] ?? "Failed to add contact.";
        // Give specific guidance for the "invalid community id" error
        final isInvalidId =
            msg.toLowerCase().contains('community id is invalid') ||
            msg.toLowerCase().contains('invalid');
        Get.snackbar(
          "Error",
          isInvalidId
              ? "Community ID not recognised by server. "
                    "Swipe left to delete this community and re-create it."
              : msg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: isInvalidId
              ? const Duration(seconds: 5)
              : const Duration(seconds: 3),
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
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isAddingContact.value = false;
    }
  }
}
