import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/controller/safety_controller.dart';
import 'package:secure_me/model/signal_model.dart';
import 'package:secure_me/core/theme.dart';
import 'package:secure_me/core/components.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final SafetyController _safetyController = Get.put(SafetyController());
  final TextEditingController _addressController = TextEditingController();
  bool _isHiddenIdentity = false;

  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('police_1'),
      position: const LatLng(37.7750, -122.4180),
      infoWindow: const InfoWindow(title: 'Police Officer', snippet: 'Ready to Help'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ),
    Marker(
      markerId: const MarkerId('gym_bro_1'),
      position: const LatLng(37.7740, -122.4210),
      infoWindow: const InfoWindow(title: 'Gym Bro', snippet: 'Physical Responder'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ),
  };

  final Set<Circle> _circles = {
    Circle(
      circleId: const CircleId('safe_area_1'),
      center: const LatLng(37.7760, -122.4150),
      radius: 200,
      fillColor: Colors.green.withValues(alpha: 0.15),
      strokeColor: Colors.green.withValues(alpha: 0.3),
      strokeWidth: 2,
    ),
    Circle(
      circleId: const CircleId('danger_area_1'),
      center: const LatLng(37.7730, -122.4230),
      radius: 150,
      fillColor: Colors.red.withValues(alpha: 0.15),
      strokeColor: Colors.red.withValues(alpha: 0.3),
      strokeWidth: 2,
    ),
  };

  void _onToggleSignal() {
    if (_safetyController.status.value == SignalStatus.pending) {
      _safetyController.activateEmergency(const LocationModel(
          latitude: 37.7749,
          longitude: -122.4194,
          address: 'San Francisco, CA'));
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
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                  target: LatLng(37.7749, -122.4194), zoom: 14.5),
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: _markers,
              circles: {
                ..._circles,
                if (isActivated)
                  Circle(
                    circleId: const CircleId('signal_radius'),
                    center: const LatLng(37.7749, -122.4194),
                    radius: _safetyController.stage.value == SignalStage.stage1
                        ? 50
                        : 500,
                    fillColor: AppTheme.primaryRed.withValues(alpha: 0.1),
                    strokeColor: AppTheme.primaryRed.withValues(alpha: 0.4),
                    strokeWidth: 2,
                  ),
              },
            ),

            // Dark Overlay for map
            Container(
              color: AppTheme.darkBackground.withValues(alpha: 0.4),
            ),

            // Floating Header & Address Section
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Secure Me',
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Text('7 Seconds Response',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppTheme.primaryRed,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2)),
                          ],
                        ),
                        Row(
                          children: [
                            _buildCircleButton(
                              icon: _isHiddenIdentity ? Icons.visibility_off : Icons.visibility,
                              onTap: () => setState(() => _isHiddenIdentity = !_isHiddenIdentity),
                              color: _isHiddenIdentity ? AppTheme.primaryRed : Colors.white24,
                              tooltip: 'Hidden Identity',
                            ),
                            const SizedBox(width: 12),
                            const CircleAvatar(
                              backgroundColor: AppTheme.glassBackground,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Address Section Box
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      borderRadius: 12,
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: AppTheme.primaryBlue, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _addressController,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Update current building/location...',
                                hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic, color: Colors.white70, size: 20),
                            onPressed: () {}, // Voice update
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
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
                    border: Border.all(
                        color: AppTheme.primaryRed.withValues(alpha: 0.3),
                        width: 2),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(2.0, 2.0),
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeOut)
                    .fadeOut(begin: 0.5, duration: const Duration(seconds: 2)),
              ),

            // Panic button center
            Center(
              child: GestureDetector(
                onTap: _onToggleSignal,
                onLongPress: _onToggleSignal,
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
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.3, 1.3),
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut)
                          .fadeOut(
                              begin: 0.4, duration: const Duration(seconds: 1)),

                    GlowContainer(
                      glowColor: isActivated
                          ? AppTheme.primaryRed
                          : Colors.transparent,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActivated
                              ? AppTheme.primaryRed
                              : Colors.white.withValues(alpha: 0.05),
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

            // Emergency Tracking Overlays
            if (isActivated) ...[
              // Signal Expansion Info
              Positioned(
                top: 180,
                left: 24,
                right: 24,
                child: GlassCard(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                   backgroundColor: Colors.black.withValues(alpha: 0.6),
                   child: Column(
                     children: [
                       Row(
                         children: [
                           const Icon(Icons.wifi_tethering, color: AppTheme.primaryRed, size: 18),
                           const SizedBox(width: 8),
                           Text(
                             _safetyController.stage.value == SignalStage.stage1 
                               ? 'Stage 1: 50m Radius (15-20 ppl)' 
                               : 'Stage 2: 500m Radius (Signal Expanded)',
                             style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                           ),
                         ],
                       ),
                       const SizedBox(height: 8),
                       LinearProgressIndicator(
                         value: _safetyController.responderIds.length / 20,
                         backgroundColor: Colors.white12,
                         color: AppTheme.primaryGreen,
                         borderRadius: BorderRadius.circular(4),
                       ),
                       const SizedBox(height: 4),
                       Text('${_safetyController.responderIds.length}/20 Handlers Accepted', 
                         style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10)),
                     ],
                   ),
                ).animate().fadeIn().slideY(begin: -0.2, end: 0),
              ),
            ],

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
                        ? "Help arriving in 7 Seconds"
                        : "Secure Me Active",
                    icon: isActivated ? Icons.timer : Icons.shield,
                    color: isActivated ? AppTheme.primaryRed : AppTheme.primaryGreen,
                  ).animate().slideY(
                      begin: 1.0,
                      end: 0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut),
                  if (isActivated) ...[
                    const SizedBox(height: 12),
                    Row(
                       children: [
                         Expanded(
                           child: _buildSmallDetailCard(
                             title: "Police",
                             count: "2 Nearby",
                             icon: Icons.local_police,
                             color: AppTheme.primaryBlue,
                           ),
                         ),
                         const SizedBox(width: 12),
                         Expanded(
                           child: _buildSmallDetailCard(
                             title: "Gym Bros",
                             count: "4 Ready",
                             icon: Icons.fitness_center,
                             color: AppTheme.primaryGreen,
                           ),
                         ),
                       ],
                    ).animate().slideY(begin: 1.0, end: 0, delay: 100.ms),
                  ],
                ],
              ),
            ),

            // Slide Interaction Row
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: isActivated 
                ? FuturisticButton(
                    text: 'I AM SAFE NOW - CANCEL',
                    onPressed: _onToggleSignal,
                    color: AppTheme.primaryRed,
                    icon: Icons.check_circle_outline,
                  )
                : _buildSlideToActivate(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap, required Color color, required String tooltip}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSmallDetailCard({required String title, required String count, required IconData icon, required Color color}) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 6),
          Text(title, style: GoogleFonts.poppins(color: Colors.white60, fontSize: 10)),
          Text(count, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSlideToActivate() {
    return Container(
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
              "Slide to Activate Emergency",
              style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Positioned(
            left: 4,
            top: 4,
            bottom: 4,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 500 || details.velocity.pixelsPerSecond.dx > 500) {
                   _onToggleSignal();
                }
              },
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
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingInfoCard(
      {required String title,
      required String content,
      required IconData icon,
      required Color color}) {
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
                border:
                    Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
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
                Text(title,
                    style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                Text(content,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
    }
}
