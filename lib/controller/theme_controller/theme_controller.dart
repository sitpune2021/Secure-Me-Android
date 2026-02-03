import 'dart:developer';
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

    log('🎨 ThemeController: Initializing...', name: 'ThemeController');

    if (_storage.hasData(_key)) {
      isDarkMode.value = _storage.read(_key) as bool;
      userOverride.value = true;
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      log(
        '🎨 ThemeController: Loaded saved theme - Dark mode: ${isDarkMode.value}',
        name: 'ThemeController',
      );
    } else {
      userOverride.value = false;
      _applySystemTheme();
      log(
        '🎨 ThemeController: No saved theme, using system theme',
        name: 'ThemeController',
      );
    }

    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
          if (!userOverride.value) {
            log(
              '🎨 ThemeController: System brightness changed, updating theme',
              name: 'ThemeController',
            );
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
    log(
      '🎨 ThemeController: Applied system theme - Dark mode: ${isDarkMode.value}',
      name: 'ThemeController',
    );
  }

  /// Explicit Theme Setters
  void setThemeMode(bool dark) {
    log(
      '🎨 ThemeController: Setting theme mode - Dark: $dark',
      name: 'ThemeController',
    );
    userOverride.value = true;
    isDarkMode.value = dark;
    _storage.write(_key, dark);
    log(
      '✅ ThemeController: Theme saved to storage - Dark mode: $dark',
      name: 'ThemeController',
    );
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }

  void setSystemTheme() {
    resetToSystem();
  }

  void resetToSystem() {
    log(
      '🎨 ThemeController: Resetting to system theme',
      name: 'ThemeController',
    );
    userOverride.value = false;
    _storage.remove(_key);
    log(
      '✅ ThemeController: Theme preference removed from storage',
      name: 'ThemeController',
    );
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: effectiveDarkMode
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: effectiveDarkMode
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }
}
