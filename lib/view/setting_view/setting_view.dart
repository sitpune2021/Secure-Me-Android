import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/setting_controller/setting_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        centerTitle: Platform.isAndroid ? false : true,
        surfaceTintColor: Colors.transparent,
        leading: Platform.isIOS
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
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
            // Add/Edit Emergency
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Add/Edit Emergency",
                style: GoogleFonts.poppins(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
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
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),

            // Auto Call on SOS
            Obx(
              () => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Auto Call On SOS",
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                value: controller.autoCallOnSos.value,
                onChanged: controller.toggleAutoCall,
                activeColor: isDark
                    ? AppColors.darkPrimary
                    : AppColors.lightPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
