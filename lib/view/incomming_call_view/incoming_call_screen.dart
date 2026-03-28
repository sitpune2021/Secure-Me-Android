import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:secure_me/controller/fake_call_controller/fake_call_controller.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callerName;
  final FakeCallController controller;

  const IncomingCallScreen({
    super.key,
    required this.callerName,
    required this.controller,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  late final FlutterRingtonePlayer _ringtone;
  Timer? _vibrationTimer;

  @override
  void initState() {
    super.initState();
    _ringtone = FlutterRingtonePlayer();
    _ringtone.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true,
      volume: 1,
    );

    _vibrationTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 500);
      }
    });
  }

  @override
  void dispose() {
    _ringtone.stop();
    _vibrationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final isCalling = controller.isCalling.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            // Blurred Background
            _buildBlurredBackground(primaryColor),
            
            // Call Content
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  _buildProfileAvatar(primaryColor),
                  const SizedBox(height: 24),
                  _buildCallInfo(isCalling),
                  const Spacer(),
                  if (!isCalling) _buildIncomingControls() else _buildActiveControls(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBlurredBackground(Color primary) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primary.withValues(alpha: 0.2),
            Colors.black.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildProfileAvatar(Color primary) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: [
          BoxShadow(color: primary.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 10),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white12,
        child: Icon(Remix.user_3_line, size: 70, color: Colors.white.withValues(alpha: 0.8)),
      ),
    ).animate().scale(duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack);
  }

  Widget _buildCallInfo(bool isCalling) {
    return Column(
      children: [
        Text(
          widget.callerName,
          style: GoogleFonts.outfit(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        if (isCalling)
          Obx(() {
            int duration = widget.controller.callDuration.value;
            int mins = duration ~/ 60;
            int secs = duration % 60;
            return Text(
              "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}",
              style: GoogleFonts.outfit(
                fontSize: 18,
                color: Colors.greenAccent,
                fontWeight: FontWeight.w600,
              ),
            );
          })
        else
          Text(
            "INCOMING CALL...",
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.white60,
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
            ),
          ).animate(onPlay: (c) => c.repeat()).fadeIn(duration: const Duration(seconds: 1)).fadeOut(duration: const Duration(seconds: 1)),
      ],
    );
  }

  Widget _buildIncomingControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(
            icon: Remix.phone_line,
            label: "Decline",
            color: Colors.redAccent,
            onTap: () => Get.back(),
            isRotated: true,
          ),
          _buildControlButton(
            icon: Remix.phone_line,
            label: "Accept",
            color: Colors.greenAccent,
            onTap: () {
              _ringtone.stop();
              _vibrationTimer?.cancel();
              widget.controller.startCallTimer();
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideY(begin: 0.2);
  }

  Widget _buildActiveControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCallFeature(Remix.mic_off_line, "Mute"),
            _buildCallFeature(Remix.chat_1_line, "Record"),
            _buildCallFeature(Remix.volume_up_line, "Speaker"),
          ],
        ),
        const SizedBox(height: 60),
        _buildControlButton(
          icon: Remix.phone_line,
          label: "End Call",
          color: Colors.redAccent,
          onTap: () => widget.controller.stopCallTimer(),
          isRotated: true,
          large: true,
        ),
      ],
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isRotated = false,
    bool large = false,
  }) {
    double size = large ? 84 : 72;
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Transform.rotate(
              angle: isRotated ? 2.35 : 0, // Approx 135 degrees for decline icon
              child: Icon(icon, color: Colors.white, size: size * 0.45),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCallFeature(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}
