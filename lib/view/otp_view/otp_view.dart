import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:secure_me/controller/otp_controller/otp_controller.dart';

class OtpView extends StatelessWidget {
  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ Prevent overflow
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.05),

                Text(
                  "Verification",
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.005),

                Text(
                  "We sent a code to your Mobile Number",
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.045,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: Get.height * 0.05),

                Center(
                  child: Image.asset(
                    "assets/images/verification.png",
                    height: Get.height * 0.2,
                  ),
                ),
                SizedBox(height: Get.height * 0.05),

                // 🔹 OTP Input
                Center(
                  child: Pinput(
                    length: 6,
                    onChanged: controller.setOtp,
                    defaultPinTheme: PinTheme(
                      width: Get.width * 0.12,
                      height: Get.width * 0.12,
                      textStyle: GoogleFonts.poppins(
                        fontSize: Get.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Get.height * 0.05),

                SizedBox(
                  width: double.infinity,
                  height: Get.height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.verifyOtp,
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Get.height * 0.02),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn’t receive the code ? ",
                        style: GoogleFonts.poppins(fontSize: Get.width * 0.04),
                      ),
                      GestureDetector(
                        onTap: controller.resendOtp,
                        child: Text(
                          "Send Again",
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.04,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Get.height * 0.04),

                // 🔹 Back to Login
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back, size: 18),
                      SizedBox(width: 5),
                      Text(
                        "Back to log in",
                        style: GoogleFonts.poppins(fontSize: Get.width * 0.04),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Get.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
