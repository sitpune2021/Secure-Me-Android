import 'package:flutter/material.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:secure_me/core/theme.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/view/login_screen.dart';
import 'package:secure_me/view/home_screen.dart';
import 'package:secure_me/view/helper_dashboard.dart';
import 'package:secure_me/view/police_dashboard.dart';
import 'package:secure_me/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // Essential controllers
  Get.put(AuthController());
  Get.put(ThemeController());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const SecureMeApp());
}

class SecureMeApp extends StatelessWidget {
  const SecureMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Secure Me – 7 Seconds',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: AppRouter(),
      getPages: AppPages.pages,
    );
  }
}

class AppRouter extends StatelessWidget {
  AppRouter({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
       final user = _authController.user.value;
       
       if (user != null) {
          switch (user.role) {
            case UserRole.user:
              return UserHomeScreen();
            case UserRole.helper:
              return const HelperDashboard();
            case UserRole.police:
              return PoliceDashboard();
          }
       }
       
       return const LoginScreen();
    });
  }
}
