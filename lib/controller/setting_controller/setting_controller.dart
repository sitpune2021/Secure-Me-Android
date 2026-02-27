import 'dart:developer' as dev;
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
    dev.log('🔄 Starting logout process...', name: 'SettingsController');

    try {
      final token = await PreferenceHelper.getToken();
      dev.log(
        '📖 Using token for logout: ${token?.substring(0, 10)}...',
        name: 'SettingsController',
      );

      // Call Logout API
      final response = await http
          .post(
            Uri.parse(AppUrl.logout),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      dev.log(
        "📡 Logout Response Status: ${response.statusCode}",
        name: 'SettingsController',
      );
      dev.log(
        "📡 Logout Response Body: ${response.body}",
        name: 'SettingsController',
      );

      isLoading.value = false;

      // Even if API fails or returns 401 (Unauthenticated), we clear local data
      await PreferenceHelper.clearUserData();
      dev.log('✅ Local session cleared', name: 'SettingsController');

      // Redirect to Login
      Get.offAllNamed(AppRoutes.loginView);
    } catch (e) {
      dev.log("❌ Logout Error: $e", name: 'SettingsController');
      // Fallback: Clear local data anyway to prevent being stuck
      await PreferenceHelper.clearUserData();
      Get.offAllNamed(AppRoutes.loginView);
    } finally {
      isLoading.value = false;
    }
  }
}
