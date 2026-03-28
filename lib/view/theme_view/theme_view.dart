import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class ThemeModeView extends StatelessWidget {
  const ThemeModeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final userOverride = themeController.userOverride.value;
      final Color primary = Theme.of(context).primaryColor;

      final currentOption = !userOverride
          ? ThemeOption.system
          : (isDark ? ThemeOption.dark : ThemeOption.light);

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
              pinned: true,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: IconButton(
                icon: const Icon(Remix.arrow_left_line),
                onPressed: () => Get.back(),
              ),
              centerTitle: true,
              title: Text(
                "APPEARANCE",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CHOOSE YOUR THEME",
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildThemeCard(
                      context,
                      "System Dynamic",
                      "Follows your device settings",
                      Remix.rocket_2_fill,
                      Colors.indigo,
                      ThemeOption.system,
                      currentOption,
                      () => themeController.setSystemTheme(),
                    ),
                    const SizedBox(height: 12),
                    _buildThemeCard(
                      context,
                      "Light Mode",
                      "Solarized for day use",
                      Remix.sun_fill,
                      Colors.orange,
                      ThemeOption.light,
                      currentOption,
                      () => themeController.setThemeMode(false),
                    ),
                    const SizedBox(height: 12),
                    _buildThemeCard(
                      context,
                      "Midnight Dark",
                      "Maximum eye comfort at night",
                      Remix.moon_fill,
                      Colors.purple,
                      ThemeOption.dark,
                      currentOption,
                      () => themeController.setThemeMode(true),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: primary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Remix.information_fill, color: primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "Changing the theme will update the entire workspace immediately.",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildThemeCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    ThemeOption value,
    ThemeOption groupValue,
    VoidCallback onTap,
  ) {
    final bool isSelected = value == groupValue;
    final primary = Theme.of(context).primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).cardColor : Theme.of(context).cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? primary : Theme.of(context).dividerColor.withValues(alpha: 0.05),
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isSelected ? primary : color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: isSelected ? primary : color, size: 24),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: const Icon(Remix.check_line, color: Colors.white, size: 14),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
