import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void sosAction() {
    // TODO: Implement SOS action (call/send alert)
    Get.snackbar("SOS", "Emergency action triggered!");
  }
}
