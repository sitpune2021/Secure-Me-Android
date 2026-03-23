import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/controller/safety_controller.dart';
import 'package:secure_me/model/signal_model.dart';
import 'package:secure_me/core/theme.dart';
import 'package:secure_me/core/components.dart';

class UserHomeScreen extends StatelessWidget {
  UserHomeScreen({super.key});

  final SafetyController _safetyController = Get.put(SafetyController());

  void _onToggleSignal() {
    if (_safetyController.status.value == SignalStatus.pending) {
       _safetyController.activateEmergency(const LocationModel(latitude: 37.7749, longitude: -122.4194, address: 'San Francisco, CA'));
    } else {
       _safetyController.cancelEmergency();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActivated = _safetyController.status.value == SignalStatus.sent;

      return Scaffold(
        body: Stack(
          children: [
            // Google Maps Background
            const GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 14),
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: {},
              circles: {},
            ),
            
            // Dark Overlay for map
            Container(
              color: AppTheme.darkBackground.withValues(alpha: 0.5),
            ),
            
            // Floating Header
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Secure Me', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('Personal Safety Dashboard', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundColor: AppTheme.glassBackground,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // Ripple effect when activated
            if (isActivated) 
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryRed.withValues(alpha: 0.3), width: 2),
                  ),
                ).animate(onPlay: (controller) => controller.repeat())
                 .scale(begin: const Offset(0.5, 0.5), end: const Offset(2.0, 2.0), duration: const Duration(seconds: 2), curve: Curves.easeOut)
                 .fadeOut(begin: 0.5, duration: const Duration(seconds: 2)),
              ),

            // Panic button center
            Center(
              child: GestureDetector(
                onTap: _onToggleSignal,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulse animation
                    if (isActivated)
                      GlowContainer(
                        glowColor: AppTheme.primaryRed,
                        blurRadius: 40,
                        spreadRadius: 10,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryRed.withValues(alpha: 0.1),
                          ),
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                       .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: const Duration(seconds: 1), curve: Curves.easeInOut)
                       .fadeOut(begin: 0.4, duration: const Duration(seconds: 1)),
                    
                    GlowContainer(
                      glowColor: isActivated ? AppTheme.primaryRed : Colors.transparent,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActivated ? AppTheme.primaryRed : Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: isActivated ? Colors.white30 : Colors.white24,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          isActivated ? Icons.security : Icons.emergency,
                          color: Colors.white,
                          size: 54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Cards
            Positioned(
              bottom: 80,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  _buildFloatingInfoCard(
                    title: isActivated ? "Response Tracking" : "Safety Status",
                    content: isActivated 
                      ? "Response in 7 Seconds" 
                      : "Ready to Protect You",
                    icon: isActivated ? Icons.timer : Icons.shield,
                    color: isActivated ? AppTheme.primaryRed : AppTheme.primaryGreen,
                  ).animate().slideY(begin: 1.0, end: 0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
                  
                  if (isActivated) ...[
                    const SizedBox(height: 16),
                    _buildFloatingInfoCard(
                      title: "Helpers Nearby",
                      content: "${_safetyController.responderIds.length} Accepted",
                      icon: Icons.people,
                      color: AppTheme.primaryGreen,
                    ).animate().slideY(begin: 1.0, end: 0, delay: const Duration(milliseconds: 100), duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
                  ],
                ],
              ),
            ),

            // Slide to Activate/Cancel
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    _onToggleSignal();
                  }
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.glassBackground,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white12, width: 1),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                           isActivated ? "Slide to Cancel" : "Slide to Activate Emergency",
                          style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Positioned(
                        left: 4,
                        top: 4,
                        bottom: 4,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryRed,
                          ),
                          child: const Icon(Icons.keyboard_arrow_right, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFloatingInfoCard({required String title, required String content, required IconData icon, required Color color}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      opacity: 0.15,
      borderColor: color.withValues(alpha: 0.3),
      child: Row(
        children: [
          GlowContainer(
            glowColor: color,
            blurRadius: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w500)),
                Text(content, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
