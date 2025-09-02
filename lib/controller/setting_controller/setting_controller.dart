import 'package:get/get.dart';

class SettingsController extends GetxController {
  var autoCallOnSos = false.obs;

  void toggleAutoCall(bool value) {
    autoCallOnSos.value = value;
  }
}
