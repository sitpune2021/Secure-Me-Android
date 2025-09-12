import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_me/theme/app_theme.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  var isDarkMode = false.obs;
  var userOverride = false.obs; // 👈 track if user manually toggled

  ThemeData get theme => isDarkMode.value ? AppTheme.dark : AppTheme.light;

  @override
  void onInit() {
    super.onInit();

    // ✅ Check saved preference
    if (_storage.hasData(_key)) {
      isDarkMode.value = _storage.read(_key);
      userOverride.value = true;
    } else {
      // ✅ Otherwise follow system
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = brightness == Brightness.dark;
    }

    Get.changeTheme(theme);
    _setSystemUI(isDarkMode.value);

    // ✅ Listen for system theme changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
          if (!userOverride.value) {
            final brightness =
                WidgetsBinding.instance.platformDispatcher.platformBrightness;
            final systemDark = brightness == Brightness.dark;

            isDarkMode.value = systemDark;
            Get.changeTheme(theme);
            _setSystemUI(systemDark);
          }
        };
  }

  void toggleTheme(bool value) {
    userOverride.value = true; // 👈 mark that user manually changed
    isDarkMode.value = value;
    Get.changeTheme(theme);
    _setSystemUI(value);
    _storage.write(_key, value);
  }

  void _setSystemUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark
            ? AppTheme.dark.scaffoldBackgroundColor
            : AppTheme.light.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }
}
