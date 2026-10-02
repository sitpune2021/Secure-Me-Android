
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/controller/contact_controller/contact_controller.dart';
import 'package:secure_me/app/routes/app_pages.dart';
import 'package:secure_me/core/utils/preference_helper.dart';
import 'package:secure_me/core/utils/validator.dart';
import 'package:secure_me/view/common/app_snackbar.dart';

class AddContactController extends GetxController {
  var isLoading = false.obs;
  String? _token;

  var isEditing = false.obs;
  var editingContactId = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await PreferenceHelper.getToken();
    dev.log(
      'token loaded from shared preferences',
      name: 'AddContactController',
    );
  }

  Future<void> addContact({
    required String name,
    required String phoneNo,
    required String email,
    required String userRole,
    int priority = 1,
    bool isNotifyOnSos = true,
    double? latitude,
    double? longitude,
  }) async {
    final nameError = Validator.validateName(name);
    final phoneError = Validator.validatePhone(phoneNo);
    final emailError = (email.isNotEmpty)
        ? Validator.validateEmail(email)
        : null;

    if (nameError != null || phoneError != null || emailError != null) {
      AppSnackbar.show(
        title: "Validation Error",
        message: nameError ?? phoneError ?? emailError!,
        isError: true,
      );
      return;
    }

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

      // ✅ Log API URL
      dev.log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        name: 'AddContactController',
      );
      dev.log('📡 API URL     : $url', name: 'AddContactController');
      dev.log(
        '📝 Method      : POST (MultipartRequest)',
        name: 'AddContactController',
      );
      dev.log(
        '🔑 Token       : ${_token!.trim()}',
        name: 'AddContactController',
      );

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_token!.trim()}',
      });

      request.fields['name'] = name;
      request.fields['phone_no'] = phoneNo;
      request.fields['email'] = email;
      request.fields['user_role'] = userRole;
      request.fields['priority'] = priority.toString();
      request.fields['is_notify_on_sos'] = isNotifyOnSos ? "1" : "0";
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();

      // ✅ Log all fields being sent
      dev.log('📦 Request Fields:', name: 'AddContactController');
      request.fields.forEach((key, value) {
        dev.log('   $key: $value', name: 'AddContactController');
      });
      dev.log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        name: 'AddContactController',
      );

      dev.log(
        'Sending contact: name=$name, phone=$phoneNo, role=$userRole, lat=$latitude, lng=$longitude',
        name: 'AddContactController',
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      // ✅ Log response
      dev.log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        name: 'AddContactController',
      );
      dev.log(
        '📥 Response Status : ${response.statusCode}',
        name: 'AddContactController',
      );
      dev.log(
        '📥 Response Body   : ${response.body}',
        name: 'AddContactController',
      );
      dev.log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        name: 'AddContactController',
      );

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
          dev.log(
            '✅ Contact ${isEditing.value ? "updated" : "added"} successfully',
            name: 'AddContactController',
          );

          // 1️⃣ Refresh list FIRST so data is ready when we land back
          if (Get.isRegistered<ContactController>()) {
            dev.log(
              '🔄 Refreshing contact list...',
              name: 'AddContactController',
            );
            await Get.find<ContactController>().fetchContacts(loadMore: false);
          }

          // 2️⃣ Navigate back
          Get.back();
          // Show snackbar FIRST before navigating back
          Get.snackbar(
            "Success",
            data['message'] ??
                (isEditing.value
                    ? "Contact updated successfully"
                    : "Contact added successfully"),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            animationDuration: const Duration(milliseconds: 300),
          );
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
      dev.log("Error adding contact: $e", name: 'AddContactController');
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
