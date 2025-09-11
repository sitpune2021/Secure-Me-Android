import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_me/theme/app_theme.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  var isDarkMode = false.obs;

  ThemeData get theme => isDarkMode.value ? AppTheme.dark : AppTheme.light;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.read(_key) ?? false;
    Get.changeTheme(theme);
    _setSystemUI(isDarkMode.value);
  }

  void toggleTheme(bool value) {
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
