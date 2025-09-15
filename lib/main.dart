import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:secure_me/controller/permission_controller/permission_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/routes/app_routes.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/theme/app_theme.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize controllers
  final permissionController = Get.put(PermissionController());
  final storage = GetStorage();
  Get.put(ThemeController()); // register theme controller

  runApp(MyApp());

  // Request permissions on first launch
  Future.delayed(Duration.zero, () async {
    bool isFirstLaunch = storage.read('permissionsRequested') ?? false;
    if (!isFirstLaunch) {
      await permissionController.requestAllPermissions();
      storage.write('permissionsRequested', true);
    }
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ If user overrode, use stored value; otherwise use system brightness
      final effectiveDark = themeController.userOverride.value
          ? themeController.isDarkMode.value
          : MediaQuery.of(context).platformBrightness == Brightness.dark;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              effectiveDark ? Brightness.light : Brightness.dark,
          statusBarBrightness:
              effectiveDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor:
              effectiveDark ? AppColors.darkBackground : AppColors.lightBackground,
          systemNavigationBarIconBrightness:
              effectiveDark ? Brightness.light : Brightness.dark,
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
            // ✅ system by default, override if user toggled
            themeMode: themeController.userOverride.value
                ? (themeController.isDarkMode.value
                    ? ThemeMode.dark
                    : ThemeMode.light)
                : ThemeMode.system,
            initialRoute: AppRoutes.loginView,
            getPages: AppPages.pages,
            builder: (context, child) {
              if (effectiveDark) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.darkBackground, AppColors.accent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: child,
                );
              }
              return child!;
            },
          ),
        ),
      );
    });
  }
}
