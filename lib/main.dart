import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/routes/app_routes.dart';
import 'package:secure_me/theme/app_theme.dart';

void main() async {
  final ThemeController themeController = Get.put(ThemeController());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Secure Me',
        theme: themeController.isDarkMode.value
            ? AppTheme.dark
            : AppTheme.light,
        initialRoute: AppRoutes.loginView,
        getPages: AppPages.pages,
      ),
    );
  }
}
