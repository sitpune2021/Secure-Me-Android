import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:secure_me/controller/fake_call_controller/fake_call_controller.dart';
import 'package:secure_me/theme/app_color.dart';

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

    // Initialize ringtone
    _ringtone = FlutterRingtonePlayer();
    _ringtone.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true,
      volume: 1,
    );

    // Vibrate every second
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
        bottom: false,
        child: Obx(() {
          if (controller.isCalling.value) {
            // ======== In-Call Screen ========
            int minutes = controller.callDuration.value ~/ 60;
            int seconds = controller.callDuration.value % 60;

            return Stack(
              children: [
                // Background
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
                // Dark overlay
                Container(
                  width: width,
                  height: height,
                  color: AppColors.pureBlack.withOpacity(0.6),
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
                          color: AppColors.pureWhite,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        "Connected",
                        style: GoogleFonts.poppins(
                          fontSize: height * 0.025,
                          color: AppColors.greenAccent,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                        style: GoogleFonts.poppins(
                          fontSize: height * 0.03,
                          color: AppColors.white70,
                        ),
                      ),
                      SizedBox(height: height * 0.05),
                      GestureDetector(
                        onTap: () => controller.stopCallTimer(),
                        child: CircleAvatar(
                          radius: height * 0.055,
                          backgroundColor: AppColors.red,
                          child: Icon(
                            Icons.call_end,
                            color: AppColors.pureWhite,
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
                // Background
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
                // Dark overlay
                Container(
                  width: width,
                  height: height,
                  color: AppColors.pureBlack.withOpacity(0.6),
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
                        color: AppColors.pureWhite,
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    Text(
                      "Incoming Call",
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.025,
                        color: AppColors.white70,
                      ),
                    ),
                    const Spacer(),
                    // Accept / Decline buttons
                    SafeArea(
                      bottom: true,
                      child: Padding(
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
                                    backgroundColor: AppColors.red,
                                    child: Icon(
                                      Icons.call_end,
                                      color: AppColors.pureWhite,
                                      size: height * 0.04,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.015),
                                  Text(
                                    "Decline",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.pureWhite,
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
                                    backgroundColor: AppColors.green,
                                    child: Icon(
                                      Icons.call,
                                      color: AppColors.pureWhite,
                                      size: height * 0.04,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.015),
                                  Text(
                                    "Accept",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.pureWhite,
                                      fontSize: height * 0.022,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
