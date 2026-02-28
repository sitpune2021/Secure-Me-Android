import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/controller/contact_controller/contact_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/utils/preference_helper.dart';

class AddContactController extends GetxController {
  var isLoading = false.obs;
  String? _token;

  // Track if we are editing an existing contact
  var isEditing = false.obs;
  var editingContactId = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await PreferenceHelper.getToken();
    dev.log('take token from sharedrefrence', name: 'AddContactController');
  }

  Future<void> addContact({
    required String name,
    required String phoneNo,
    required String email,
    required String userRole,
  }) async {
    isLoading.value = true;
    try {
      if (_token == null || _token!.isEmpty) {
        _token = await PreferenceHelper.getToken();
      }

      if (_token == null || _token!.isEmpty) {
        Get.snackbar(
          "Error",
          "Authentication token is missing.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      String url = isEditing.value
          ? '${AppUrl.updateContact}/${editingContactId.value}'
          : AppUrl.addContact;

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_token!.trim()}',
      });

      request.fields['name'] = name;
      request.fields['phone_no'] = phoneNo;
      request.fields['email'] = email;
      request.fields['user_role'] = userRole;

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        isLoading.value = false;
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['status'] == true ||
            data['status'] == 1 ||
            data['status'] == "true") {
          Get.back(); // Go back to previous screen FIRST

          Get.snackbar(
            "Success",
            data['message'] ??
                (isEditing.value
                    ? "Contact updated successfully"
                    : "Contact added successfully"),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          if (Get.isRegistered<ContactController>()) {
            dev.log("Refreshing contact list...", name: "AddContactController");
            Get.find<ContactController>().fetchContacts(loadMore: false);
          }
        } else {
          Get.snackbar(
            "Error",
            data['message'] ??
                (isEditing.value
                    ? "Failed to update contact"
                    : "Failed to add contact"),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          data['message'] ??
              (isEditing.value
                  ? "Failed to update contact"
                  : "Failed to add contact"),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      dev.log("Error adding contact: $e");
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
