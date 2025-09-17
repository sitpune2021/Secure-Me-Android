import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PermissionController extends GetxController {
  final isConnected = false.obs;
  final isPermissionGranted = false.obs; // <- important observable

  /// Request/check all runtime permissions we care about and set the observable.
  Future<void> requestAllPermissions() async {
    try {
      // Build list of permissions we want to ask
      final permissions = <Permission>[
        Permission.location,
        Permission.locationWhenInUse,
        // Permission.locationAlways sometimes not needed on all apps,
        // add if your app truly requires it.
        Permission.phone,
        // don't request systemAlertWindow (not supported by permission_handler for runtime)
      ];

      // On iOS, add extra permissions
      if (GetPlatform.isIOS) {
        permissions.addAll([
          Permission.camera,
          Permission.microphone,
          Permission.photos,
          Permission.contacts,
          Permission.bluetooth,
        ]);
      }

      // Request them (this returns a map of statuses)
      final statuses = await permissions.request();

      // Determine granted = at least location granted (or any other required permission)
      final locationGranted = (await Permission.location.status).isGranted ||
          (await Permission.locationWhenInUse.status).isGranted;

      // You can choose your own criteria for "granted".
      isPermissionGranted.value = locationGranted;

      // If permanently denied, inform user (do not force open settings)
      final permanentlyDenied = statuses.values.any((s) => s.isPermanentlyDenied);
      if (!isPermissionGranted.value && permanentlyDenied) {
        // show a message once (UI layer can show dialog/snackbar)
        // We avoid calling openAppSettings() automatically here.
        // UI can call openAppSettings() if user clicks "Open settings".
      }

      // Update internet connectivity too
      await checkInternet();
    } catch (e, st) {
      // if anything odd happens, set false and print for debugging
      isPermissionGranted.value = false;
      // debug print
      if (kDebugMode) {
        print('requestAllPermissions error: $e\n$st');
      }
    }
  }

  /// Check if device has real internet connection
  Future<void> checkInternet() async {
    isConnected.value = await InternetConnectionChecker().hasConnection;
  }

  /// Listen for connectivity changes in real-time
  void listenForInternet() {
    Connectivity().onConnectivityChanged.listen((_) async {
      isConnected.value = await InternetConnectionChecker().hasConnection;
      // if no internet and location denied, optionally prompt
      if (!isConnected.value) {
        final locDenied = await Permission.location.isDenied;
        if (locDenied) {
          // UI decide what to show; controller keeps state only
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    listenForInternet();
  }
}
