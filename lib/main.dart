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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize controllers
  final permissionController = Get.put(PermissionController());
  final storage = GetStorage();
  final themeController = Get.put(ThemeController());
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
      final isDark = themeController.isDarkMode.value;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Secure Me',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.userOverride.value
              ? (isDark ? ThemeMode.dark : ThemeMode.light)
              : ThemeMode.system, // ✅ Follow system if user hasn't toggled

          initialRoute: AppRoutes.loginView,
          getPages: AppPages.pages,
          builder: (context, child) {
            if (isDark) {
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
      );
    });
  }
}
