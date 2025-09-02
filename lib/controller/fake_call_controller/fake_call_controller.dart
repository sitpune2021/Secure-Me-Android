import 'package:get/get.dart';

class FakeCallController extends GetxController {
  var selectedDelay = "5 Sec".obs;
  var selectedCaller = "".obs;

  void setDelay(String delay) {
    selectedDelay.value = delay;
  }

  void setCaller(String caller) {
    selectedCaller.value = caller;
  }
}
