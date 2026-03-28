import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/setting_controller/setting_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.put(SettingsController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    const criticalRed = Colors.redAccent;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Premium Tactical Header ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            elevation: 0,
            backgroundColor: scaffoldBg,
            leading: IconButton(
              icon: Icon(Remix.arrow_left_s_line, color: textColor),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 24),
              title: Text(
                "SYSTEM PARAMETERS",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 4,
                  color: textColor,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient Glow
                  Positioned(
                    top: -50, right: -50,
                    child: Container(
                      width: 250, height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withValues(alpha: 0.1),
                      ),
                      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), child: Container()),
                    ),
                  ),
                  
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                      ),
                      child: Icon(Remix.shield_keyhole_fill, size: 60, color: primaryColor),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: const Duration(seconds: 2)),

                  ),
                ],
              ),
            ),
          ),

          // ── Settings Body ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("MISSION CONTROL", primaryColor, textColor),
                  const SizedBox(height: 16),
                  _buildTacticalSection(isDark, textColor, [
                    _buildSettingsTile(
                      icon: Remix.shield_user_fill,
                      title: "Guardian Network",
                      subtitle: "Manage emergency sentinels & priority logs",
                      color: primaryColor,
                      textColor: textColor,
                      onTap: () => Get.toNamed(AppRoutes.contactList),
                    ),
                    _buildSwitchTile(
                      icon: Remix.alarm_warning_fill,
                      title: "Auto-Panic Protocol",
                      subtitle: "Immediate emergency line activation on SOS",
                      value: controller.autoCallOnSos.value,
                      onChanged: controller.toggleAutoCall,
                      color: Colors.greenAccent,
                      textColor: textColor,
                      primaryColor: primaryColor,
                    ),
                    _buildSettingsTile(
                      icon: Remix.ghost_fill,
                      title: "Fake Call Protocol",
                      subtitle: "Deploy a diversionary rescue call",
                      color: Colors.orangeAccent,
                      textColor: textColor,
                      onTap: () => Get.toNamed(AppRoutes.fakecall),
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _buildSectionLabel("UNIT PREFERENCES", primaryColor, textColor),
                  const SizedBox(height: 16),
                  _buildTacticalSection(isDark, textColor, [
                    _buildSettingsTile(
                      icon: Remix.palette_fill,
                      title: "Tactical Appearance",
                      subtitle: "Current: Active Strategy Mode",
                      color: primaryColor,
                      textColor: textColor,
                      onTap: () => Get.toNamed(AppRoutes.theme),
                    ),
                    _buildSettingsTile(
                      icon: Remix.notification_badge_fill,
                      title: "Alert Signalling",
                      subtitle: "Configure haptic & visual alert channels",
                      color: Colors.blueAccent,
                      textColor: textColor,
                      onTap: () => Get.toNamed(AppRoutes.pushnotification),
                    ),
                  ]),

                  const SizedBox(height: 32),
                  _buildSectionLabel("SUPPORT & INTEL", primaryColor, textColor),
                  const SizedBox(height: 16),
                  _buildTacticalSection(isDark, textColor, [
                    _buildSettingsTile(
                      icon: Remix.book_read_fill,
                      title: "Mission Briefing",
                      subtitle: "How to use tactical features",
                      color: Colors.tealAccent,
                      textColor: textColor,
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 48),
                  
                  // ── RED LOGOUT BUTTON (As requested) ─────────────────────
                  _buildPrimaryDangerButton(
                    "DECOMMISSION ACCOUNT", 
                    Remix.logout_box_r_fill, 
                    () => _showLogoutDialog(context, criticalRed, isDark),
                  ),

                  const SizedBox(height: 80),
                  _buildAppVersion(textColor),
                ],
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color primaryColor, Color textColor) {
    return Row(
      children: [
        Container(width: 4, height: 14, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, color: textColor.withValues(alpha: 0.38), letterSpacing: 2),
        ),
      ],
    );
  }

  Widget _buildTacticalSection(bool isDark, Color textColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: textColor.withValues(alpha: 0.05)),
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(fontSize: 12, color: textColor.withValues(alpha: 0.38)),
                    ),
                  ],
                ),
              ),
              Icon(Remix.arrow_right_s_line, size: 20, color: textColor.withValues(alpha: 0.1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
    required Color textColor,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(fontSize: 12, color: textColor.withValues(alpha: 0.38)),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
            value: controller.autoCallOnSos.value,
            onChanged: (val) {
              HapticFeedback.heavyImpact();
              onChanged(val);
            },
            activeThumbColor: primaryColor,
          )),
        ],
      ),
    );
  }

  Widget _buildPrimaryDangerButton(String label, IconData icon, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.redAccent, size: 20),
              const SizedBox(width: 14),
              Text(
                label,
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.redAccent, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: const Duration(seconds: 3), color: Colors.redAccent.withValues(alpha: 0.15)),

    );
  }

  void _showLogoutDialog(BuildContext context, Color criticalColor, bool isDark) {
    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF111111) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32), 
            side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
          ),
          title: Center(child: Icon(Remix.error_warning_fill, color: criticalColor, size: 48)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "DECOMMISSION UNIT?",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              Text(
                "You are about to terminate the current session. Your safety protocols will remain inactive until you rejoin.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 13, color: isDark ? Colors.white60 : Colors.black54, height: 1.5),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("CANCEL", style: GoogleFonts.outfit(color: isDark ? Colors.white30 : Colors.black26, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Get.offAllNamed(AppRoutes.login);
              },
              child: Text("DECOMMISSION", style: GoogleFonts.outfit(color: criticalColor, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppVersion(Color textColor) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: textColor.withValues(alpha: 0.05))),
            child: Icon(Remix.shield_flash_fill, color: textColor.withValues(alpha: 0.12)),
          ),
          const SizedBox(height: 16),
          Text(
            "SECURE ME OS",
            style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 5, color: textColor.withValues(alpha: 0.12)),
          ),
          const SizedBox(height: 4),
          Text(
            "VERSION 4.2.0-STABLE",
            style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.bold, color: textColor.withValues(alpha: 0.05)),
          ),
        ],
      ),
    );
  }
}
