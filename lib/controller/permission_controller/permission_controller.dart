import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  final isConnected = false.obs;
  final isPermissionGranted = false.obs;

  // IMPORTANT:
  // Static means this lock is shared between ALL instances
  // of PermissionController.
  static bool _isRequestingPermissions = false;

  static Future<void>? _permissionRequestFuture;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();

    // Run independently.
    _startPermissionRequest();

    listenForInternet();
  }

  /// Safely starts the permission request.
  ///
  /// If another PermissionController instance is already requesting
  /// permissions, this instance waits for the existing request instead
  /// of starting another native permission request.
  Future<void> _startPermissionRequest() async {
    if (_permissionRequestFuture != null) {
      log(
        '⚠️ Permission request already running. Waiting for existing request...',
        name: 'PermissionController',
      );

      try {
        await _permissionRequestFuture;
      } catch (_) {
        // Existing request already handled its error.
      }

      return;
    }

    final future = requestAllPermissions();

    _permissionRequestFuture = future;

    try {
      await future;
    } finally {
      if (identical(_permissionRequestFuture, future)) {
        _permissionRequestFuture = null;
      }
    }
  }

  /// Request/check all required runtime permissions.
  Future<void> requestAllPermissions() async {
    if (_isRequestingPermissions) {
      log(
        '⚠️ Permission request already running. Skipping duplicate request.',
        name: 'PermissionController',
      );
      return;
    }

    _isRequestingPermissions = true;

    try {
      log(
        '🛡️ Initiating security permission request...',
        name: 'PermissionController',
      );

      // ------------------------------------------------------------
      // STEP 1: Foreground permissions
      // ------------------------------------------------------------

      final permissions = <Permission>[
        Permission.locationWhenInUse,
        Permission.notification,
        Permission.phone,
        Permission.contacts,
        Permission.camera,
        Permission.microphone,
      ];

      final statuses = await permissions.request();

      // The native permission request is now completely finished.
      // ------------------------------------------------------------

      statuses.forEach((permission, status) {
        log('🔐 $permission => $status', name: 'PermissionController');
      });

      // ------------------------------------------------------------
      // STEP 2: Foreground location
      // ------------------------------------------------------------

      final locationStatus =
          statuses[Permission.locationWhenInUse] ??
          await Permission.locationWhenInUse.status;

      final locationGranted = locationStatus.isGranted;

      // ------------------------------------------------------------
      // STEP 3: Background location
      //
      // IMPORTANT:
      // Do this ONLY after the foreground request has completed.
      // ------------------------------------------------------------

      if (locationGranted) {
        await _requestBackgroundLocation();
      }

      // ------------------------------------------------------------
      // STEP 4: Update permission state
      // ------------------------------------------------------------

      isPermissionGranted.value = locationGranted;

      // ------------------------------------------------------------
      // STEP 5: Internet check
      // ------------------------------------------------------------

      await checkInternet();

      log('✅ Permission request completed', name: 'PermissionController');
    } catch (e, st) {
      log(
        '❌ Security permission error: $e',
        name: 'PermissionController',
        stackTrace: st,
      );

      isPermissionGranted.value = false;
    } finally {
      // ALWAYS unlock.
      _isRequestingPermissions = false;
    }
  }

  /// Request background location separately.
  Future<void> _requestBackgroundLocation() async {
    try {
      // Check current status first.
      final currentStatus = await Permission.locationAlways.status;

      log(
        '📍 Location Always current status => $currentStatus',
        name: 'PermissionController',
      );

      // Already granted.
      if (currentStatus.isGranted) {
        log(
          '✅ Background location already granted',
          name: 'PermissionController',
        );
        return;
      }

      // Don't repeatedly request permanently denied permission.
      if (currentStatus.isPermanentlyDenied) {
        log(
          '⚠️ Background location permanently denied',
          name: 'PermissionController',
        );
        return;
      }

      // IMPORTANT:
      // Foreground location request has already finished before this.
      final alwaysStatus = await Permission.locationAlways.request();

      log('📍 Location Always => $alwaysStatus', name: 'PermissionController');
    } catch (e, st) {
      log(
        '❌ Background location error: $e',
        name: 'PermissionController',
        stackTrace: st,
      );
    }
  }

  /// Check if device has a real internet connection.
  Future<void> checkInternet() async {
    try {
      final connected = await InternetConnectionChecker().hasConnection;

      isConnected.value = connected;

      log(
        '🌐 Internet Connection: ${connected ? "ACTIVE" : "OFFLINE"}',
        name: 'PermissionController',
      );
    } catch (e, st) {
      log(
        '❌ Internet check error: $e',
        name: 'PermissionController',
        stackTrace: st,
      );

      isConnected.value = false;
    }
  }

  /// Listen for connectivity changes in real-time.
  void listenForInternet() {
    // Prevent accidentally creating multiple subscriptions
    // for the same controller.
    _connectivitySubscription?.cancel();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) async {
      await checkInternet();
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    super.onClose();
  }
}
