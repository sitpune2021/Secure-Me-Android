import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/community_safety_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SafetyZoneDetailView extends StatelessWidget {
  final SafetyZone zone;
  const SafetyZoneDetailView({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          // ── Satellite Map Layer ──────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: zone.point,
              zoom: 17.5,
              tilt: 45,
            ),
            mapType: MapType.satellite,
            markers: {
              Marker(
                markerId: MarkerId(zone.id),
                position: zone.point,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  zone.status == "Safe Area" ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed
                ),
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),

          // ── Tactical HUD Overlays ────────────────────────────────────────
          _buildScanningGrids(),

          // ── Gradient Overlay (Top) ───────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),

          // ── Navigation Header ────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 44, width: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: IconButton(
                          icon: const Icon(Remix.arrow_left_line, color: Colors.white, size: 20),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "SURVEILLANCE NODE #${zone.id.substring(0, 4).toUpperCase()}",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(color: zone.color, shape: BoxShape.circle),
                            ).animate(onPlay: (c) => c.repeat()).fadeOut(duration: const Duration(seconds: 1)),
                            const SizedBox(width: 8),
                            Text(
                              "SATELLITE LINK ESTABLISHED",
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white38,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Tactical Dashboard (Bottom) ──────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildTacticalDashboard(),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningGrids() {
    return Center(
      child: Container(
        width: 300, height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: zone.color.withValues(alpha: 0.2), width: 1),
        ),
      ).animate(onPlay: (c) => c.repeat()).scale(
        begin: const Offset(1, 1), end: const Offset(2, 2),
        duration: const Duration(seconds: 4),
      ).fadeOut(),
    );
  }

  Widget _buildTacticalDashboard() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
          decoration: BoxDecoration(
            color: const Color(0xFF111111).withValues(alpha: 0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: zone.color.withValues(alpha: 0.15), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pull Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusBadge(),
                  if (zone.activeResponders > 0)
                    _buildHelperStack(),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                zone.name.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Remix.double_quotes_l, color: zone.color.withValues(alpha: 0.5), size: 16),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        zone.description,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Tactical Intelligence Metrics
              Row(
                children: [
                  _buildMetric("SECURITY SCORE", "98%", Colors.green),
                  const SizedBox(width: 24),
                  _buildMetric("RESPONSE TIME", "2.4 MIN", Colors.blue),
                ],
              ),
              
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildSecondaryButton(
                      "NAVIGATE THROUGH ${zone.status == "Safe Area" ? 'SECURE' : 'DANGER'} SECTOR",
                      Remix.navigation_fill,
                      zone.color,
                      onTap: () async {
                        final url = Uri.parse('google.navigation:q=${zone.point.latitude},${zone.point.longitude}');
                        try {
                          await launchUrl(url);
                        } catch (e) {
                          Get.snackbar("SYSTEM ERROR", "UNABLE TO INITIATE TACTICAL NAVIGATION", backgroundColor: Colors.redAccent, colorText: Colors.white);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildShareIconBtn(onTap: () {
                    SharePlus.instance.share(ShareParams(text: "TACTICAL INTEL: ${zone.name} is a ${zone.status}. Active responders: ${zone.activeResponders}. Coordinates: ${zone.point.latitude}, ${zone.point.longitude}"));
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white38, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Container(
                width: 30, height: 2,
                color: color.withValues(alpha: 0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isSafe = zone.status == "Safe Area";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: zone.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: zone.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSafe ? Remix.shield_check_fill : Remix.error_warning_fill, size: 14, color: zone.color),
          const SizedBox(width: 10),
          Text(
            zone.status.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11, fontWeight: FontWeight.w900, color: zone.color, letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperStack() {
    return Row(
      children: [
        SizedBox(
          width: 60,
          height: 24,
          child: Stack(
            children: List.generate(3, (i) => Positioned(
              left: i * 16.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: i == 0 ? Colors.blue : (i == 1 ? Colors.orange : Colors.green),
                  child: Icon(
                    i == 0 ? Remix.shield_user_fill : (i == 1 ? Remix.flashlight_fill : Remix.user_6_fill),
                    size: 8, color: Colors.white,
                  ),
                ),
              ),
            )),
          ),
        ),
        Text(
          "+${zone.activeResponders}",
          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(String label, IconData icon, Color color, {VoidCallback? onTap}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareIconBtn({VoidCallback? onTap}) {
    return Container(
      height: 60, width: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: const Icon(Remix.share_forward_fill, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
