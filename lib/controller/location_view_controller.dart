import 'package:get/get.dart';

class LocationViewController extends GetxController {
  final RxBool isBackgroundTrackingEnabled = false.obs;

  void toggleBackgroundTracking(bool value) {
    isBackgroundTrackingEnabled.value = value;
  }
}
