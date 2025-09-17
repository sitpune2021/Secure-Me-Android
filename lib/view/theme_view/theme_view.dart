import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class ThemeModeView extends StatelessWidget {
  const ThemeModeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final double screenWidth = Get.width;

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final userOverride = themeController.userOverride.value;

      // Determine effective theme
      final effectiveDark = userOverride
          ? isDark
          : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;

      final textColor =
          effectiveDark ? AppColors.darkText : AppColors.lightText;
      final backgroundColor = effectiveDark
          ? AppColors.darkBackground
          : AppColors.lightBackground;

      // Current selection
      final currentOption = !userOverride
          ? ThemeOption.system
          : (isDark ? ThemeOption.dark : ThemeOption.light);

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            "Theme Mode",
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: screenWidth < 380 ? 18 : 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          centerTitle: Platform.isAndroid ? false : true,
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RadioListTile<ThemeOption>(
              title: Text("System Default",
                  style: GoogleFonts.poppins(color: textColor)),
              value: ThemeOption.system,
              groupValue: currentOption,
              onChanged: (value) {
                themeController.setSystemTheme();
              },
            ),
            RadioListTile<ThemeOption>(
              title: Text("Light Mode",
                  style: GoogleFonts.poppins(color: textColor)),
              value: ThemeOption.light,
              groupValue: currentOption,
              onChanged: (value) {
                themeController.setThemeMode(false);
              },
            ),
            RadioListTile<ThemeOption>(
              title: Text("Dark Mode",
                  style: GoogleFonts.poppins(color: textColor)),
              value: ThemeOption.dark,
              groupValue: currentOption,
              onChanged: (value) {
                themeController.setThemeMode(true);
              },
            ),
          ],
        ),
      );
    });
  }
}
