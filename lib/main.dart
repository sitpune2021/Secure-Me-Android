import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_me/controller/permission_controller/permission_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/routes/app_routes.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:secure_me/utils/preference_helper.dart';
import 'package:upgrader/upgrader.dart';

// Global variable to store initial route
String initialRoute = AppRoutes.loginView;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Ensure the GetStorage directory exists before initializing
    final dir = await getApplicationDocumentsDirectory();
    Directory(dir.path).createSync(recursive: true);

    // ✅ Initialize GetStorage (new API — only 1 arg max)
    await GetStorage.init();

    // ✅ Check login status and session validity
    await _checkLoginStatus();

    // ✅ Register controllers AFTER storage initialization
    Get.put(PermissionController());
    final themeController = Get.put(ThemeController());

    // ✅ Safe delayed storage access (avoids early read)
    Future.microtask(() async {
      final storage = GetStorage();
      try {
        bool askedBefore = storage.read('permissionsRequested') ?? false;
        // await Get.find<PermissionController>().requestAllPermissions();
        if (!askedBefore) storage.write('permissionsRequested', true);
      } catch (e) {
        if (kDebugMode) print('permission request error: $e');
      }
    });

    // ✅ Launch the app
    runApp(MyApp(themeController: themeController));
  } catch (e, st) {
    debugPrint('❌ GetStorage initialization failed: $e\n$st');
  }
}

/// Check if user is logged in and session is valid
Future<void> _checkLoginStatus() async {
  try {
    print('🔍 Checking login status...');

    final isLoggedIn = await PreferenceHelper.getLoginStatus();
    print('📖 Login status: $isLoggedIn');

    if (isLoggedIn) {
      // Check if session is still valid (within 30 days)
      final isSessionValid = await PreferenceHelper.isSessionValid();
      print('📖 Session valid: $isSessionValid');

      if (isSessionValid) {
        final userName = await PreferenceHelper.getUserName();
        final sessionId = await PreferenceHelper.getSessionId();
        print('✅ Auto-login: User is logged in as: $userName');
        print('✅ Session ID: $sessionId');

        // Update last login time
        await PreferenceHelper.updateLastLoginTime();

        // Set initial route to home
        initialRoute = AppRoutes.homeView;
        print('🚀 Redirecting to home screen');
      } else {
        print('⚠️ Session expired, clearing user data');
        await PreferenceHelper.clearUserData();
        initialRoute = AppRoutes.loginView;
      }
    } else {
      print('ℹ️ User not logged in, showing login screen');
      initialRoute = AppRoutes.loginView;
    }
  } catch (e) {
    print('❌ Error checking login status: $e');
    initialRoute = AppRoutes.loginView;
  }
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final effectiveDark = themeController.userOverride.value
          ? themeController.isDarkMode.value
          : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: effectiveDark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: effectiveDark
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor: effectiveDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          systemNavigationBarIconBrightness: effectiveDark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: UpgradeAlert(
          upgrader: Upgrader(
            debugDisplayAlways: false,
            minAppVersion: '99.0.0',
            durationUntilAlertAgain: const Duration(days: 2),
          ),
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Secure Me',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeController.userOverride.value
                ? (themeController.isDarkMode.value
                      ? ThemeMode.dark
                      : ThemeMode.light)
                : ThemeMode.system,
            initialRoute:
                initialRoute, // Use dynamic route based on login status
            getPages: AppPages.pages,
            builder: (context, child) {
              final widgetChild = child ?? const SizedBox.shrink();
              if (effectiveDark) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.darkBackground, AppColors.accent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: widgetChild,
                );
              }
              return widgetChild;
            },
          ),
        ),
      );
    });
  }
}
