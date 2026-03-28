import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_me/model/signal_model.dart';
import 'dart:async';


class SafetyController extends GetxController {
  final Rx<SignalStatus> status = SignalStatus.inactive.obs;
  final Rx<SignalStage> stage = SignalStage.stage1.obs;
  final RxList<String> responderIds = <String>[].obs;
  final Rx<LocationModel?> victimLocation = Rx<LocationModel?>(null);
  final RxString activeSignalId = "".obs;
  final RxDouble currentRadius = 50.0.obs;
  final RxBool isEscalating = false.obs;

  Timer? _stageTimer;
  Timer? _escalationTimer;

  bool isSignalActive() => 
      status.value != SignalStatus.inactive && 
      status.value != SignalStatus.resolved && 
      activeSignalId.value.isNotEmpty;

  void activateEmergency(LocationModel location) {
    status.value = SignalStatus.pending;
    stage.value = SignalStage.stage1;
    victimLocation.value = location;
    activeSignalId.value = 'sig_${DateTime.now().millisecondsSinceEpoch}';
    responderIds.clear();
    currentRadius.value = 50.0;
    isEscalating.value = false;

    _startEscalation();
    _simulateResponders();
  }

  void _startEscalation() {
    _escalationTimer?.cancel();
    _escalationTimer = Timer(const Duration(seconds: 30), () {
      if (responderIds.isEmpty && status.value == SignalStatus.pending) {
        currentRadius.value = 1000.0;
        stage.value = SignalStage.stage2;
        isEscalating.value = true;
        _notifyWiderNetwork();
      }
    });
  }

  void _notifyWiderNetwork() {
    Get.snackbar("SYSTEM", "Escalating alert radius to 1km - Informing wider network",
        snackPosition: SnackPosition.TOP);
  }

  void acceptEmergency(String helperId) {
    if (!responderIds.contains(helperId)) {
      responderIds.add(helperId);
      if (status.value == SignalStatus.pending) {
        status.value = SignalStatus.accepted;
      }
    }
  }

  void updateStatus(SignalStatus newStatus) {
    status.value = newStatus;
  }

  void cancelEmergency({String? pin}) {
    if (pin != null && pin != "1234") {
      Get.snackbar("ERROR", "Invalid Safety PIN", backgroundColor: Get.theme.colorScheme.error);
      return;
    }

    _stageTimer?.cancel();
    _escalationTimer?.cancel();
    status.value = SignalStatus.inactive; // Go back to inactive
    stage.value = SignalStage.stage1;
    responderIds.clear();
    victimLocation.value = null;
    activeSignalId.value = "";
    currentRadius.value = 50.0;
    isEscalating.value = false;
  }

  void _simulateResponders() {
    Future.delayed(const Duration(seconds: 5), () {
      if (isSignalActive()) {
        acceptEmergency('helper_alpha');
        status.value = SignalStatus.inProgress;
        Get.snackbar("ALERT", "Helper Alpha is 200m away and responding", 
            backgroundColor: Get.theme.primaryColor, colorText: Colors.white);
      }
    });

    Future.delayed(const Duration(seconds: 15), () {
       if (isSignalActive()) {
         acceptEmergency('police_sqaud_1');
         Get.snackbar("SYSTEM", "Police Squad Assigned and en route", 
            backgroundColor: Colors.blue, colorText: Colors.white);
      }
    });
  }

  @override
  void onClose() {
    _stageTimer?.cancel();
    _escalationTimer?.cancel();
    super.onClose();
  }
}


