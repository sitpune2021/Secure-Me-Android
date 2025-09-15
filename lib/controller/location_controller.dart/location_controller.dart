import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController extends GetxController {
  // Current position
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();

  // Loading state
  final RxBool isFetching = true.obs;

  // Google Map controller
  final Completer<GoogleMapController> mapController = Completer();

  StreamSubscription<Position>? _positionSub;

  @override
  void onInit() {
    super.onInit();
    initLocation();
  }

  @override
  void onClose() {
    _positionSub?.cancel();
    super.onClose();
  }

  /// Show bottom sheet with WhatsApp & SMS options
  void showShareOptions(ThemeData theme) {
    if (currentPosition.value == null) {
      Get.snackbar("Error", "Location not available");
      return;
    }

    final lat = currentPosition.value!.latitude;
    final lng = currentPosition.value!.longitude;
    final mapsUrl = "https://www.google.com/maps?q=$lat,$lng";
    final message = "Here is my live location: $mapsUrl";

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.bottomSheetTheme.backgroundColor ??
              theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Share your location via",
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // WhatsApp
            ListTile(
              leading: Icon(RemixIcons.whatsapp_fill,
                  color: theme.colorScheme.primary),
              title: Text(
                "WhatsApp",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () async {
                Get.back();
                await shareViaWhatsApp("", message);
              },
            ),

            // SMS
            ListTile(
              leading: Icon(Icons.message, color: theme.colorScheme.primary),
              title: Text(
                "Message",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () async {
                Get.back();
                await shareViaSMS("", message);
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Share via WhatsApp (Android + iOS)
  Future<void> shareViaWhatsApp(String phone, String message) async {
    final encodedMessage = Uri.encodeComponent(message);

    final url = phone.isNotEmpty
        ? (GetPlatform.isIOS
            ? "https://wa.me/$phone?text=$encodedMessage"
            : "whatsapp://send?phone=$phone&text=$encodedMessage")
        : (GetPlatform.isIOS
            ? "https://wa.me/?text=$encodedMessage"
            : "whatsapp://send?text=$encodedMessage");

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "WhatsApp is not installed on this device");
    }
  }

  /// Share via SMS (Android + iOS)
  Future<void> shareViaSMS(String phone, String message) async {
    final encodedMessage = Uri.encodeComponent(message);

    final uri = phone.isNotEmpty
        ? (GetPlatform.isIOS
            ? Uri.parse("sms:$phone&body=$encodedMessage")
            : Uri.parse("sms:$phone?body=$encodedMessage"))
        : (GetPlatform.isIOS
            ? Uri.parse("sms:&body=$encodedMessage")
            : Uri.parse("sms:?body=$encodedMessage"));

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "SMS app not available");
    }
  }

  /// Initialize live location
  Future<void> initLocation() async {
    isFetching.value = true;

    // Check location services
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isFetching.value = false;
        Get.snackbar('Location', 'Please enable device location services.');
        return;
      }
    }

    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      isFetching.value = false;
      Get.snackbar(
        'Permission',
        'Location permission permanently denied. Enable from settings.',
      );
      return;
    }
    if (permission == LocationPermission.denied) {
      isFetching.value = false;
      Get.snackbar('Permission', 'Location permission denied.');
      return;
    }

    // Get initial position
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      currentPosition.value = LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      try {
        Position pos = await Geolocator.getLastKnownPosition() ??
            await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
        currentPosition.value = LatLng(pos.latitude, pos.longitude);
      } catch (_) {
        Get.snackbar('Error', 'Unable to obtain location: $e');
      }
    }

    // Listen to location updates
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen(
      (Position p) async {
        final newLatLng = LatLng(p.latitude, p.longitude);
        currentPosition.value = newLatLng;

        if (mapController.isCompleted) {
          final controller = await mapController.future;
          controller.animateCamera(CameraUpdate.newLatLng(newLatLng));
        }
      },
      onError: (err) {
        debugPrint('Position stream error: $err');
      },
    );

    isFetching.value = false;
  }

  var autoCallOnSos = false.obs;

  void toggleAutoCall(bool value) {
    autoCallOnSos.value = value;
  }

  /// GoogleMap onMapCreated
  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  /// Move camera to current location
  Future<void> moveToCurrentLocation() async {
    final pos = currentPosition.value;
    if (pos == null) return;
    if (!mapController.isCompleted) return;
    final controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(pos, 17));
  }
}
