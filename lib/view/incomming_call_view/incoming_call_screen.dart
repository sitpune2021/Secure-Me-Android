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
    _ringtone.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true,
      volume: 1,
    );

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

    double height = Get.height;
    double width = Get.width;

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
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://i.pravatar.cc/600?img=4"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: height,
                  color: Colors.black.withOpacity(0.6),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: height * 0.12,
                        backgroundImage: const NetworkImage(
                          "https://i.pravatar.cc/300?img=4",
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Text(
                        widget.callerName,
                        style: GoogleFonts.poppins(
                          fontSize: height * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        "Connected",
                        style: GoogleFonts.poppins(
                          fontSize: height * 0.025,
                          color: Colors.greenAccent,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                        style: GoogleFonts.poppins(
                          fontSize: height * 0.03,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      GestureDetector(
                        onTap: () => controller.stopCallTimer(),
                        child: CircleAvatar(
                          radius: height * 0.055,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: height * 0.04,
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
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://i.pravatar.cc/600?img=4"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: height,
                  color: Colors.black.withOpacity(0.6),
                ),
                Column(
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: height * 0.12,
                      backgroundImage: const NetworkImage(
                        "https://i.pravatar.cc/300?img=4",
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      widget.callerName,
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Text(
                      "Incoming Call",
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.025,
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.1,
                        vertical: height * 0.03,
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
                                  radius: height * 0.055,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.call_end,
                                    color: Colors.white,
                                    size: height * 0.04,
                                  ),
                                ),
                                SizedBox(height: height * 0.015),
                                Text(
                                  "Decline",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: height * 0.022,
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
                                  radius: height * 0.055,
                                  backgroundColor: Colors.green,
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: height * 0.04,
                                  ),
                                ),
                                SizedBox(height: height * 0.015),
                                Text(
                                  "Accept",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: height * 0.022,
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
