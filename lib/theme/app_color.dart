import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightBackground = Colors.white;
  static const Color lightPrimary = Colors.purple;
  static const Color lightAccent = Colors.pinkAccent;
  static const Color lightText = Colors.black87;
  static const Color lightUnselected = Colors.grey;

  // Dark Theme Colors
  static const Color darkBackground = Colors.black;
  static const Color darkPrimary = Colors.purpleAccent;
  static const Color darkAccent = Colors.pinkAccent;
  static const Color darkText = Colors.white;
  static const Color darkUnselected = Colors.grey;

  // Gradients
  static const Gradient lightGradient = LinearGradient(
    colors: [lightPrimary, lightAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [darkPrimary, darkAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
