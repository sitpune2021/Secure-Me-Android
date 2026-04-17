import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/community_safety_controller.dart';
import 'package:secure_me/view/safety_radar_view/safety_zone_detail_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SafetyRadarView extends StatefulWidget {
  const SafetyRadarView({super.key});

  @override
  State<SafetyRadarView> createState() => _SafetyRadarViewState();
}

class _SafetyRadarViewState extends State<SafetyRadarView> with SingleTickerProviderStateMixin {
  late AnimationController _radarController;
  CommunitySafetyController get controller => Get.find<CommunitySafetyController>();

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black87);
    
    // Safety check for controller
    if (!Get.isRegistered<CommunitySafetyController>()) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final CommunitySafetyController? safeController = Get.isRegistered<CommunitySafetyController>() 
        ? Get.find<CommunitySafetyController>() 
        : null;

    if (safeController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildRadarHeader(context, isDark, primaryColor, textColor, scaffoldBg),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: _buildRadarSection(isDark, primaryColor),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Tactical Mode Toggle / Info
                  _buildTacticalBanner(isDark, textColor),
                  
                  const SizedBox(height: 48),
                  _buildSectionLabel("VERIFIED SAFE HARBORS", Colors.green, textColor),
                  const SizedBox(height: 20),
                  _buildSafeZones(isDark, textColor),
                  
                  const SizedBox(height: 48),
                  _buildSectionLabel("CRITICAL DANGER ZONES", Colors.redAccent, textColor),
                  const SizedBox(height: 20),
                  _buildDangerZones(isDark, textColor),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarHeader(BuildContext context, bool isDark, Color primaryColor, Color textColor, Color scaffoldBg) {
    return SliverAppBar(
      backgroundColor: scaffoldBg,
      surfaceTintColor: Colors.transparent,
      expandedHeight: 140,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 60, bottom: 20),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SIGNAL RADAR",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: 2,
              ),
            ),
            Text(
              "SCANNING LOCAL SECTORS...",
              style: GoogleFonts.outfit(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Remix.equalizer_fill, color: textColor),
          onPressed: () => _showFilterOptions(context, isDark, primaryColor, textColor),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showFilterOptions(BuildContext context, bool isDark, Color primaryColor, Color textColor) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151515) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "RADAR FILTERS",
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: textColor.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildFilterOption(
              label: "TACTICAL UNITS",
              subtitle: "Police & Security Patrols",
              icon: Remix.shield_star_fill,
              color: Colors.blueAccent,
              isActive: true,
              isDark: isDark,
              textColor: textColor,
            ),
            const SizedBox(height: 16),
            _buildFilterOption(
              label: "MEDICAL SUPPORT",
              subtitle: "Ambulance & Registered Medics",
              icon: Remix.heart_pulse_fill,
              color: Colors.redAccent,
              isActive: true,
              isDark: isDark,
              textColor: textColor,
            ),
            const SizedBox(height: 16),
            _buildFilterOption(
              label: "SAFE DEPLOYMENTS",
              subtitle: "Active Safety Nodes & Hubs",
              icon: Remix.home_gear_fill,
              color: Colors.green,
              isActive: false,
              isDark: isDark,
              textColor: textColor,
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Text(
                  "APPLY SCAN PARAMETERS",
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterOption({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isActive,
    required bool isDark,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.3) : Colors.transparent,
          width: 1.5,
        ),
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
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: textColor.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: (v) {},
            activeColor: color,
            activeTrackColor: color.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarSection(bool isDark, Color primaryColor) {
    return GestureDetector(
      onTap: () => controller.startRadarScan(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Pulse
          ...List.generate(3, (index) {
            return Container(
              width: 100.0 * (index + 1),
              height: 100.0 * (index + 1),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (isDark ? Colors.redAccent : primaryColor).withValues(alpha: 0.1 * (3 - index)),
                  width: 1,
                ),
                shape: BoxShape.circle,
              ),
            );
          }),
          
          // Rotating Beam
          AnimatedBuilder(
            animation: _radarController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _radarController.value * 2 * math.pi,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      center: FractionalOffset.center,
                      colors: [
                        Colors.transparent,
                        (isDark ? Colors.redAccent : primaryColor).withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 0.51],
                    ),
                  ),
                ),
              );
            },
          ),

          // Central Pulse
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: (isDark ? Colors.redAccent : primaryColor).withValues(alpha: 0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.redAccent : primaryColor).withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Icon(Remix.radar_line, color: isDark ? Colors.redAccent : primaryColor, size: 24),
          ),

          // Scanned Dots
          Obx(() => SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              clipBehavior: Clip.none,
              children: controller.scannedResponders.map((r) {
                final double rad = r.angle * (math.pi / 180);
                final double dist = (r.distance / 600.0) * 150.0;
                final double x = dist * math.cos(rad);
                final double y = dist * math.sin(rad);

                return Positioned(
                  left: 150 + x - 6,
                  top: 150 + y - 6,
                  child: _buildResponderDot(r),
                );
              }).toList(),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildResponderDot(ResponderSignal signal) {
    Color dotColor = Colors.green;
    if (signal.type == 'police') dotColor = Colors.blue;
    if (signal.type == 'medic') dotColor = Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: dotColor, blurRadius: 10, spreadRadius: 1)],
      ),
      child: const Icon(Remix.user_location_fill, size: 6, color: Colors.white),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
      begin: const Offset(1, 1), end: const Offset(1.4, 1.4), duration: const Duration(milliseconds: 1000),
    );
  }

  Widget _buildTacticalBanner(bool isDark, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Remix.shield_flash_fill, color: Colors.redAccent, size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TACTICAL RESPONSE ACTIVE",
                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: textColor, letterSpacing: 1),
                ),
                Text(
                  "Scanned area is partially secured. Maintain vigilance.",
                  style: GoogleFonts.outfit(fontSize: 11, color: textColor.withValues(alpha: 0.4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, Color color, Color textColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13, fontWeight: FontWeight.w900, color: textColor, letterSpacing: 2,
          ),
        ),
        const Spacer(),
        Text(
          "VIEW ALL",
          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: textColor.withValues(alpha: 0.2)),
        ),
      ],
    );
  }

  Widget _buildSafeZones(bool isDark, Color textColor) {
    return Obx(() => Column(
      children: controller.safetyZones
          .where((z) => z.status == "Safe Area")
          .map((zone) => _buildZoneCard(zone, isDark, textColor))
          .toList(),
    ));
  }

  Widget _buildDangerZones(bool isDark, Color textColor) {
    return Obx(() => Column(
      children: controller.safetyZones
          .where((z) => z.status == "Danger Zone")
          .map((zone) => _buildZoneCard(zone, isDark, textColor))
          .toList(),
    ));
  }

  Widget _buildZoneCard(SafetyZone zone, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(() => SafetyZoneDetailView(zone: zone)),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111111) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: zone.color.withValues(alpha: 0.1)),
              boxShadow: isDark ? null : [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                // Zone Thumbnail Preview
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.black12,
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1544256718-3bcf237f3974?q=80&w=2671&auto=format&fit=crop"), 
                      fit: BoxFit.cover,
                      opacity: 0.4,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      zone.status == "Safe Area" ? Remix.shield_check_fill : Remix.error_warning_fill,
                      color: zone.color, size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone.name,
                        style: GoogleFonts.outfit(
                          fontSize: 17, fontWeight: FontWeight.w800, color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        zone.description,
                        style: GoogleFonts.outfit(fontSize: 12, color: textColor.withValues(alpha: 0.4)),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildMiniBadge("${zone.activeResponders} ACTIVE units", zone.color, textColor, isDark),
                          const SizedBox(width: 8),
                          _buildMiniBadge("NODAL SYNC", Colors.blueGrey, textColor, isDark),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Remix.arrow_right_s_line, color: textColor.withValues(alpha: 0.1)),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color color, Color textColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.bold, color: color == Colors.blueGrey ? (isDark ? Colors.white38 : Colors.black38) : color),
      ),
    );
  }
}
