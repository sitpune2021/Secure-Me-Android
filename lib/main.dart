import 'package:flutter/material.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/view/login_screen.dart';
import 'package:secure_me/view/helper_dashboard.dart';
import 'package:secure_me/view/user_dashboard.dart';
import 'package:secure_me/view/police_dashboard.dart';
import 'package:secure_me/routes/app_routes.dart';

import 'package:secure_me/controller/profile_controller/profile_controller.dart';
import 'package:secure_me/controller/permission_controller/permission_controller.dart';
import 'package:secure_me/controller/location_controller.dart';
import 'package:secure_me/controller/community_safety_controller.dart';
import 'package:secure_me/controller/incident_controller.dart';
import 'package:secure_me/view/home_view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // Load critical controllers and ensure they persist across the app lifecycle
  Get.put(ThemeController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  Get.put(PermissionController(), permanent: true);
  Get.put(LocationController(), permanent: true);
  Get.put(CommunitySafetyController(), permanent: true);
  Get.put(IncidentController(), permanent: true);

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
    final themeController = Get.find<ThemeController>();
    
    return Obx(() => GetMaterialApp(
      title: 'Secure Me – 7 Seconds',
      debugShowCheckedModeBanner: false,
      theme: themeController.currentTheme.value,
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialBinding: InitialBinding(), // Use binding for consistent controller access
      home: AppRouter(),
      getPages: AppPages.pages,
    ));
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(PermissionController(), permanent: true);
    Get.put(LocationController(), permanent: true);
    Get.put(CommunitySafetyController(), permanent: true);
    Get.put(IncidentController(), permanent: true);
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
            case UserRole.Manager:
              // Managers see the HQ dashboard, regular users see the home view
              if (user.roleString == 'Manager') {
                 return const UserDashboard();
              }
              return const HomeView();
            case UserRole.Gym_Person:
              return const HelperDashboard();
            case UserRole.police:
              return PoliceDashboard();
          }
       }
       
       return const LoginScreen();
    });
  }
}
