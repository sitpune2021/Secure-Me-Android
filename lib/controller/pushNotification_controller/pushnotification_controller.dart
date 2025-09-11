import 'package:get/get.dart';

class PushNotificationController extends GetxController {
  RxBool sosTriggerAlerts = false.obs;
  RxBool trustedContactResponse = false.obs;
  RxBool dangerZoneAlert = false.obs;

  void toggleSosTrigger(bool value) => sosTriggerAlerts.value = value;
  void toggleTrustedContact(bool value) => trustedContactResponse.value = value;
  void toggleDangerZone(bool value) => dangerZoneAlert.value = value;
}
