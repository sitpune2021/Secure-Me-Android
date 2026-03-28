import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/police_controller/police_controller.dart';

class EmergencyAlertView extends StatelessWidget {
  final EmergencySignal signal;
  const EmergencyAlertView({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
    final policeController = Get.find<PoliceController>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // Animated Background Aura
          Center(
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withValues(alpha: 0.15),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.5, 1.5),
              duration: const Duration(seconds: 2),
            ).fade(begin: 0.3, end: 0.6),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Remix.alarm_warning_fill, color: Colors.red, size: 80)
                      .animate(onPlay: (c) => c.repeat())
                      .shake(duration: const Duration(milliseconds: 500))
                      .shimmer(duration: const Duration(seconds: 2)),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    "EMERGENCY REQUEST\nRECEIVED",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Victim Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow("VICTIM", signal.victimName, Remix.user_3_fill),
                        const Divider(height: 32, color: Colors.white10),
                        _buildDetailRow("DISTANCE", signal.distance, Remix.map_pin_fill),
                        const Divider(height: 32, color: Colors.white10),
                        _buildDetailRow("SEVERITY", signal.severity, Remix.error_warning_fill, isRed: true),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          label: "ACCEPT CASE",
                          icon: Remix.checkbox_circle_fill,
                          color: Colors.green,
                          onTap: () {
                            policeController.acceptCase(signal);
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionButton(
                          label: "DECLINE",
                          icon: Remix.close_circle_fill,
                          color: Colors.white24,
                          onTap: () => Get.back(),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  Text(
                    "This alert has been broadcasted to all units in Sector 4",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, {bool isRed = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isRed ? Colors.red : Colors.white70, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white38,
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isRed ? Colors.red : Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (color != Colors.white24)
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
