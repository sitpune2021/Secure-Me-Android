import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class ThemeModeView extends StatelessWidget {
  const ThemeModeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final userOverride = themeController.userOverride.value;

      final effectiveDark = userOverride
          ? isDark
          : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark;

      final bg = AppColors.background(effectiveDark);
      final textColor = AppColors.text(effectiveDark);
      final subText = AppColors.hint(effectiveDark);
      final cardColor = AppColors.card(effectiveDark);
      final primary = AppColors.primary(effectiveDark);
      final secondary = AppColors.secondary(effectiveDark);

      final currentOption = !userOverride
          ? ThemeOption.system
          : (isDark ? ThemeOption.dark : ThemeOption.light);

      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: effectiveDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: effectiveDark
                ? Brightness.dark
                : Brightness.light,
          ),
          centerTitle: Platform.isAndroid ? false : true,
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            'Theme Mode',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -0.3,
            ),
          ),
        ),
        body: Stack(
          children: [
            // Mesh Glows
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primary.withValues(alpha: 0.1),
                      primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Subtitle ──────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 2),
                    child: Text(
                      'Choose how Secure Me appears to you',
                      style: GoogleFonts.poppins(fontSize: 13, color: subText),
                    ),
                  ),
                  // ... rest of Column

                  // ── Theme Options Card ─────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: primary.withValues(
                          alpha: effectiveDark ? 0.15 : 0.08,
                        ),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: effectiveDark ? 0.45 : 0.08,
                          ),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: primary.withValues(alpha: 0.12),
                          blurRadius: 35,
                          spreadRadius: -8,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ThemeOptionTile(
                          icon: Icons.phone_android_rounded,
                          label: 'System Default',
                          description: 'Follows your device theme',
                          value: ThemeOption.system,
                          groupValue: currentOption,
                          primary: primary,
                          secondary: secondary,
                          textColor: textColor,
                          subText: subText,
                          effectiveDark: effectiveDark,
                          isFirst: true,
                          isLast: false,
                          onChanged: (_) => themeController.setSystemTheme(),
                        ),
                        Divider(
                          color: effectiveDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.06),
                          height: 1,
                          indent: 64,
                          endIndent: 20,
                        ),
                        _ThemeOptionTile(
                          icon: Icons.light_mode_rounded,
                          label: 'Light Mode',
                          description: 'Bright and clean interface',
                          value: ThemeOption.light,
                          groupValue: currentOption,
                          primary: primary,
                          secondary: secondary,
                          textColor: textColor,
                          subText: subText,
                          effectiveDark: effectiveDark,
                          isFirst: false,
                          isLast: false,
                          onChanged: (_) => themeController.setThemeMode(false),
                        ),
                        Divider(
                          color: effectiveDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.06),
                          height: 1,
                          indent: 64,
                          endIndent: 20,
                        ),
                        _ThemeOptionTile(
                          icon: Icons.dark_mode_rounded,
                          label: 'Dark Mode',
                          description: 'Easier on the eyes at night',
                          value: ThemeOption.dark,
                          groupValue: currentOption,
                          primary: primary,
                          secondary: secondary,
                          textColor: textColor,
                          subText: subText,
                          effectiveDark: effectiveDark,
                          isFirst: false,
                          isLast: true,
                          onChanged: (_) => themeController.setThemeMode(true),
                        ),
                      ],
                    ),
                  ),

                  // ── Preview Banner ─────────────────────────────────────────────
                  _PreviewBanner(
                    effectiveDark: effectiveDark,
                    primary: primary,
                    secondary: secondary,
                    textColor: textColor,
                    subText: subText,
                    cardColor: cardColor,
                    currentOption: currentOption,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final ThemeOption value;
  final ThemeOption groupValue;
  final Color primary;
  final Color secondary;
  final Color textColor;
  final Color subText;
  final bool effectiveDark;
  final bool isFirst;
  final bool isLast;
  final ValueChanged<ThemeOption?> onChanged;

  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.primary,
    required this.secondary,
    required this.textColor,
    required this.subText,
    required this.effectiveDark,
    required this.isFirst,
    required this.isLast,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(24) : Radius.zero,
        bottom: isLast ? const Radius.circular(24) : Radius.zero,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: effectiveDark ? 0.12 : 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(24) : Radius.zero,
            bottom: isLast ? const Radius.circular(24) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: selected
                    ? LinearGradient(
                        colors: [primary, secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: selected
                    ? null
                    : (effectiveDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.circular(14),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected ? Colors.white : subText,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: selected ? primary : textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: subText.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: selected
                    ? LinearGradient(colors: [primary, secondary])
                    : null,
                border: selected
                    ? null
                    : Border.all(
                        color: effectiveDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.15),
                        width: 2,
                      ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewBanner extends StatelessWidget {
  final bool effectiveDark;
  final Color primary;
  final Color secondary;
  final Color textColor;
  final Color subText;
  final Color cardColor;
  final ThemeOption currentOption;

  const _PreviewBanner({
    required this.effectiveDark,
    required this.primary,
    required this.secondary,
    required this.textColor,
    required this.subText,
    required this.cardColor,
    required this.currentOption,
  });

  @override
  Widget build(BuildContext context) {
    final label = currentOption == ThemeOption.system
        ? 'System Default'
        : currentOption == ThemeOption.light
        ? 'Light Mode'
        : 'Dark Mode';

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: primary.withValues(alpha: 0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.08),
              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Mesh Glow
            Positioned(
              right: -30,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      primary.withValues(alpha: 0.15),
                      primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary.withValues(alpha: 0.25),
                        secondary.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.verified_rounded, color: primary, size: 24),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE PREFERENCE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: subText.withValues(alpha: 0.6),
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
