import 'dart:developer';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PermissionController extends GetxController {
  final isConnected = false.obs;
  final isPermissionGranted = false.obs; // <- important observable

  @override
  void onInit() {
    super.onInit();
    requestAllPermissions();
    listenForInternet();
  }

  /// Request/check all runtime permissions we care about and set the observable.
  Future<void> requestAllPermissions() async {
    try {
      log('🛡️ Initiating security permission request...', name: 'PermissionController');
      
      final permissions = <Permission>[
        Permission.location,
        Permission.locationWhenInUse,
        Permission.notification,
        Permission.phone,
        Permission.contacts,
        Permission.camera,
        Permission.microphone,
      ];

      // Request bulk permissions
      final statuses = await permissions.request();

      // Background location request (handled separately as required by OS)
      if (statuses[Permission.location]?.isGranted ?? false) {
        await Permission.locationAlways.request();
      }

      // Determine granted status (essential for app operation)
      isPermissionGranted.value = statuses[Permission.location]?.isGranted ?? false;

      // Update internet connectivity
      await checkInternet();
    } catch (e, st) {
      log('❌ Security permission error: $e', name: 'PermissionController', stackTrace: st);
      isPermissionGranted.value = false;
    }
  }

  /// Check if device has real internet connection
  Future<void> checkInternet() async {
    bool connected = await InternetConnectionChecker().hasConnection;
    isConnected.value = connected;
    log('🌐 Internet Connection: ${connected ? "ACTIVE" : "OFFLINE"}', name: 'PermissionController');
  }

  /// Listen for connectivity changes in real-time
  void listenForInternet() {
    Connectivity().onConnectivityChanged.listen((result) async {
      await checkInternet();
    });
  }
}
