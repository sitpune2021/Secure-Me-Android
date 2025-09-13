import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/view/incomming_call_view/incoming_call_screen.dart';

/// Extension to get context from GetxController
extension GetContext on GetxController {
  BuildContext? get context => Get.overlayContext;
}

class FakeCallController extends GetxController {
  RxString selectedCaller = ''.obs;
  RxString selectedDelay = ''.obs;
  RxInt delayInSeconds = 0.obs;

  RxInt callDuration = 0.obs;
  Timer? _timer;

  RxBool isCalling = false.obs;
  RxString countdownText = "".obs;

  // Create an instance of FlutterRingtonePlayer
  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();

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
      default:
        delayInSeconds.value = 0;
    }
  }

  /// Start fake call after countdown
  void startCustomFakeCall() async {
    if (selectedDelay.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select call delay",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedCaller.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a caller",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    int seconds = delayInSeconds.value;

    if (seconds == 0) {
      _openIncomingCall();
      return;
    }

    countdownText.value = "Call will start in $seconds seconds";

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int remaining = seconds - timer.tick;
      if (remaining > 0) {
        countdownText.value = "Call will start in $remaining seconds";
      } else {
        timer.cancel();
        countdownText.value = "";
        _openIncomingCall();
      }
    });
  }

  /// Open incoming call screen and play ringtone
  void _openIncomingCall() {
    if (context != null) {
      _ringtonePlayer.play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.glass,
        looping: true,
        volume: 1,
      );

      Get.to(
        () => IncomingCallScreen(
          callerName: selectedCaller.value,
          controller: this,
        ),
      );
    }
  }

  /// Start call timer & stop ringtone
  void startCallTimer() {
    _ringtonePlayer.stop();
    callDuration.value = 0;
    isCalling.value = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDuration.value++;
    });
  }

  /// Stop call, show duration, and reset state
  void stopCallTimer() {
    _ringtonePlayer.stop();
    _timer?.cancel();

    int minutes = callDuration.value ~/ 60;
    int seconds = callDuration.value % 60;

    Get.snackbar(
      'Call Ended',
      'You talked for $minutes minutes $seconds seconds',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Reset selections
    selectedCaller.value = '';
    selectedDelay.value = '';
    countdownText.value = '';

    callDuration.value = 0;
    isCalling.value = false;

    // Navigate to home
    Get.offAllNamed(AppRoutes.homeView);
  }

  @override
  void onClose() {
    _timer?.cancel();
    _ringtonePlayer.stop();
    super.onClose();
  }
}
