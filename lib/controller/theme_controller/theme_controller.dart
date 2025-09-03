import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_me/theme/app_theme.dart';

class ThemeController extends GetxController {
  // Reactive bool
  var isDarkMode = false.obs;

  // Current theme
  ThemeData get theme => isDarkMode.value ? AppTheme.dark : AppTheme.light;

  // Toggle function
  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeTheme(theme); // 🔥 apply immediately
  }
}
