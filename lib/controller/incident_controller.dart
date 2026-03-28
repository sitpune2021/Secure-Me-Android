import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;


class IncidentLog {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String location;
  final List<String> responderIds;
  final String resolution;
  final bool isAnonymous;

  IncidentLog({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.location,
    required this.responderIds,
    required this.resolution,
    this.isAnonymous = false,
  });
}

class IncidentController extends GetxController {
  final RxList<IncidentLog> history = <IncidentLog>[].obs;
  final RxBool isAnonymousMode = false.obs;

  void togglePrivacy(bool value) {
    isAnonymousMode.value = value;
    Get.snackbar(
      "PRIVACY", 
      value ? "Anonymous Mode Enabled: Responders won't see your profile." : "Profile visibility restored.",
      snackPosition: SnackPosition.BOTTOM
    );
  }

  void saveIncident(IncidentLog log) {
    history.insert(0, log);
    // Real app: Sync with Firestore / Backend for legal backup
    dev.log("Incident ${log.id} archived for safety/legal purposes.", name: 'IncidentController');
  }

  void generateSafetyReport() {
    // Phase 12: Manager side report generation
    Get.snackbar("SYSTEM", "Monthly safety report generated. Forwarding to dashboard.", 
        backgroundColor: Colors.blueGrey, colorText: Colors.white);
  }
}
