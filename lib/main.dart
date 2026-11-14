import 'dart:developer' as dev;

import 'package:flutter_localizations/flutter_localizations.dart'
    hide GlobalMaterialLocalizations;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:secure_me/core/network/dio_client.dart';
import 'package:secure_me/model/user_model.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/profile_controller/profile_controller.dart';
import 'package:secure_me/controller/permission_controller/permission_controller.dart';
import 'package:secure_me/controller/location_controller.dart';
import 'package:secure_me/controller/community_safety_controller.dart';
import 'package:secure_me/controller/incident_controller.dart';
import 'package:secure_me/app/routes/app_routes.dart';
import 'package:secure_me/view/home_view/home_view.dart';
import 'package:secure_me/view/role_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  Get.put(ThemeController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  Get.put(PermissionController(), permanent: true);
  Get.put(LocationController(), permanent: true);
  Get.put(CommunitySafetyController(), permanent: true);
  Get.put(IncidentController(), permanent: true);
  Get.put(DioService(), permanent: true);

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

    return GetMaterialApp(
      title: 'Secure Me – 7 Seconds',
      debugShowCheckedModeBanner: false,

      // Material localization configuration
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      supportedLocales: const [Locale('en', 'US')],

      // ThemeData is applied using standalone material_ui Theme below.
      // Do not pass material_ui ThemeData to GetMaterialApp.
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final screenWidth = mediaQueryData.size.width;

        double responsiveScale = screenWidth / 390.0;
        responsiveScale = responsiveScale.clamp(0.8, 1.2);

        const double smallFactor = 0.85;
        final double finalScale = responsiveScale * smallFactor;

        return Obx(
          () => Theme(
            data: themeController.currentTheme.value,
            child: MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: TextScaler.linear(finalScale),
              ),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },

      home: const AppRouterWrapper(),
      getPages: AppPages.pages,
    );
  }
}

class AppRouterWrapper extends StatelessWidget {
  const AppRouterWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRouter();
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
        dev.log(
          '🚦 Routing user with role: ${user.role} '
          'and roleString: ${user.roleString}',
          name: 'AppRouter',
        );

        if (user.role == UserRole.none) {
          return const RoleSelectionScreen();
        }

        return const HomeView();
      }

      return const RoleSelectionScreen();
    });
  }
}
