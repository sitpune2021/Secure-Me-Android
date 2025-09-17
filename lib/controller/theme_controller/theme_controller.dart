import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_me/theme/app_theme.dart';

enum ThemeOption { light, dark, system }

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  var isDarkMode = false.obs; // current theme mode
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

    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (!userOverride.value) {
        _applySystemTheme();
      }
    };

    ever(isDarkMode, (_) => _updateStatusBar());
    _updateStatusBar();
  }

  void _applySystemTheme() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode.value = (brightness == Brightness.dark);
    Get.changeThemeMode(ThemeMode.system);
  }

  /// Explicit Theme Setters
  void setThemeMode(bool dark) {
    userOverride.value = true;
    isDarkMode.value = dark;
    _storage.write(_key, dark);
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }

  void setSystemTheme() {
    resetToSystem();
  }

  void resetToSystem() {
    userOverride.value = false;
    _storage.remove(_key);
    _applySystemTheme();
  }

  ThemeOption get currentOption {
    if (!userOverride.value) return ThemeOption.system;
    return isDarkMode.value ? ThemeOption.dark : ThemeOption.light;
  }

  /// ✅ NEW: handles system + user modes
  bool get effectiveDarkMode {
    if (!userOverride.value) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return isDarkMode.value;
  }

  /// ✅ Updated to use effectiveDarkMode
  ThemeData get theme => effectiveDarkMode ? AppTheme.dark : AppTheme.light;

  /// ✅ Updated to use effectiveDarkMode
  void _updateStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          effectiveDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness:
          effectiveDarkMode ? Brightness.dark : Brightness.light,
    ));
  }
}
