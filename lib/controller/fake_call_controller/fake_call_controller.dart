import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:secure_me/view/incomming_call_view/incoming_call_screen.dart';
// your custom screen import

extension GetContext on GetxController {
  BuildContext? get context => Get.overlayContext;
}

class FakeCallController extends GetxController {
  RxString selectedCaller = ''.obs;
  RxString selectedDelay = '0 Sec'.obs;
  RxInt delayInSeconds = 0.obs;

  RxInt callDuration = 0.obs;
  Timer? _timer;

  RxBool isCalling = false.obs; // For UI state

  void setCaller(String name) => selectedCaller.value = name;

  void setDelay(String delay) {
    selectedDelay.value = delay;
    switch (delay) {
      case "0 Sec":
        delayInSeconds.value = 0;
        break;
      case "5 Sec":
        delayInSeconds.value = 5;
        break;
      case "30 Sec":
        delayInSeconds.value = 30;
        break;
      case "1 Min":
        delayInSeconds.value = 60;
        break;
    }
  }

  /// Start custom fake call with IncomingCallScreen
  void startCustomFakeCall() async {
    if (selectedCaller.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a caller first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Wait for delay
    await Future.delayed(Duration(seconds: delayInSeconds.value));

    if (context != null) {
      Get.to(
        () => IncomingCallScreen(
          callerName: selectedCaller.value,
          controller: this,
        ),
      );
    }
  }

  void startCallTimer() {
    callDuration.value = 0;
    isCalling.value = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDuration.value++;
    });
  }

  void stopCallTimer() {
    _timer?.cancel();
    int minutes = callDuration.value ~/ 60;
    int seconds = callDuration.value % 60;
    Get.snackbar(
      'Call Ended',
      'You talked for $minutes minutes $seconds seconds',
      snackPosition: SnackPosition.BOTTOM,
    );
    callDuration.value = 0;
    isCalling.value = false;
    Get.back(); // close the call screen
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
