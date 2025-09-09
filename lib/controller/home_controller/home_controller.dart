import 'package:get/get.dart';
import 'package:secure_me/routes/app_pages.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void sosAction() {
    Get.toNamed(AppRoutes.sosActivate);
    Get.snackbar("SOS", "SOS Activated");
  }
}
