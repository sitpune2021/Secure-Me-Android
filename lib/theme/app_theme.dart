import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const primaryRed = Color(0xFFEB4335);
  static const primaryPink = Color(0xFFFF2D78);
  static const primaryGreen = Color(0xFF34A853);
  static const primaryBlue = Color(0xFF4285F4);
  static const primaryOrange = Color(0xFFFBBC05);
  static const glassBackground = Color(0x1AFFFFFF);

  // Surface Colors for Modes
  static const lightBackground = Colors.white;
  static const darkBackground = Color(0xFF0F0F14);
  static const lightCard = Colors.white;
  static const darkCard = Color(0xFF1A1A22);

  static ThemeData getThemeForRole(String role, {bool isDark = false}) {
    Color primaryColor;
    switch (role) {
      case 'None':
      case 'none':
        primaryColor = Colors.grey;
        break;
      case 'Gym_Person':
      case 'gymperson':
      case 'gym_person':
        primaryColor = primaryGreen;
        break;
      case 'Police':
      case 'police':
        primaryColor = primaryBlue;
        break;
      case 'Manager':
      case 'manager':
      case 'user':
        primaryColor = primaryPink;
        break;
      default:
        primaryColor = primaryPink;
    }

    final brightness = isDark ? Brightness.dark : Brightness.light;
    final scaffoldBg = isDark ? darkBackground : lightBackground;
    final cardBg = isDark ? darkCard : lightCard;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white38 : Colors.black38;
    final dividerColor = isDark ? Colors.white10 : Colors.black12;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: primaryColor,
      cardColor: cardBg,
      dividerColor: dividerColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: primaryColor.withValues(alpha: 0.8),
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: scaffoldBg,
        onSurface: textColor,
        surfaceContainerHighest: cardBg,
        onSurfaceVariant: hintColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: GoogleFonts.outfit(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        hintStyle: GoogleFonts.outfit(color: hintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  // Pre-built themes (backward compatibility)
  static ThemeData lightTheme = getThemeForRole('manager');
  static ThemeData darkTheme = getThemeForRole('manager', isDark: true);

  static ThemeData get light => lightTheme;
  static ThemeData get dark => darkTheme;
}
