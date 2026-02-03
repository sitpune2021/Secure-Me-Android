import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:secure_me/controller/otp_controller/otp_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class OtpView extends StatelessWidget {
  final OtpController controller = Get.put(OtpController());
  final ThemeController themeController = Get.find<ThemeController>();

  OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Using ThemeController directly
      final isDark = themeController.isDarkMode.value;

      return Scaffold(
        backgroundColor: themeController.theme.colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Get.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.05),

                  // Title
                  Text(
                    "Verification",
                    style: GoogleFonts.poppins(
                      fontSize: Get.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.005),

                  Text(
                    "We sent a code to your Mobile Number",
                    style: GoogleFonts.poppins(
                      fontSize: Get.width * 0.045,
                      color: (isDark ? AppColors.darkText : AppColors.lightText)
                          .withOpacity(0.7),
                    ),
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // Verification Image
                  Center(
                    child: Image.asset(
                      "assets/images/verification.png",
                      height: Get.height * 0.2,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.05),

                  // OTP Input
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
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Get.height * 0.05),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: Get.height * 0.07,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.glowPurpleTopLeft
                              : AppColors.lightPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.verifyOtp,
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDark
                                        ? AppColors.darkText
                                        : AppColors.lightText,
                                  ),
                                ),
                              )
                            : Text(
                                "Continue",
                                style: GoogleFonts.poppins(
                                  fontSize: Get.width * 0.05,
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                                ),
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: Get.height * 0.02),

                  // Resend OTP
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t receive the code ? ",
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.04,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.resendOtp,
                          child: Text(
                            "Send Again",
                            style: GoogleFonts.poppins(
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.glowPurpleTopLeft
                                  : AppColors.lightPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Get.height * 0.04),

                  // Back to Login
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Back to log in",
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.04,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
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
    });
  }
}
