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
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Ensure the GetStorage directory exists before initializing
    final dir = await getApplicationDocumentsDirectory();
    Directory(dir.path).createSync(recursive: true);

    // ✅ Initialize GetStorage (new API — only 1 arg max)
    await GetStorage.init();

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
            initialRoute: AppRoutes.loginView,
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
