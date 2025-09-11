import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class LocationView extends StatelessWidget {
  LocationView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  // RxBool for switch state
  final RxBool autoCallLocation = false.obs;

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

          // 🌟 Top glow
          if (isDark)
            Positioned(
              top: Get.height * 0.15,
              left: -Get.width * 0.15,
              child: Container(
                width: Get.width * 0.75,
                height: Get.height * 0.25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.glowPurple, Colors.transparent],
                    radius: 1,
                  ),
                ),
              ),
            ),

          // 🌟 Bottom glow
          if (isDark)
            Positioned(
              bottom: -Get.height * 0.12,
              right: -Get.width * 0.18,
              child: Container(
                width: Get.width * 0.6,
                height: Get.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.glowPurple.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    radius: 0.8,
                  ),
                ),
              ),
            ),

          // 📝 Main UI
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                onPressed: () => Get.back(),
              ),
              centerTitle: Platform.isAndroid ? false : true,
              title: Text(
                "Location",
                style: GoogleFonts.poppins(
                  fontSize: Get.width * 0.05,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.05,
                  vertical: Get.height * 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.lightDivider,
                      thickness: 0.8,
                    ),
                    SizedBox(height: Get.height * 0.02),

                    /// ✅ Auto Call Location Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Auto Call Location On SOS",
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.045,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Obx(
                          () => Switch(
                            value: autoCallLocation.value,
                            onChanged: (val) => autoCallLocation.value = val,
                            activeColor: isDark
                                ? AppColors.glowPurple
                                : AppColors.lightPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),

                    /// 📍 Share Live Location
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.location_on,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightPrimary,
                      ),
                      title: Text(
                        "Share Live Location",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.045,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: Get.width * 0.04,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: Get.height * 0.015),

                    /// 👥 View Nearby Friends
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.people_alt,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightPrimary,
                      ),
                      title: Text(
                        "View Nearby Friends",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.045,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: Get.width * 0.04,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
