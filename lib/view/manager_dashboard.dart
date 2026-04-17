import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/community_safety_controller.dart';
import 'package:secure_me/controller/incident_controller.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final IncidentController incidentController = Get.find<IncidentController>();
    final CommunitySafetyController communityController = Get.find<CommunitySafetyController>();
    final ThemeController themeController = Get.find<ThemeController>();
    
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final primaryColor = Theme.of(context).primaryColor;
      final textColor = isDark ? Colors.white : const Color(0xFF1E1E1E);

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildTacticalHeader(context, isDark, primaryColor, textColor),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildMetricGrid(context, primaryColor, isDark),
                  const SizedBox(height: 40),
                  _buildSectionHeader(context, "OPERATIONAL HOTSPOTS", Remix.radar_line, primaryColor),
                  const SizedBox(height: 16),
                  _buildHotspotHeatmap(context, communityController, isDark),
                  const SizedBox(height: 40),
                  _buildEmergencyAccess(context, primaryColor, isDark),
                  const SizedBox(height: 40),
                  _buildSectionHeader(context, "INCIDENT AUDIT LOGS", Remix.history_line, Colors.redAccent),
                  const SizedBox(height: 16),
                  _buildIncidentAuditList(context, incidentController, isDark),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTacticalHeader(BuildContext context, bool isDark, Color primaryColor, Color textColor) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Tactical grid background
            Positioned.fill(
              child: Opacity(
                opacity: isDark ? 0.05 : 0.02,
                child: Image.network(
                  "https://www.transparenttextures.com/patterns/carbon-fibre.png",
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
            // Solid background to match scaffold
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          "SYSTEM ACTIVE",
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                            letterSpacing: 2,
                          ),
                        ),
                      ).animate().fadeIn().scale(delay: const Duration(milliseconds: 200)),
                      const SizedBox(width: 8),
                      Text(
                        "v4.0.2-ALPHA",
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: textColor.withValues(alpha: 0.2),
                          letterSpacing: 1,
                        ),
                      ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "SECURE-ME HQ",
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideX(begin: -0.1),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              _buildHeaderAction(
                context, 
                Get.find<ThemeController>().isDarkMode.value ? Remix.sun_fill : Remix.moon_fill, 
                () => Get.find<ThemeController>().setThemeMode(!Get.find<ThemeController>().isDarkMode.value),
                isDark ? Colors.amber : Colors.indigo,
              ),
              const SizedBox(width: 8),
              _buildHeaderAction(
                context, 
                Remix.logout_box_r_line, 
                () => Get.find<AuthController>().logout(),
                Colors.redAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderAction(BuildContext context, IconData icon, VoidCallback onTap, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: color, size: 20),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMetricGrid(BuildContext context, Color primaryColor, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            _buildTacticalStat(context, "ACTIVE SIGNALS", "04", Remix.pulse_fill, Colors.redAccent, isDark),
            const SizedBox(width: 16),
            _buildTacticalStat(context, "SENTINELS", "18", Remix.shield_user_fill, Colors.blueAccent, isDark),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTacticalStat(context, "AVG RESPONSE", "2.1m", Remix.timer_flash_fill, Colors.greenAccent, isDark),
            const SizedBox(width: 16),
            _buildTacticalStat(context, "SECTORS SCAN", "OK", Remix.radar_fill, primaryColor, isDark),
          ],
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 500)).slideY(begin: 0.1);
  }

  Widget _buildTacticalStat(BuildContext context, String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color.withValues(alpha: 0.5), size: 18),
                Container(
                  width: 4, height: 4,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ).animate(onPlay: (c) => c.repeat()).shimmer(duration: const Duration(seconds: 1)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.5)),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        Text(
          "REAL-TIME FEED",
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: color.withValues(alpha: 0.3),
          ),
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 600));
  }

  Widget _buildHotspotHeatmap(BuildContext context, CommunitySafetyController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: controller.hotspots.map((h) {
          final isHigh = h['safetyLevel'] == "High Risk";
          final color = isHigh ? Colors.redAccent : Colors.orangeAccent;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Remix.map_pin_2_fill, color: color, size: 18),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h['id'] == "h1" ? "Pune Central Hub" : "East Side Square",
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "Last incident scanned: 14m ago",
                        style: GoogleFonts.outfit(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${h['incidentCount']}",
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: color, fontSize: 18),
                    ),
                    Text(
                      "ALERTS",
                      style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.w900, color: color.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 700)).slideX(begin: 0.05);
        }).toList(),
      ),
    );
  }

  Widget _buildEmergencyAccess(BuildContext context, Color primaryColor, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed("/safetyRadar"),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withValues(alpha: 0.2),
              primaryColor.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Remix.radar_line, color: primaryColor, size: 32)
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: const Duration(seconds: 2)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DEPLOY SIGNAL RADAR",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "Instant scan of nearby responders",
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Remix.arrow_right_s_line, color: primaryColor.withValues(alpha: 0.3)),
          ],
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 800)).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildIncidentAuditList(BuildContext context, IncidentController controller, bool isDark) {
    return Obx(() {
      if (controller.history.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              Icon(Remix.shield_check_line, size: 48, color: Colors.greenAccent.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                "QUIET SECTOR",
                style: GoogleFonts.outfit(
                  fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                ),
              ),
              Text(
                "No active incidents reported in 24h",
                style: GoogleFonts.outfit(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
              ),
            ],
          ),
        );
      }
      return Column(
        children: controller.history.map((log) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Remix.error_warning_fill, color: Colors.redAccent, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.location,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Responders: ${log.responderIds.length} units deployed",
                      style: GoogleFonts.outfit(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  log.resolution.toUpperCase(),
                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.greenAccent),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 900)).slideY(begin: 0.2)).toList(),
      );
    });
  }
}
