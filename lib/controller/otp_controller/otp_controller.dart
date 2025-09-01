import 'package:get/get.dart';
import 'package:secure_me/routes/app_pages.dart';

class OtpController extends GetxController {
  var otp = "".obs;

  void setOtp(String value) {
    otp.value = value;
  }

  void verifyOtp() {
    if (otp.value.length < 6) {
      Get.snackbar("Error", "Please enter 6 digit OTP");
    } else {
      Get.snackbar("Success", "OTP Verified: ${otp.value}");
      Get.offAllNamed(AppRoutes.homeView);
      // TODO: Navigate to HomeScreen after success
    }
  }

  void resendOtp() {
    Get.snackbar("OTP", "A new code has been sent");
  }
}
