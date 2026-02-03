import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class PushNotificationView extends StatelessWidget {
  PushNotificationView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  // Local Rx for switch states
  final RxBool sosTriggerAlerts = false.obs;
  final RxBool trustedContactResponse = false.obs;
  final RxBool dangerZoneAlert = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Stack(
        children: [
          // 🌗 Background
          Container(
            color: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
          ),

          // 🌟 Glow only in dark mode
          if (isDark)
            Positioned(
              top: -Get.height * 0.12,
              left: -Get.width * 0.2,
              child: Container(
                width: Get.width * 0.8,
                height: Get.width * 0.8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.glowPurple, Colors.transparent],
                    radius: 0.7,
                  ),
                ),
              ),
            ),
          if (isDark)
            Positioned(
              bottom: -Get.height * 0.12,
              right: -Get.width * 0.2,
              child: Container(
                width: Get.width * 0.8,
                height: Get.width * 0.8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.glowPurple, Colors.transparent],
                    radius: 0.7,
                  ),
                ),
              ),
            ),

          // 📝 Main content
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: isDark
                    ? Brightness.light
                    : Brightness.dark, // Android icons
                statusBarBrightness: isDark
                    ? Brightness.dark
                    : Brightness.light, // iOS icons
              ),
              title: Text(
                "Push Notification",
                style: GoogleFonts.poppins(
                  fontSize: Get.width * 0.055,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              centerTitle: Platform.isAndroid ? false : true,
              leading: IconButton(
                icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                onPressed: () => Get.back(),
              ),
            ),

            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05,
                vertical: Get.height * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.lightDivider,
                  ),
                  SizedBox(height: Get.height * 0.015),

                  // ✅ SOS Trigger Alerts
                  Obx(
                    () => _buildSwitchTile(
                      "SOS trigger alerts",
                      sosTriggerAlerts.value,
                      (val) => sosTriggerAlerts.value = val,
                      isDark,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),

                  // ✅ Trusted Contact Response
                  Obx(
                    () => _buildSwitchTile(
                      "Trusted Contact Response",
                      trustedContactResponse.value,
                      (val) => trustedContactResponse.value = val,
                      isDark,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),

                  // ✅ Danger Zone Alert
                  Obx(
                    () => _buildSwitchTile(
                      "Danger Zone Alert",
                      dangerZoneAlert.value,
                      (val) => dangerZoneAlert.value = val,
                      isDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    Function(bool) onChanged,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: Get.width * 0.045,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: isDark ? AppColors.glowPurple : AppColors.lightPrimary,
        ),
      ],
    );
  }
}
