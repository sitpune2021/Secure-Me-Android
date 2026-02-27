import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/setting_controller/setting_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.put(SettingsController());
  final ThemeController themeController = Get.find();

  bool get effectiveDark {
    final isDark = themeController.isDarkMode.value;
    final userOverride = themeController.userOverride.value;
    return userOverride
        ? isDark
        : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dark = effectiveDark;
      final bg = AppColors.background(dark);
      final textColor = AppColors.text(dark);
      final subText = AppColors.hint(dark);
      final cardColor = AppColors.card(dark);
      final primary = AppColors.primary(dark);
      final secondary = AppColors.secondary(dark);
      final divider = AppColors.divider(dark);

      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
            statusBarBrightness: dark ? Brightness.dark : Brightness.light,
          ),
          centerTitle: Platform.isAndroid ? false : true,
          leading: Platform.isIOS
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: textColor),
                  onPressed: () => Get.back(),
                )
              : null,
          title: Text(
            'Settings',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -0.3,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Mesh Glow ──
              Stack(
                children: [
                  Positioned(
                    top: -40,
                    right: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primary.withValues(alpha: 0.12),
                            primary.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // ── Section: Safety ────────────────────────────────────────────
              _SectionLabel(label: 'Safety', color: subText),
              _SettingsCard(
                cardColor: cardColor,
                dividerColor: divider,
                dark: dark,
                primaryColor: primary,
                children: [
                  _SettingsTile(
                    icon: Icons.contacts_rounded,
                    iconBg: primary.withValues(alpha: 0.12),
                    iconColor: primary,
                    title: 'Emergency Contacts',
                    subtitle: 'Add or edit emergency contacts',
                    trailing: Icon(Icons.chevron_right_rounded, color: subText),
                    onTap: () => Get.toNamed(AppRoutes.contactList),
                    textColor: textColor,
                    subText: subText,
                  ),
                  Divider(color: divider, height: 1, indent: 58),
                  Obx(
                    () => _SettingsSwitchTile(
                      icon: Icons.phone_in_talk_rounded,
                      iconBg: const Color(0xFF00C783).withValues(alpha: 0.12),
                      iconColor: const Color(0xFF00C783),
                      title: 'Auto Call on SOS',
                      subtitle: 'Automatically call when SOS is triggered',
                      value: controller.autoCallOnSos.value,
                      onChanged: controller.toggleAutoCall,
                      textColor: textColor,
                      subText: subText,
                      activeColor: primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Section: Appearance ────────────────────────────────────────
              _SectionLabel(label: 'Appearance', color: subText),
              _SettingsCard(
                cardColor: cardColor,
                dividerColor: divider,
                dark: dark,
                primaryColor: primary,
                children: [
                  _SettingsTile(
                    icon: Icons.dark_mode_rounded,
                    iconBg: secondary.withValues(alpha: 0.15),
                    iconColor: secondary,
                    title: 'Theme Mode',
                    subtitle: 'Light, Dark or System default',
                    trailing: Icon(Icons.chevron_right_rounded, color: subText),
                    onTap: () => Get.toNamed(AppRoutes.theme),
                    textColor: textColor,
                    subText: subText,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Section: Notifications ─────────────────────────────────────
              _SectionLabel(label: 'Notifications', color: subText),
              _SettingsCard(
                cardColor: cardColor,
                dividerColor: divider,
                dark: dark,
                primaryColor: primary,
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_rounded,
                    iconBg: const Color(0xFFFF9500).withValues(alpha: 0.12),
                    iconColor: const Color(0xFFFF9500),
                    title: 'Notification Settings',
                    subtitle: 'Manage alert preferences',
                    trailing: Icon(Icons.chevron_right_rounded, color: subText),
                    onTap: () => Get.toNamed(AppRoutes.notification),
                    textColor: textColor,
                    subText: subText,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Section: About ─────────────────────────────────────────────
              _SectionLabel(label: 'About', color: subText),
              _SettingsCard(
                cardColor: cardColor,
                dividerColor: divider,
                dark: dark,
                primaryColor: primary,
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    iconBg: const Color(0xFF5AC8FA).withValues(alpha: 0.12),
                    iconColor: const Color(0xFF5AC8FA),
                    title: 'About Us',
                    subtitle: 'Learn more about Secure Me',
                    trailing: Icon(Icons.chevron_right_rounded, color: subText),
                    onTap: () {},
                    textColor: textColor,
                    subText: subText,
                  ),
                  Divider(color: divider, height: 1, indent: 58),
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    iconBg: const Color(0xFF30D158).withValues(alpha: 0.12),
                    iconColor: const Color(0xFF30D158),
                    title: 'Help & Support',
                    subtitle: 'FAQs and contact support',
                    trailing: Icon(Icons.chevron_right_rounded, color: subText),
                    onTap: () {},
                    textColor: textColor,
                    subText: subText,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ── App version ────────────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => LinearGradient(
                        colors: [primary, secondary],
                      ).createShader(b),
                      child: Text(
                        'Secure Me',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Version 1.0.0',
                      style: GoogleFonts.poppins(fontSize: 11, color: subText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Color cardColor;
  final Color dividerColor;
  final bool dark;
  final Color primaryColor;
  final List<Widget> children;

  const _SettingsCard({
    required this.cardColor,
    required this.dividerColor,
    required this.dark,
    required this.primaryColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withValues(alpha: dark ? 0.12 : 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.4 : 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final Color textColor;
  final Color subText;

  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.textColor,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(fontSize: 11.5, color: subText),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color textColor;
  final Color subText;
  final Color activeColor;

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.textColor,
    required this.subText,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(fontSize: 11.5, color: subText),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      ),
    );
  }
}
