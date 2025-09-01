import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:secure_me/routes/app_pages.dart';

class LoginController extends GetxController {
  var keepLoggedIn = false.obs;
  var mobileNumber = ''.obs;

  void toggleKeepLoggedIn(bool? value) {
    keepLoggedIn.value = value ?? false;
  }

  void login() {
    if (mobileNumber.isEmpty) {
      Get.snackbar("Error", "Please enter mobile number");
    } else {
      Get.toNamed(AppRoutes.otpView);
      Get.snackbar("Success", "Logging in with ${mobileNumber.value}");
      // TODO: Navigate to HomeScreen or call API
    }
  }
}
