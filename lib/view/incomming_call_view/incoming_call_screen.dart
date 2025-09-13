import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:secure_me/controller/fake_call_controller/fake_call_controller.dart';

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
    // Play ringtone continuously
    _ringtone.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true,
      volume: 1,
    );

    // Vibrate periodically
    _vibrationTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (await Vibration.hasVibrator() ?? false) {
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

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isCalling.value) {
            // ======== In-Call Screen ========
            int minutes = controller.callDuration.value ~/ 60;
            int seconds = controller.callDuration.value % 60;

            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://i.pravatar.cc/600?img=4"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.6)),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundImage: const NetworkImage(
                          "https://i.pravatar.cc/300?img=4",
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.callerName,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Connected",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.greenAccent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () => controller.stopCallTimer(),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.red,
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // ======== Incoming Call Screen ========
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://i.pravatar.cc/600?img=4"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.6)),
                Column(
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: const NetworkImage(
                        "https://i.pravatar.cc/300?img=4",
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.callerName,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Incoming Call",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Decline
                          GestureDetector(
                            onTap: () {
                              _ringtone.stop();
                              _vibrationTimer?.cancel();
                              Get.back();
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.red,
                                  child: const Icon(
                                    Icons.call_end,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Decline",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Accept
                          GestureDetector(
                            onTap: () {
                              _ringtone.stop();
                              _vibrationTimer?.cancel();
                              controller.startCallTimer();
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.green,
                                  child: const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Accept",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
