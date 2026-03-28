import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/community_safety_controller.dart';
import 'package:secure_me/controller/incident_controller.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final IncidentController incidentController = Get.find<IncidentController>();
    final CommunitySafetyController communityController = Get.find<CommunitySafetyController>();
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildUserHeader(context, primaryColor),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildMetricCards(context),
                   const SizedBox(height: 32),
                   _buildHotspotHeatmap(context, communityController),
                   const SizedBox(height: 32),
                   _buildSectionTitle(context, "COMMUNITY SAFETY RADAR"),
                   const SizedBox(height: 16),
                   _buildRadarQuickAccess(context),
                   const SizedBox(height: 32),
                   _buildSectionTitle(context, "RECENT INCIDENT AUDIT LOGS"),
                   const SizedBox(height: 16),
                   _buildIncidentList(context, incidentController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, Color primaryColor) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: Text(
          "SECURE-ME HQ",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: primaryColor,
            letterSpacing: 2,
          ),
        ),
      ),
      actions: [
        Obx(() {
          final isDark = Get.find<ThemeController>().isDarkMode.value;
          return IconButton(
            onPressed: () => Get.find<ThemeController>().setThemeMode(!isDark),
            icon: Icon(
              isDark ? Remix.sun_fill : Remix.moon_fill, 
              color: isDark ? Colors.amber : Colors.indigo,
            ),
          );
        }),
        IconButton(
          onPressed: () => Get.find<AuthController>().logout(), 
          icon: const Icon(Remix.logout_box_r_line, color: Colors.redAccent)
        ),
      ],
    );
  }

  Widget _buildMetricCards(BuildContext context) {
    return Row(
      children: [
        _buildStatBox(context, "LIVE SIGNALS", "04", Colors.red),
        const SizedBox(width: 12),
        _buildStatBox(context, "POLICE ON DUTY", "18", Colors.blue),
        const SizedBox(width: 12),
        _buildStatBox(context, "AVG RESPONSE", "2.4m", Colors.green),
      ],
    );
  }

  Widget _buildStatBox(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.w900, color: color, letterSpacing: 1)),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildHotspotHeatmap(BuildContext context, CommunitySafetyController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: controller.hotspots.map((h) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: h.safetyLevel == "High Risk" ? Colors.red : Colors.orange,
                  shape: BoxShape.circle
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(h.id == "h1" ? "Pune Central Hub" : "East Side Square", style: GoogleFonts.outfit(fontSize: 14)),
              ),
              Text("${h.incidentCount} Alerts", style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildRadarQuickAccess(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed("/safetyRadar"),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent.withValues(alpha: 0.15), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Remix.radar_line, color: Colors.redAccent, size: 32),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Signal Radar Active",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "Scanning for nearby police & helpers",
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Remix.arrow_right_s_line, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentList(BuildContext context, IncidentController controller) {
    return Obx(() {
      if (controller.history.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
             color: Theme.of(context).cardColor,
             borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            children: [
              const Icon(Remix.shield_check_line, size: 48, color: Colors.green),
              const SizedBox(height: 16),
              Text("No major incidents reported in 24h", style: GoogleFonts.outfit(color: Colors.grey)),
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
             borderRadius: BorderRadius.circular(24),
           ),
           child: Row(
             children: [
               const Icon(Remix.pulse_line, color: Colors.red),
               const SizedBox(width: 16),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(log.location, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                     Text("Responders: ${log.responderIds.length}", style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
                   ],
                 ),
               ),
               Text(log.resolution, style: GoogleFonts.outfit(fontSize: 12, color: Colors.green)),
             ],
           ),
        )).toList(),
      );
    });
  }
}
