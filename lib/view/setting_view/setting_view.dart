import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/setting_controller/setting_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.put(SettingsController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final theme = themeController.theme;

      return Stack(
        children: [
          // 🌗 Theme-aware background
          Container(color: theme.colorScheme.surface),

          // 🌟 Glow only in Dark Theme
          if (isDark)
            Positioned(
              top: -Get.height * 0.1,
              left: -Get.width * 0.1,
              child: Container(
                width: Get.width * 0.7,
                height: Get.width * 0.7,
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
                    : Brightness.dark,
                statusBarBrightness: isDark
                    ? Brightness.dark
                    : Brightness.light,
              ),
              title: Text(
                'Setting',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              centerTitle: Platform.isAndroid ? false : true,
              leading: Platform.isIOS
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                      onPressed: () => Get.back(),
                    )
                  : null,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * .035),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📌 Add/Edit Emergency
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Add Edit Emergency",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: Get.width * .08,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.contactList);
                    },
                  ),

                  Divider(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.lightDivider,
                  ),

                  // 📌 Auto Call on SOS
                  Obx(
                    () => SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Auto Call On SOS",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                      ),
                      value: controller.autoCallOnSos.value,
                      onChanged: controller.toggleAutoCall,
                      activeThumbColor: isDark
                          ? AppColors.glowPurple
                          : AppColors.lightPrimary,
                    ),
                  ),
                  Divider(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.lightDivider,
                  ),

                  // 📌 Logout
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    onTap: () {
                      _showLogoutDialog(context, isDark);
                    },
                  ),
                ],
              ),
            ),
            // Loading Overlay inside Scaffold context
          ),
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
    });
  }

  void _showLogoutDialog(BuildContext context, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppColors.darkSearchBg : Colors.white,
        title: Text(
          "Logout",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        content: Text(
          "Are you sure you want to log out from the application?",
          style: GoogleFonts.poppins(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                color: (isDark ? AppColors.darkText : AppColors.lightText)
                    .withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Get.back(); // close dialog
              controller.logout();
            },
            child: Text(
              "Logout",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
