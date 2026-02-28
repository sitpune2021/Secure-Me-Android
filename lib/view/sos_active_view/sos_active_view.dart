import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/sos_controller/sos_controller.dart';

class SosActivatedView extends StatelessWidget {
  const SosActivatedView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final SosController sosController = Get.put(SosController());

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final theme = themeController.theme;

      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.08),
            child: Column(
              children: [
                const Spacer(), // pushes content to center
                // 🔔 SOS Image + Text
                Column(
                  children: [
                    Image.asset(
                      "assets/images/bell.png",
                      height: Get.height * 0.25,
                    ),
                    SizedBox(height: Get.height * 0.03),
                    if (sosController.isTriggering.value) ...[
                      const CircularProgressIndicator(color: Colors.red),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        "Triggering SOS...",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ] else ...[
                      Text(
                        sosController.triggerMessage.value.isNotEmpty
                            ? sosController.triggerMessage.value
                            : "SOS Activated!",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.05,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),

                const Spacer(), // pushes button to bottom
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: Get.height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.back(); // Close screen or stop SOS
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.045,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
