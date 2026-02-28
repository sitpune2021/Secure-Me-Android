import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/utils/preference_helper.dart';

class SosController extends GetxController {
  var isTriggering = false.obs;
  var triggerMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Start SOS trigger as soon as the view opens
    triggerSos();
  }

  Future<void> triggerSos() async {
    isTriggering.value = true;
    dev.log(
      '🚨 Fetching current location to trigger SOS...',
      name: 'SosController',
    );

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        dev.log('❌ No token found, cannot trigger SOS.', name: 'SosController');
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      // TODO: Replace with actual device GPS coordinates
      // For now, using the coordinates provided in the requirements
      final Map<String, dynamic> body = {
        "latitude": "18.48873120",
        "longitude": "73.85786330",
      };

      final response = await http
          .post(
            Uri.parse(AppUrl.signalTrigger),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      dev.log(
        '📡 SOS Trigger Response Status: ${response.statusCode}',
        name: 'SosController',
      );
      dev.log(
        '📡 SOS Trigger Response Body: ${response.body}',
        name: 'SosController',
      );

      if (response.statusCode == 401) {
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        triggerMessage.value = data['message'] ?? "Signal activated.";
        dev.log('✅ SOS Triggered Successfully!', name: 'SosController');

        Get.snackbar(
          "SOS Alert Sent",
          triggerMessage.value,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      } else {
        triggerMessage.value = data['message'] ?? "Failed to trigger SOS";
        dev.log(
          '❌ Failed to trigger SOS: ${triggerMessage.value}',
          name: 'SosController',
        );

        Get.snackbar(
          "Error Code ${response.statusCode}",
          triggerMessage.value,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      dev.log('❌ Error triggering SOS: $e', name: 'SosController');
      triggerMessage.value = "Error connecting to server";
    } finally {
      isTriggering.value = false;
    }
  }

  // Handle responding to an SOS signal
  var isResponding = false.obs;

  Future<void> respondToSignal({
    required int signalId,
    required String action,
    required String notes,
  }) async {
    isResponding.value = true;
    dev.log('🚨 Responding to SOS Signal $signalId...', name: 'SosController');

    try {
      String? token = await PreferenceHelper.getToken();

      if (token == null || token.isEmpty) {
        dev.log(
          '❌ No token found, cannot respond to SOS.',
          name: 'SosController',
        );
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final Map<String, dynamic> body = {
        "signal_id": signalId,
        "action": action,
        "notes": notes,
      };

      final response = await http
          .post(
            Uri.parse(AppUrl.signalRespond),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${token.trim()}',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      dev.log(
        '📡 SOS Respond Status: ${response.statusCode}',
        name: 'SosController',
      );
      dev.log('📡 SOS Respond Body: ${response.body}', name: 'SosController');

      if (response.statusCode == 401) {
        await PreferenceHelper.clearUserData();
        Get.offAllNamed(AppRoutes.loginView);
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        dev.log('✅ SOS Responsed Successfully!', name: 'SosController');

        Get.snackbar(
          "Response Registered",
          data['message'] ?? "You are now linked to this emergency.",
          backgroundColor: Colors.green, // Ensure green feedback
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      } else {
        dev.log(
          '❌ Failed to respond to SOS: ${data['message']}',
          name: 'SosController',
        );

        Get.snackbar(
          "Error Code ${response.statusCode}",
          data['message'] ?? "Failed to respond to SOS",
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      dev.log('❌ Error responding to SOS: $e', name: 'SosController');
      Get.snackbar(
        "Network Error",
        "Error connecting to server",
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isResponding.value = false;
    }
  }
}
