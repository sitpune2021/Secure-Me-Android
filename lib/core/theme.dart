import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const darkBackground = Color(0xFF0A0A0F);
  static const primaryRed = Color(0xFFFF3B3B);
  static const primaryGreen = Color(0xFF00FF94);
  static const primaryBlue = Color(0xFF00D4FF);
  static const glassBackground = Color(0x1AFFFFFF);
  
  static ThemeData getThemeForRole(String role) {
    Color primaryColor;
    switch (role.toLowerCase()) {
      case 'helper':
        primaryColor = primaryGreen;
        break;
      case 'police':
        primaryColor = primaryBlue;
        break;
      default:
        primaryColor = primaryRed;
    }

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        surface: darkBackground,
        primary: primaryColor,
        secondary: primaryBlue,
        tertiary: primaryGreen,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Default theme is the User theme
  static ThemeData darkTheme = getThemeForRole('user');
}
