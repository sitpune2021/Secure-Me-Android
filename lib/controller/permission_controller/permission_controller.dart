import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:io';

class PermissionController extends GetxController {
  final isConnected = false.obs;

  /// Request all runtime permissions (native OS dialogs)
  Future<void> requestAllPermissions() async {
    if (GetPlatform.isAndroid) {
      await Permission.location.request();
      await Permission.locationWhenInUse.request();
      await Permission.locationAlways.request();
      await Permission.phone.request();
      await Permission.systemAlertWindow.request();
    } else if (GetPlatform.isIOS) {
      await Permission.locationWhenInUse.request();
      await Permission.locationAlways.request();
      await Permission.camera.request();
      await Permission.microphone.request();
      await Permission.photos.request();
      await Permission.contacts.request();
      await Permission.bluetooth.request();
    }

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
        if (await Permission.location.isDenied) {
          Get.snackbar(
            'Permission Denied',
            'Please allow location in settings',
            snackPosition: SnackPosition.BOTTOM,
          );
          openAppSettings();
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
