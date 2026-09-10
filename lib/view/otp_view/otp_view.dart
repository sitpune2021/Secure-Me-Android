// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import 'package:secure_me/app/theme/app_color.dart';
// import 'package:secure_me/controller/otp_controller/otp_controller.dart';
// import 'package:secure_me/controller/theme_controller/theme_controller.dart';
// import 'package:secure_me/view/common/tactical_button.dart';
// import 'package:secure_me/core/components/components.dart';

// class OtpView extends StatelessWidget {
//   final OtpController controller = Get.put(OtpController());
//   final ThemeController themeController = Get.find<ThemeController>();

//   OtpView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Using ThemeController directly
//       final isDark = themeController.isDarkMode.value;

//       return Scaffold(
//         backgroundColor: themeController.theme.colorScheme.surface,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(Get.width * 0.05),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: Get.height * 0.05),

//                   // Title
//                   Text(
//                     "Verification",
//                     style: GoogleFonts.outfit(
//                       fontSize: Get.width * 0.07,
//                       fontWeight: FontWeight.bold,
//                       color: isDark ? AppColors.darkText : AppColors.lightText,
//                     ),
//                   ),
//                   SizedBox(height: Get.height * 0.005),

//                   Text(
//                     "We sent a code to your ${controller.isPhone.value ? 'phone' : 'email'}",
//                     style: GoogleFonts.outfit(
//                       fontSize: Get.width * 0.045,
//                       color: (isDark ? AppColors.darkText : AppColors.lightText)
//                           .withValues(alpha: 0.7),
//                     ),
//                   ),
//                   Obx(
//                     () => Text(
//                       controller.identifier.value,
//                       style: GoogleFonts.outfit(
//                         fontSize: Get.width * 0.045,
//                         fontWeight: FontWeight.bold,
//                         color: isDark
//                             ? AppColors.darkRadialGlow
//                             : AppColors.lightPrimary,
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: Get.height * 0.05),

//                   // Verification Image
//                   Center(
//                     child: Image.asset(
//                       "assets/images/verification.png",
//                       height: Get.height * 0.2,
//                     ),
//                   ),
//                   SizedBox(height: Get.height * 0.05),

//                   // OTP Input
//                   Center(
//                     child: Pinput(
//                       length: 6,
//                       onChanged: controller.setOtp,
//                       defaultPinTheme: PinTheme(
//                         width: Get.width * 0.12,
//                         height: Get.width * 0.12,
//                         textStyle: GoogleFonts.outfit(
//                           fontSize: Get.width * 0.06,
//                           fontWeight: FontWeight.bold,
//                           color: isDark
//                               ? AppColors.darkText
//                               : AppColors.lightText,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: isDark
//                                 ? AppColors.darkDivider
//                                 : AppColors.lightDivider,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: Get.height * 0.05),

//                   // Continue Button
//                   TacticalButton(
//                     label: "Continue",
//                     onTap: controller.verifyOtp,
//                     isLoading: controller.isLoading.value,
//                     color: isDark
//                         ? AppColors.glowPurpleTopLeft
//                         : AppColors.lightPrimary,
//                   ),

//                   SizedBox(height: Get.height * 0.02),

//                   // Resend OTP
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Didn’t receive the code ? ",
//                           style: GoogleFonts.outfit(
//                             fontSize: Get.width * 0.04,
//                             color: isDark
//                                 ? AppColors.darkText
//                                 : AppColors.lightText,
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: controller.resendOtp,
//                           child: Text(
//                             "Send Again",
//                             style: GoogleFonts.outfit(
//                               fontSize: Get.width * 0.04,
//                               fontWeight: FontWeight.bold,
//                               color: isDark
//                                   ? AppColors.glowPurpleTopLeft
//                                   : AppColors.lightPrimary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: Get.height * 0.04),

//                   // Back to Login
//                   GestureDetector(
//                     onTap: () => Get.back(),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AppBackIcon(
//                           size: 18,
//                           color: isDark
//                               ? AppColors.darkText
//                               : AppColors.lightText,
//                         ),
//                         SizedBox(width: 5),
//                         Text(
//                           "Back to log in",
//                           style: GoogleFonts.outfit(
//                             fontSize: Get.width * 0.04,
//                             color: isDark
//                                 ? AppColors.darkText
//                                 : AppColors.lightText,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: Get.height * 0.02),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }

// // Animated 3-dots loading indicator for buttons
// class _DotsLoading extends StatefulWidget {
//   const _DotsLoading();
//   @override
//   State<_DotsLoading> createState() => _DotsLoadingState();
// }

