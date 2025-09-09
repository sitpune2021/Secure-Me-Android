import 'package:flutter/material.dart';

class AppColors {
  // ---------------- LIGHT THEME ----------------
  static const Color lightBackground = Colors.white;
  static const Color lightPrimary = Color(0xFF8E2DE2); // violet
  static const Color lightSecondary = Color(0xFF4A00E0); // deep purple
  static const Color lightText = Colors.black87;
  static const Color lightHint = Color(0xFF9E9E9E);
  static const Color lightDivider = Color(0xFFDDDDDD);
  static const Color lightUnselected = Colors.grey;

  // Search box bg for light mode
  static const Color lightSearchBg = Color(0xFFF5F5F5);

  // Add button background & subtle overlay
  static const Color lightAddButtonBg = Color(0x0D000000); // black 5%

  // Gradient
  static const Gradient lightGradient = LinearGradient(
    colors: [lightPrimary, lightSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ---------------- DARK THEME ----------------
  static const Color darkBackground = Color(0xFF0F0D19); // deep dark
  static const Color darkSecondaryBackground = Color(
    0xFF1A0B2E,
  ); // bottom gradient
  static const Color darkPrimary = Color(0xFF7C4DFF); // purple glow
  static const Color darkSecondary = Color(0xFF4B1E68); // darker purple blend
  static const Color darkText = Colors.white;
  static const Color darkHint = Colors.white70;
  static const Color darkDivider = Color(0x33FFFFFF); // faint line
  static const Color darkUnselected = Colors.grey;

  // Search box bg for dark mode
  static const Color darkSearchBg = Color(0xFF2C2935);

  // Add button background & subtle overlay
  static const Color darkAddButtonBg = Color(0x0DFFFFFF); // white 5%

  // Borders
  static const Color darkBorder = Color(0x66FFFFFF); // 40% white
  static const Color lightBorder = Color(0x33000000); // 20% black

  // Radial glow (dark mode)
  static const Color darkRadialGlow = Colors.purpleAccent;

  // Gradient
  static const Gradient darkGradient = LinearGradient(
    colors: [darkPrimary, darkSecondary],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}
