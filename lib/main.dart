import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:developer' as dev;
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
  // We put them here so they are available immediately. 
  // We use permanent: true to ensure they are not disposed.
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
  runApp(
    const ProviderScope(
      child: SecureMeApp(),
    ),
  );
}

class SecureMeApp extends StatelessWidget {
  const SecureMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Secure Me – 7 Seconds',
      debugShowCheckedModeBanner: false,
      // Use Obx only for the values that actually change
      theme: Get.find<ThemeController>().currentTheme.value,
      themeMode: Get.find<ThemeController>().isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      // Make font size smaller and responsive across the whole app
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final screenWidth = mediaQueryData.size.width;
        // Calculate responsive scale based on a standard mobile width (e.g., 390px)
        double responsiveScale = screenWidth / 390.0;
        // Clamp it to prevent overly giant or minuscule text on extreme screen sizes
        responsiveScale = responsiveScale.clamp(0.8, 1.2);
        // Apply a base reduction to make the overall font size smaller
        double smallFactor = 0.85;
        double finalScale = responsiveScale * smallFactor;

        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: TextScaler.linear(finalScale),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      // home: AppRouter(), // We will use a wrapper that ensures controllers are found
      home: const AppRouterWrapper(),
      getPages: AppPages.pages,
    );
  }
}

// Wrapper to ensure AuthController is found by AppRouter
class AppRouterWrapper extends StatelessWidget {
  const AppRouterWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRouter();
  }
}

class AppRouter extends StatelessWidget {
  AppRouter({super.key});

  // Access AuthController lazily inside build or as a field if already put
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
       final user = _authController.user.value;
       
       if (user != null) {
          dev.log('🚦 Routing user with role: ${user.role} and roleString: ${user.roleString}', name: 'AppRouter');
          
          switch (user.role) {
            case UserRole.Manager:
              // Access specialized dashboard for Manager role
              if (user.roleString.toLowerCase() == 'manager') {
                 return const UserDashboard();
              }
              // Fallback to regular HomeView for generic users
              return const HomeView();
            case UserRole.Gym_Person:
              return const HelperDashboard();
            case UserRole.Police:
              return const PoliceDashboard();
            case UserRole.None:
              return const LoginScreen();
          }
       }
       
       return const LoginScreen();
    });
  }
}
