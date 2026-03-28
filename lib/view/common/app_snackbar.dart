import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
    bool isSuccess = false,
    bool isWarning = false,
  }) {
    final themeController = Get.find<ThemeController>();
    final isDark = themeController.effectiveDarkMode;
    final theme = themeController.theme;
    
    // Choose colors based on status or theme
    Color bgColor;
    Color iconColor;
    IconData icon;

    if (isError) {
      bgColor = Colors.red.withValues(alpha: 0.1);
      iconColor = Colors.red;
      icon = Remix.error_warning_fill;
    } else if (isSuccess) {
      bgColor = Colors.green.withValues(alpha: 0.1);
      iconColor = Colors.green;
      icon = Remix.checkbox_circle_fill;
    } else if (isWarning) {
      bgColor = Colors.orange.withValues(alpha: 0.1);
      iconColor = Colors.orange;
      icon = Remix.alert_fill;
    } else {
      bgColor = theme.primaryColor.withValues(alpha: 0.1);
      iconColor = theme.primaryColor;
      icon = Remix.information_fill;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isDark ? const Color(0xFF1E1C2A) : Colors.white,
      colorText: isDark ? Colors.white : Colors.black87,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      margin: const EdgeInsets.all(20),
      borderRadius: 20,
      icon: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      titleText: Text(
        title,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w800,
          fontSize: 14,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
      duration: const Duration(seconds: 4),
      shouldIconPulse: true,
      leftBarIndicatorColor: iconColor,
    );
  }
}
