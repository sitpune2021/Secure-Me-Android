import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PermissionController extends GetxController {
  final isConnected = false.obs;

  /// Request all runtime permissions (native OS dialogs)
  Future<void> requestAllPermissions() async {
    await Permission.location.request();
    await Permission.locationWhenInUse.request();
    await Permission.locationAlways.request();
    await Permission.phone.request();
    await Permission.systemAlertWindow.request(); // overlay permission

    // Check internet connection
    await checkInternet();
  }

  /// Check if device has real internet connection
  Future<void> checkInternet() async {
    isConnected.value = await InternetConnectionChecker().hasConnection;
  }

  /// Listen for connectivity changes in real-time
  void listenForInternet() {
    Connectivity().onConnectivityChanged.listen((_) async {
      isConnected.value = await InternetConnectionChecker().hasConnection;

      if (!isConnected.value) {
        Get.snackbar(
          "No Internet",
          "Please check your connection",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    listenForInternet();
  }
}
