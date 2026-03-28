import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PushNotificationView extends StatelessWidget {
  PushNotificationView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  // Local Rx for switch states
  final RxBool sosTriggerAlerts = true.obs;
  final RxBool trustedContactResponse = true.obs;
  final RxBool dangerZoneAlert = true.obs;
  final RxBool batteryAlerts = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final isDark = themeController.isDarkMode.value;
        final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
        final textColor = isDark ? AppColors.darkText : AppColors.lightText;
        final primaryColor = isDark ? AppColors.glowPurple : AppColors.lightPrimary;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              stretch: true,
              elevation: 0,
              backgroundColor: bgColor,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Remix.arrow_left_line, color: textColor),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "NOTIFICATIONS",
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    letterSpacing: 2,
                  ),
                ),
                centerTitle: true,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isDark)
                      Positioned(
                        top: -50,
                        right: -20,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withValues(alpha: 0.1),
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.2, 1.2),
                              duration: const Duration(seconds: 4),
                            ),
                      ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionLabel("EMERGENCY PROTOCOLS", isDark),
                  const SizedBox(height: 16),
                  _buildToggleCard(
                    context: context,
                    title: "SOS Trigger Alerts",
                    subtitle: "Get notified when emergency SOS is activated",
                    icon: Remix.error_warning_fill,
                    color: Colors.redAccent,
                    value: sosTriggerAlerts,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildToggleCard(
                    context: context,
                    title: "Guardian Responses",
                    subtitle: "Alerts when a sentinel responds to your call",
                    icon: Remix.shield_user_fill,
                    color: Colors.blueAccent,
                    value: trustedContactResponse,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 32),
                  _buildSectionLabel("MONITORING", isDark),
                  const SizedBox(height: 16),
                  _buildToggleCard(
                    context: context,
                    title: "Danger Zone Alerts",
                    subtitle: "Proximity warnings for mapped danger zones",
                    icon: Remix.skull_fill,
                    color: Colors.orangeAccent,
                    value: dangerZoneAlert,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildToggleCard(
                    context: context,
                    title: "Battery Status",
                    subtitle: "Alerts when tactical device battery is critical",
                    icon: Remix.battery_2_charge_fill,
                    color: Colors.greenAccent,
                    value: batteryAlerts,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 48),
                  
                  // Tactical Note
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Remix.information_fill, color: primaryColor, size: 24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Emergency alerts override silent mode to ensure maximum tactical awareness.",
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: textColor.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionLabel(String text, bool isDark) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: isDark ? Colors.white38 : Colors.black38,
      ),
    );
  }

  Widget _buildToggleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required RxBool value,
    required bool isDark,
  }) {
    return Obx(() => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSearchBg : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: value.value ? color.withValues(alpha: 0.3) : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03)),
          width: 1.5,
        ),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value.value,
            onChanged: (v) => value.value = v,
            activeThumbColor: color,
            activeTrackColor: color.withValues(alpha: 0.2),
          ),
        ],
      ),
    )).animate().fadeIn().slideX(begin: 0.05);
  }
}
