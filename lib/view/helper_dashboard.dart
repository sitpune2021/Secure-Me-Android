import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/controller/safety_controller.dart';
import 'package:secure_me/model/signal_model.dart';
import 'package:secure_me/core/theme.dart';

class HelperDashboard extends StatefulWidget {
  const HelperDashboard({super.key});

  @override
  State<HelperDashboard> createState() => _HelperDashboardState();
}

class _HelperDashboardState extends State<HelperDashboard> {
  final SafetyController _safetyController = Get.put(SafetyController());
  bool _isHelping = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = _safetyController.status.value;
      final isAwaitingResponse = status == SignalStatus.sent && !_isHelping;

      return Scaffold(
        body: Stack(
          children: [
            // Map Background
            const GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 14),
              mapType: MapType.normal,
            ),
            
            // Helper Panel
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const Spacer(),
                    
                    if (isAwaitingResponse) 
                      _buildEmergencyAlertCard()
                    else if (_isHelping)
                      _buildOnTheWayCard()
                    else
                      _buildStatusCard("Ready To Help", "You are online and nearby.", AppTheme.primaryGreen),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: AppTheme.primaryGreen, radius: 4),
              const SizedBox(width: 8),
              Text('ACTIVE HELPER', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
            ],
          ),
          const Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildEmergencyAlertCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppTheme.primaryRed.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 48).animate(onPlay: (controller) => controller.repeat()).shake(),
          const SizedBox(height: 16),
          Text('EMERGENCY NEARBY', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('User Requesting Help (350m)', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _safetyController.cancelEmergency(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Decline', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _safetyController.acceptEmergency('helper1');
                    setState(() {
                      _isHelping = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('ACCEPT', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut, duration: const Duration(milliseconds: 800));
  }

  Widget _buildOnTheWayCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.glassBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: AppTheme.primaryGreen, child: Icon(Icons.directions_run_rounded, color: Colors.black)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ON THE WAY', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                    Text('ETA: 2 Minutes', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() => _isHelping = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.1),
              foregroundColor: AppTheme.primaryGreen,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Center(child: Text('Completed')),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOut);
  }

  Widget _buildStatusCard(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.glassBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          Text(content, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
