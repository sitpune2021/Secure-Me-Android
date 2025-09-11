import 'package:flutter/material.dart';
import 'package:secure_me/theme/app_color.dart';

class AppTheme {
  // ------------------ Light Theme ------------------
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightText),
      titleTextStyle: TextStyle(
        color: AppColors.lightText,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.lightText),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightText),
      bodyMedium: TextStyle(color: AppColors.lightText),
    ),
    dividerColor: AppColors.lightDivider,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.lightUnselected,
      showUnselectedLabels: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withOpacity(0.05),
      hintStyle: const TextStyle(color: AppColors.lightHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide.none,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightSecondary,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // ------------------ Dark Theme ------------------
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,

    /// Instead of plain color, we will use gradient at screen level
    scaffoldBackgroundColor: Colors.transparent,

    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // let gradient show
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkText),
      titleTextStyle: TextStyle(
        color: AppColors.darkText,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.darkText),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkHint),
    ),
    dividerColor: AppColors.darkDivider,

    /// Bottom navigation styled like screenshot
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent, // gradient container will handle
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.darkUnselected,
      showUnselectedLabels: true,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      hintStyle: const TextStyle(color: AppColors.darkHint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide.none,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSecondary,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // ------------------ SCREEN-SPECIFIC HELPERS ------------------
  // Login Screen
  static Color loginButtonBackground(bool isDark) =>
      isDark ? AppColors.glowPurpleTopLeft : AppColors.lightPrimary;

  static Color loginTextColor(bool isDark) =>
      isDark ? AppColors.darkText : AppColors.lightText;

  static Color loginHintTextColor(bool isDark) =>
      isDark ? AppColors.darkHint : AppColors.lightHint;

  static Color loginTextFieldBg(bool isDark) =>
      isDark ? AppColors.darkSearchBg : AppColors.lightSearchBg;

  // Register Screen
  static Color registerAvatarGlow(bool isDark) =>
      isDark ? AppColors.darkRadialGlow : Colors.transparent;

  static Gradient registerAvatarGlowGradient(bool isDark) =>
      isDark ? AppColors.darkGlowGradient : AppColors.lightGlowGradient;
}
