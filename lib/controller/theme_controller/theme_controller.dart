import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_me/theme/app_theme.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  var isDarkMode = false.obs; // current theme
  var userOverride = false.obs; // true if user toggled manually

  @override
  void onInit() {
    super.onInit();

    if (_storage.hasData(_key)) {
      // User manually set theme previously
      isDarkMode.value = _storage.read(_key);
      userOverride.value = true;
      _applyTheme(isDarkMode.value);
    } else {
      // Follow system theme by default
      userOverride.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        isDarkMode.value = brightness == Brightness.dark;
        _applyTheme(isDarkMode.value);
      });
    }

    // Listen for system theme changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
          if (!userOverride.value) {
            final brightness =
                WidgetsBinding.instance.platformDispatcher.platformBrightness;
            isDarkMode.value = brightness == Brightness.dark;
            _applyTheme(isDarkMode.value);
          }
        };
  }

  ThemeData get theme => isDarkMode.value ? AppTheme.dark : AppTheme.light;

  void toggleTheme(bool value) {
    userOverride.value = true;
    isDarkMode.value = value;
    _storage.write(_key, value);
    _applyTheme(value);
  }

  void resetToSystem() {
    userOverride.value = false;
    _storage.remove(_key);
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode.value = brightness == Brightness.dark;
    _applyTheme(isDarkMode.value);
  }

  void _applyTheme(bool dark) {
    Get.changeThemeMode(
      userOverride.value
          ? (dark ? ThemeMode.dark : ThemeMode.light)
          : ThemeMode.system,
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: dark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: dark
            ? AppTheme.dark.scaffoldBackgroundColor
            : AppTheme.light.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }
}
