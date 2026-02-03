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
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;

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
  static const Color darkBackground = Color(0xFF0E0B16); // adjust if needed
  static const Color glowPurple = Color(0xFF7C3A82); // purple glow// deep dark
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
  static const Gradient addButtonGradient = LinearGradient(
    colors: [
      Color(0xFFC37DB5), // light purple-pink
      Color(0xFF7C3A82), // deep purple
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color glowPurpleTopLeft = Color(0xFF7C3A82); // deep purple
  static const Color glowPurpleBottomRight = Color(0xFF2B0A2F); // darker tone

  // Borders
  static const Color darkBorder = Color(0x66FFFFFF); // 40% white
  static const Color lightBorder = Color(0x33000000); // 20% black
  static const Color saveButtonColor = Color(0xFFA6A0A7);

  // Radial glow (dark mode)
  static const Color darkRadialGlow = Colors.purpleAccent;

  // Gradient
  static const Gradient darkGradient = LinearGradient(
    colors: [darkPrimary, darkSecondary],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ---------------- NEW ADDITIONS ----------------

  // Cards
  static const Color lightCard = Colors.white;
  static const Color darkCard = Color(0xFF1E1C2A);

  // Shadows
  static const Color lightShadow = Color(0x33000000); // subtle black shadow
  static const Color darkShadow = Color(0x66000000); // stronger shadow

  // Glow gradients
  static const Gradient lightGlowGradient = RadialGradient(
    colors: [
      Color(0xFF8E2DE2), // violet
      Colors.transparent,
    ],
    radius: 0.6,
  );

  static const Gradient darkGlowGradient = RadialGradient(
    colors: [darkRadialGlow, Colors.transparent],
    radius: 0.6,
  );

  static const Color greyTextLight = Color(
    0xFF757575,
  ); // light grey for light mode
  static const Color greyTextDark = Color(0xFFBDBDBD);
  static const Color accent = Color(0xFF9C27B0);

  // ---------------- COMMON COLORS ----------------

  // Transparent
  static const Color transparent = Colors.transparent;

  // Pure colors
  static const Color pureWhite = Colors.white;
  static const Color pureBlack = Colors.black;

  // Grey shades
  static const Color grey = Colors.grey;
  static const Color greyShade100 = Color(0xFFF5F5F5);
  static const Color greyShade200 = Color(0xFFEEEEEE);
  static const Color greyShade300 = Color(0xFFE0E0E0);
  static const Color greyShade400 = Color(0xFFBDBDBD);
  static const Color greyShade500 = Color(0xFF9E9E9E);
  static const Color greyShade600 = Color(0xFF757575);

  // Accent colors
  static const Color purpleAccent = Colors.purpleAccent;
  static const Color pinkAccent = Colors.pinkAccent;
  static const Color purple = Colors.purple;
  static const Color pink = Colors.pink;

  // Semi-transparent whites
  static const Color white54 = Colors.white54;
  static const Color white70 = Colors.white70;

  // Semi-transparent blacks
  static const Color black54 = Colors.black54;
  static const Color black87 = Colors.black87;

  // ---------------- SCREEN-SPECIFIC COLOR HELPERS ----------------

  // Login Screen
  static Color loginButtonBackground(bool isDark) =>
      isDark ? glowPurpleTopLeft : lightPrimary;

  static Color loginTextColor(bool isDark) => isDark ? darkText : lightText;

  static Color loginHintTextColor(bool isDark) => isDark ? darkHint : lightHint;

  static Color loginTextFieldBg(bool isDark) =>
      isDark ? darkSearchBg : lightSearchBg;

  // Common Colors
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static const Color greenAccent = Colors.greenAccent;

  // Register Screen
  static Color registerAvatarGlow(bool isDark) =>
      isDark ? darkRadialGlow : transparent;

  static Gradient registerAvatarGlowGradient(bool isDark) =>
      isDark ? darkGlowGradient : lightGlowGradient;

  // Snackbar colors
  static Color snackBarBg(bool isDark) =>
      isDark ? AppColors.darkAddButtonBg : AppColors.lightAddButtonBg;

  static Color snackBarText(bool isDark) =>
      isDark ? AppColors.darkText : AppColors.lightText;

  static Color loginIconCircle(bool isDark) =>
      isDark ? const Color(0xFFB573FF) : const Color(0xFF8A2BE2);

  static Color loginIconSymbol(bool isDark) => isDark ? pureWhite : pureWhite;

  // Login Title ("Login Account")
  static Color loginTitleColor(bool isDark) =>
      isDark ? const Color(0xFFE96AAE) : pureBlack;

  // Welcome Text ("Welcome back")
  static Color welcomeTextColor(bool isDark) =>
      isDark ? const Color(0xFFE4A7CC) : const Color(0xFF6E6E6E);

  // ---------------- THEME-AWARE HELPERS ----------------

  // Background colors
  static Color background(bool isDark) =>
      isDark ? darkBackground : lightBackground;

  // Card colors
  static Color card(bool isDark) => isDark ? darkCard : lightCard;

  // Text colors
  static Color text(bool isDark) => isDark ? darkText : lightText;

  // Hint colors
  static Color hint(bool isDark) => isDark ? darkHint : lightHint;

  // Divider colors
  static Color divider(bool isDark) => isDark ? darkDivider : lightDivider;

  // Primary colors
  static Color primary(bool isDark) => isDark ? darkPrimary : lightPrimary;

  // Secondary colors
  static Color secondary(bool isDark) =>
      isDark ? darkSecondary : lightSecondary;

  // Border colors
  static Color border(bool isDark) => isDark ? darkBorder : lightBorder;

  // Search background
  static Color searchBg(bool isDark) => isDark ? darkSearchBg : lightSearchBg;

  // Add button background
  static Color addButtonBg(bool isDark) =>
      isDark ? darkAddButtonBg : lightAddButtonBg;

  // Accent color (theme-aware)
  static Color accentColor(bool isDark) => isDark ? purpleAccent : accent;

  // Grey text
  static Color greyText(bool isDark) => isDark ? greyTextDark : greyTextLight;

  // Grey shade (theme-aware)
  static Color greyShade(bool isDark, int shade) {
    if (isDark) {
      return greyShade400;
    }
    switch (shade) {
      case 100:
        return greyShade100;
      case 200:
        return greyShade200;
      case 300:
        return greyShade300;
      case 400:
        return greyShade400;
      case 500:
        return greyShade500;
      case 600:
        return greyShade600;
      default:
        return grey;
    }
  }
}
