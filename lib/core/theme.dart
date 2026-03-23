import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const darkBackground = Color(0xFF0A0A0F);
  static const primaryRed = Color(0xFFFF3B3B);
  static const primaryGreen = Color(0xFF00FF94);
  static const primaryBlue = Color(0xFF00D4FF);
  static const glassBackground = Color(0x1AFFFFFF);
  
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryRed,
    colorScheme: const ColorScheme.dark(
      surface: darkBackground,
      primary: primaryRed,
      secondary: primaryBlue,
      tertiary: primaryGreen,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
