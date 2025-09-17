import 'package:flutter/foundation.dart';
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

  // Register controllers
  final permissionController = Get.put(PermissionController());
  final themeController = Get.put(ThemeController());

  // Request permissions once (first-run logic)
  final storage = GetStorage();
  Future.delayed(Duration.zero, () async {
    try {
      bool askedBefore = storage.read('permissionsRequested') ?? false;
      // Always try to request/check so the controller knows the current state
     // await permissionController.requestAllPermissions();
      if (!askedBefore) storage.write('permissionsRequested', true);
    } catch (e) {
      if (kDebugMode) print('permission request error: $e');
    }
  });

  // Run the app (no MyApp class)
  runApp(
    Obx(() {
      // determine effective darkness (themeController must be registered above)
      final effectiveDark = themeController.userOverride.value
          ? themeController.isDarkMode.value
          : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;

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
            themeMode: themeController.userOverride.value
                ? (themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light)
                : ThemeMode.system,
            initialRoute: AppRoutes.loginView,// we use home to gate permissions then navigate
            getPages: AppPages.pages,
            builder: (context, child) {
              // guard against null child
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
    }),
  );
}

/// Small widget shown as app home that blocks UI until permissions are granted.
///
/// Once `permissionController.isPermissionGranted` becomes true we navigate to the real route.
// class PermissionGate extends StatefulWidget {
//   @override
//   State<PermissionGate> createState() => _PermissionGateState();
// }

// class _PermissionGateState extends State<PermissionGate> {
//   final PermissionController permissionController = Get.find();

//   @override
//   void initState() {
//     super.initState();

//     // Debug listener: print permission changes (helpful while debugging release/profile)
//     permissionController.isPermissionGranted.listen((granted) {
//       if (kDebugMode) print('Permission granted changed: $granted');
//       if (granted) {
//         // Navigate to login (replace this with your desired initial route)
//         Future.microtask(() => Get.offAllNamed(AppRoutes.loginView));
//       }
//     });

//     // If already granted at startup, navigate immediately
//     if (permissionController.isPermissionGranted.value) {
//       Future.microtask(() => Get.offAllNamed(AppRoutes.loginView));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // still not granted -> show blocking overlay (splash-like)
//       if (!permissionController.isPermissionGranted.value) {
//         return Scaffold(
//           backgroundColor: Colors.black.withOpacity(0.6),
//           body: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // replace with your logo if you want
//                 const FlutterLogo(size: 88),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Secure Me',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 const SizedBox(height: 12),
//                 const CircularProgressIndicator(),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // allow user to re-request manually
//                     await permissionController.requestAllPermissions();
//                   },
//                   child: const Text('Retry permissions'),
//                 ),
//                 const SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {
//                     openAppSettings();
//                   },
//                   child: const Text('Open App Settings', style: TextStyle(color: Colors.white70)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }

//       // permission granted -> tiny placeholder until listener navigates away
//       return const Scaffold(body: SizedBox.shrink());
//     });
//   }
// }