// class _DotsLoadingState extends State<_DotsLoading>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _ctrl,
//       builder: (_, _) => Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(3, (i) {
//           final t = ((_ctrl.value + i / 3) % 1.0);
//           final scale = 0.6 + 0.4 * (1 - (2 * t - 1).abs());
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 3),
//             child: Transform.scale(
//               scale: scale,
//               child: Container(
//                 width: 8,
//                 height: 8,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:secure_me/app/theme/app_color.dart';
import 'package:secure_me/controller/otp_controller/otp_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/view/common/tactical_button.dart';
import 'package:secure_me/core/components/components.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final OtpController controller = Get.put(OtpController());
  final ThemeController themeController = Get.find<ThemeController>();

  static const int _totalSeconds = 30;
  int _secondsLeft = _totalSeconds;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _totalSeconds;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() {
          _secondsLeft = 0;
          _canResend = true;
        });
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _handleResend() {
    if (!_canResend) return;
    controller.resendOtp(); // 🔹 existing API call, unchanged
    _startTimer(); // 🔹 restart countdown
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      // 🔹 Read both loading states separately
      final isContinueLoading = controller.isLoading.value;
      final isResendLoading = controller.isResendLoading.value;

      // 🔹 Continue button is disabled while resend API is in-flight
      final isContinueDisabled = isResendLoading;

      final accentColor = isDark
          ? AppColors.glowPurpleTopLeft
          : AppColors.lightPrimary;
      final textColor = isDark ? AppColors.darkText : AppColors.lightText;

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
                    style: GoogleFonts.outfit(
                      fontSize: Get.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.005),

                  Text(
                    "We sent a code to your ${controller.isPhone.value ? 'phone' : 'email'}",
                    style: GoogleFonts.outfit(
                      fontSize: Get.width * 0.045,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.identifier.value,
                      style: GoogleFonts.outfit(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
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

                  // OTP Input
                  Center(
                    child: Pinput(
                      length: 6,
                      onChanged: controller.setOtp,
                      defaultPinTheme: PinTheme(
                        width: Get.width * 0.12,
                        height: Get.width * 0.12,
                        textStyle: GoogleFonts.outfit(
                          fontSize: Get.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: textColor,
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

                  // ─── Continue button ────────────────────────────────────
                  // 🔹 isLoading    → shows spinner inside button (verifyOtp running)
                  // 🔹 isContinueDisabled → button greyed out (resendOtp running)
                  TacticalButton(
                    label: "Continue",
                    onTap: isContinueDisabled ? null : controller.verifyOtp,
                    isLoading: isContinueLoading, // 🔹 only verifyOtp spinner
                    color: isContinueDisabled
                        ? accentColor.withValues(
                            alpha: 0.4,
                          ) // 🔹 dim while resend loads
                        : accentColor,
                  ),

                  // ────────────────────────────────────────────────────────
                  SizedBox(height: Get.height * 0.02),

                  // ─── Send Again row ─────────────────────────────────────
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: GoogleFonts.outfit(
                            fontSize: Get.width * 0.04,
                            color: textColor,
                          ),
                        ),

                        GestureDetector(
                          onTap: (_canResend && !isResendLoading)
                              ? _handleResend
                              : null,
                          child: isResendLoading
                              // 🔹 Resend API in-flight → small spinner next to text
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: accentColor,
                                      ),
                                    ),
                                    SizedBox(width: Get.width * 0.015),
                                    Text(
                                      "Sending...",
                                      style: GoogleFonts.outfit(
                                        fontSize: Get.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: accentColor,
                                      ),
                                    ),
                                  ],
                                )
                              : _canResend
                              // 🔹 Timer done, not loading → active "Send Again"
                              ? Text(
                                  "Send Again",
                                  style: GoogleFonts.outfit(
                                    fontSize: Get.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                )
                              // 🔹 Timer still running → ring + greyed text
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: _secondsLeft / _totalSeconds,
                                            strokeWidth: 2.5,
                                            backgroundColor: textColor
                                                .withValues(alpha: 0.15),
                                            color: accentColor,
                                          ),
                                          Text(
                                            '$_secondsLeft',
                                            style: GoogleFonts.outfit(
                                              fontSize: Get.width * 0.026,
                                              fontWeight: FontWeight.w900,
                                              color: accentColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: Get.width * 0.015),
                                    Text(
                                      "Send Again",
                                      style: GoogleFonts.outfit(
                                        fontSize: Get.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: textColor.withValues(
                                          alpha: 0.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),

                  // ────────────────────────────────────────────────────────
                  SizedBox(height: Get.height * 0.04),

                  // Back to Login
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppBackIcon(size: 18, color: textColor),
                        const SizedBox(width: 5),
                        Text(
                          "Back to log in",
                          style: GoogleFonts.outfit(
                            fontSize: Get.width * 0.04,
                            color: textColor,
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
