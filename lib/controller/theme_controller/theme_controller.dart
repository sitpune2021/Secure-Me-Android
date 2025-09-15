import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_me/theme/app_theme.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  var isDarkMode = false.obs; // reflects active theme
  var userOverride = false.obs; // true if manually toggled

  @override
  void onInit() {
    super.onInit();

    if (_storage.hasData(_key)) {
      isDarkMode.value = _storage.read(_key) as bool;
      userOverride.value = true;
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    } else {
      userOverride.value = false;
      _applySystemTheme();
    }

    // React to system brightness change
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (!userOverride.value) {
        _applySystemTheme();
      }
    };

    // Listen to isDarkMode changes and update status bar
    ever(isDarkMode, (_) {
      _updateStatusBar();
    });

    _updateStatusBar(); // initial set
  }

  void _applySystemTheme() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode.value = (brightness == Brightness.dark);
    Get.changeThemeMode(ThemeMode.system);
  }

  void toggleTheme(bool value) {
    userOverride.value = true;
    isDarkMode.value = value;
    _storage.write(_key, value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void resetToSystem() {
    userOverride.value = false;
    _storage.remove(_key);
    _applySystemTheme();
  }

  ThemeData get theme => isDarkMode.value ? AppTheme.dark : AppTheme.light;

 void _updateStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent always
    statusBarIconBrightness: isDarkMode.value ? Brightness.dark : Brightness.dark, // Android
    statusBarBrightness: isDarkMode.value ? Brightness.dark : Brightness.dark, // iOS
  ));
}
}
