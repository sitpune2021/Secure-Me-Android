import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/model/user_model.dart';

enum ThemeOption { light, dark, system }

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  // State
  var isDarkMode = false.obs;
  var userOverride = false.obs;
  late Rx<ThemeData> currentTheme;

  @override
  void onInit() {
    super.onInit();

    log('🎨 ThemeController: Initializing...', name: 'ThemeController');
    currentTheme = theme.obs;

    if (_storage.hasData(_key)) {
      isDarkMode.value = _storage.read(_key) as bool;
      userOverride.value = true;
    } else {
      userOverride.value = false;
      _applySystemTheme();
    }

    // React to system brightness
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (!userOverride.value) {
        _applySystemTheme();
      }
    };

    // React to global changes that affect theme
    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();
      
      // Update when user logs in/out or role selection changes
      ever(auth.user, (user) => _syncTheme(user?.role));
      ever(auth.selectedRole, (role) => _syncTheme(auth.user.value?.role ?? role));
    }
    
    // Initial sync
    _syncTheme();
    _updateStatusBar();
  }

  void _syncTheme([UserRole? activeRole]) {
    log('🎨 ThemeController: Syncing theme...', name: 'ThemeController');
    currentTheme.value = theme;
    Get.changeTheme(theme);
    _updateStatusBar();
  }

  void _applySystemTheme() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode.value = (brightness == Brightness.dark);
    Get.changeThemeMode(ThemeMode.system);
  }

  void setThemeMode(bool dark) {
    userOverride.value = true;
    isDarkMode.value = dark;
    _storage.write(_key, dark);
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
    _syncTheme();
  }

  void setSystemTheme() {
    resetToSystem();
  }

  void resetToSystem() {
    userOverride.value = false;
    _storage.remove(_key);
    _applySystemTheme();
    _syncTheme();
  }

  bool get effectiveDarkMode {
    if (!userOverride.value) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return isDarkMode.value;
  }

  /// ✅ This getter uses the auth state to return the correct role theme
  ThemeData get theme {
    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();
      final user = auth.user.value;
      final role = user?.role ?? auth.selectedRole.value;
      return AppTheme.getThemeForRole(role.name, isDark: effectiveDarkMode);
    }
    return AppTheme.getThemeForRole('user', isDark: effectiveDarkMode);
  }

  void _updateStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: effectiveDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: effectiveDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }
}
