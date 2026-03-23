import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/controller/safety_controller.dart';
import 'package:secure_me/model/signal_model.dart';
import 'package:secure_me/core/theme.dart';
import 'package:secure_me/core/components.dart';

class PoliceDashboard extends StatelessWidget {
  PoliceDashboard({super.key});

  final SafetyController _safetyController = Get.put(SafetyController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activeAlerts = _safetyController.status.value == SignalStatus.sent ? 1 : 0;
      
      return Scaffold(
        backgroundColor: AppTheme.darkBackground,
        appBar: AppBar(
          title: Text('POLICE COMMAND', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.history, color: Colors.white70)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white70)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPoliceHeader(),
              const SizedBox(height: 32),
              Text('ACTIVE EMERGENCIES', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white60)),
              const SizedBox(height: 16),
              
              if (activeAlerts > 0) 
                _buildEmergencyItem(context)
              else
                _buildEmptyState(),
              
              const Spacer(),
              _buildSystemMetrics(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPoliceHeader() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderColor: AppTheme.primaryBlue.withValues(alpha: 0.3),
      child: Row(
        children: [
          GlowContainer(
            glowColor: AppTheme.primaryBlue,
            blurRadius: 15,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.security, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('San Francisco Precinct', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('System Online | 12 Officers Patroling', style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.primaryBlue.withValues(alpha: 0.8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyItem(BuildContext context) {
    return GlowContainer(
      glowColor: AppTheme.primaryRed,
      blurRadius: 20,
      spreadRadius: -10,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderColor: AppTheme.primaryRed.withValues(alpha: 0.4),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundColor: AppTheme.primaryRed, radius: 4),
                const SizedBox(width: 8),
                Text('PRIORITY ALERT', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryRed)),
                const Spacer(),
                Text('3m ago', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white38)),
              ],
            ),
            const SizedBox(height: 12),
             Row(
              children: [
                const CircleAvatar(backgroundColor: Colors.white10, radius: 24, child: Icon(Icons.person, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unknown Victim', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('${_safetyController.victimLocation.value?.address ?? "Locating..."}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Responders: ${_safetyController.responderIds.length}', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.primaryBlue)),
                 Text('Stage: ${_safetyController.stage.value == SignalStage.stage1 ? "1" : "2"}', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.primaryRed)),
              ],
            ),
            const SizedBox(height: 16),
            FuturisticButton(
              text: 'Dispatch & Track',
              color: AppTheme.primaryBlue,
              onPressed: () {},
              icon: Icons.local_police,
            ),
          ],
        ),
      ),
    ).animate().slideX(begin: -1, end: 0, curve: Curves.easeOut);
  }

  Widget _buildEmptyState() {
     return Center(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           const SizedBox(height: 48),
           const Icon(Icons.shield_outlined, color: Colors.white12, size: 64),
           const SizedBox(height: 16),
           Text('All Clear', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white38, fontWeight: FontWeight.w500)),
           Text('No active emergencies reported.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white24)),
         ],
       ),
     );
  }

  Widget _buildSystemMetrics() {
     return Row(
       children: [
          _buildMetric('PATROLING', '12', AppTheme.primaryBlue),
          const SizedBox(width: 16),
          _buildMetric('HELPERS', '86', AppTheme.primaryGreen),
       ],
     );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.glassBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
