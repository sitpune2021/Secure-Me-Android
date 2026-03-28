import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class EmergencyNavigationController extends GetxController {
  final RxList<LatLng> escapeRoute = <LatLng>[].obs;
  final RxList<LatLng> responderRoute = <LatLng>[].obs;
  final RxString safetyGuidance = "".obs;

  void calculateEscapeRoute(LatLng userLoc) {
    // In a real app, this would use Google Directions API with "Avoid Areas"
    // Mocking an escape route to the nearest safe point
    escapeRoute.value = [
      userLoc,
      LatLng(userLoc.latitude + 0.005, userLoc.longitude + 0.002),
      LatLng(userLoc.latitude + 0.010, userLoc.longitude + 0.005),
    ];
    safetyGuidance.value = "Proceed 500m North-East towards the Main Square. Police dispatch is 2 minutes away.";
  }

  void shareRouteWithResponders() {
    Get.snackbar("SYSTEM", "Escape route shared with 2 responders", 
        backgroundColor: Colors.indigo, colorText: Colors.white);
  }

  void resetRoutes() {
    escapeRoute.clear();
    responderRoute.clear();
    safetyGuidance.value = "";
  }
}
