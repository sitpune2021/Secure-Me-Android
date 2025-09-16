import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_me/theme/app_theme.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  var isDarkMode = false.obs; // current theme mode
  var userOverride = false.obs; // true if manually toggled

  @override
  void onInit() {
    super.onInit();

    // Load stored preference if available
    if (_storage.hasData(_key)) {
      isDarkMode.value = _storage.read(_key) as bool;
      userOverride.value = true;
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    } else {
      userOverride.value = false;
      _applySystemTheme();
    }

    // Listen for system brightness changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (!userOverride.value) {
        _applySystemTheme();
      }
    };

    // Update status bar when theme changes
    ever(isDarkMode, (_) => _updateStatusBar());

    // Initial status bar setup
    _updateStatusBar();
  }

  // Apply system theme
  void _applySystemTheme() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode.value = (brightness == Brightness.dark);
    Get.changeThemeMode(ThemeMode.system);
  }

  // Toggle theme manually
  void toggleTheme(bool value) {
    userOverride.value = true;
    isDarkMode.value = value;
    _storage.write(_key, value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  // Reset to system theme
  void resetToSystem() {
    userOverride.value = false;
    _storage.remove(_key);
    _applySystemTheme();
  }

  // Get current ThemeData
  ThemeData get theme => isDarkMode.value ? AppTheme.dark : AppTheme.light;

  // Update status bar colors and brightness
  void _updateStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode.value ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode.value ? Brightness.dark : Brightness.light,
    ));
  }
}
