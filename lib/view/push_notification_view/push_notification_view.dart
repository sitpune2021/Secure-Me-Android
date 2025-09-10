import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/theme/app_color.dart';

class PushNotificationController extends GetxController {
  RxBool sosTriggerAlerts = false.obs;
  RxBool trustedContactResponse = false.obs;
  RxBool dangerZoneAlert = false.obs;

  void toggleSosTrigger(bool value) => sosTriggerAlerts.value = value;
  void toggleTrustedContact(bool value) => trustedContactResponse.value = value;
  void toggleDangerZone(bool value) => dangerZoneAlert.value = value;
}

class PushNotificationView extends StatelessWidget {
  final PushNotificationController controller = Get.put(
    PushNotificationController(),
  );

  PushNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // 🌗 Background
        Container(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
                    controller.sosTriggerAlerts.value,
                    controller.toggleSosTrigger,
                    isDark,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),

                // ✅ Trusted Contact Response
                Obx(
                  () => _buildSwitchTile(
                    "Trusted Contact Response",
                    controller.trustedContactResponse.value,
                    controller.toggleTrustedContact,
                    isDark,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),

                // ✅ Danger Zone Alert
                Obx(
                  () => _buildSwitchTile(
                    "Danger Zone Alert",
                    controller.dangerZoneAlert.value,
                    controller.toggleDangerZone,
                    isDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
          activeColor: isDark ? AppColors.glowPurple : AppColors.lightPrimary,
        ),
      ],
    );
  }
}
