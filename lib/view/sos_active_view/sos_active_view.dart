import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/sos_controller/sos_controller.dart';
import 'package:secure_me/view/emergency_chat_view.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:secure_me/view/common/app_snackbar.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

class SosActivatedView extends StatelessWidget {
  const SosActivatedView({super.key});

  @override
  Widget build(BuildContext context) {
    final SosController sosController = Get.put(SosController());
    final primaryColor = Colors.red.shade700;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background Pulse
          _buildAnimatedBackground(primaryColor),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 48), // Adjust for padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Header Status
                        _buildHeaderStatus(primaryColor, sosController),
                        
                        // Main SOS Indicator (Centered vertically if space allows)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: _buildMainIndicator(primaryColor, sosController),
                        ),

                        // Response Section + Action Buttons
                        Column(
                          children: [
                            _buildResponseSection(context, primaryColor, sosController),
                            const SizedBox(height: 32),
                            _buildActionButtons(context, primaryColor, sosController),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.35), Colors.black],
          center: Alignment.center,
          radius: 1.2,
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
      duration: const Duration(seconds: 3),
      color: color.withValues(alpha: 0.1),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color color = Colors.orange;
    if (status == 'ACCEPTED') color = Colors.green;
    if (status == 'RESOLVED') color = Colors.blue;
    if (status == 'PENDING') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ).animate(onPlay: (controller) => controller.repeat())
           .scale(duration: const Duration(seconds: 1), begin: const Offset(1, 1), end: const Offset(1.5, 1.5))
           .fadeOut(),
          const SizedBox(width: 8),
          Text(
            status,
            style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatus(Color color, SosController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ).animate(onPlay: (c) => c.repeat()).fadeOut(duration: const Duration(milliseconds: 500)),
          const SizedBox(width: 8),
          Obx(() => Text(
                controller.sosStatus.value.toUpperCase().replaceAll('_', ' '),
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                  letterSpacing: 1.5,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMainIndicator(Color color, SosController controller) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Waves
            ...List.generate(3, (i) => 
               Container(
                width: 140 + (i * 40),
                height: 140 + (i * 40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.2 - (i * 0.05)), width: 2),
                ),
              ).animate(onPlay: (c) => c.repeat()).scale(
                begin: const Offset(1, 1),
                end: const Offset(1.5, 1.5),
                duration: Duration(milliseconds: 1500 + (i * 500)),
              ).fadeOut()
            ),
            
            // Core Button
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10),
                ],
              ),
              child: const Icon(Remix.error_warning_fill, color: Colors.white, size: 60),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: const Duration(milliseconds: 600),
            ),
          ],
        ),
        const SizedBox(height: 48),
        Obx(() => Text(
          controller.isTriggering.value ? "ACTIVATING..." : "SOS ACTIVATED",
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
          ),
        )),
        const SizedBox(height: 8),
        Obx(() => Text(
          controller.isTriggering.value 
            ? "Establishing secure connection..." 
            : controller.triggerMessage.value.isNotEmpty 
                ? controller.triggerMessage.value 
                : "Your live location and responders are being\nactively synced with your safety network.",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.white60,
            height: 1.5,
          ),
        )),
        
        const SizedBox(height: 24),
        
        // Voice Recording Indicator
        Obx(() => controller.isRecording.value 
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Remix.mic_fill, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "RECORDING AUDIO: ${controller.recordingDuration.value}s",
                    style: GoogleFonts.outfit(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: const Duration(seconds: 1))
          : const SizedBox.shrink()),
      ],
    ).animate().fadeIn(duration: const Duration(milliseconds: 600)).slideY(begin: 0.1);
  }

  Widget _buildResponseSection(BuildContext context, Color primary, SosController controller) {
    return Column(
      children: [
        // ── Instant Emergency Group Banner ──────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Remix.chat_history_fill, color: Colors.green, size: 14),
              const SizedBox(width: 8),
              Text(
                "INSTANT EMERGENCY RESPONSE GROUP ACTIVE",
                style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.green, letterSpacing: 0.5),
              ),
            ],
          ),
        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: const Duration(seconds: 3)),

        // ── Response Units List ──────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DYNAMIC CHANNELS",
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  Obx(() => _buildStatusIndicator(controller.sosStatus.value.toUpperCase())),
                ],
              ),
              const SizedBox(height: 24),

              // SOS Privacy Control
              _buildPrivacyToggle(controller),
              const SizedBox(height: 24),

              Obx(() => Column(
                children: controller.responseGroups.map((group) {
                  return _buildResponseTile(
                    group["category"],
                    (group["members"] as List).join(", "),
                    _getIconForCategory(group["icon"]),
                    _getColorForCategory(group["category"]),
                  );
                }).toList(),
              )),
              
              const SizedBox(height: 12),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  const Icon(Remix.information_line, color: Colors.white30, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "This temporary group will auto-delete once resolved. Logs only for police/family.",
                      style: GoogleFonts.outfit(fontSize: 10, color: Colors.white30, height: 1.4, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForCategory(String iconType) {
    switch (iconType) {
      case "strength": return Remix.body_scan_fill;
      case "police": return Remix.shield_user_fill;
      case "community": return Remix.group_fill;
      case "family": return Remix.heart_fill;
      default: return Remix.user_3_line;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case "Gym Bros": return Colors.orange;
      case "Police Officers": return Colors.blue;
      case "Local Helpers": return Colors.green;
      case "Family Members": return Colors.pink;
      default: return Colors.white;
    }
  }

  Widget _buildResponseTile(String title, String status, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.5)),
                Text(status, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Remix.check_double_line, color: Colors.green, size: 16),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Color color, SosController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(
                "CALL POLICE", 
                Remix.phone_fill, 
                Colors.blue.shade800,
                onTap: () => controller.makeCall("100"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSecondaryButton(
                "GROUP CHAT", 
                Remix.chat_voice_fill, 
                Colors.orange.shade800,
                onTap: () {
                  // Navigate to emergency group chat
                  Get.to(() => const EmergencyChatView(groupId: "INCIDENT-SOS-991"));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(
                "ESCAPE ROUTE", 
                Remix.map_pin_user_fill, 
                Colors.green.shade800,
                onTap: () {
                  AppSnackbar.show(title: "Finding Safety", message: "Calculating safest route to nearest Police Station.");
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSecondaryButton(
                "CANCEL EMERGENCY", 
                Remix.close_line, 
                Colors.white.withValues(alpha: 0.1), 
                isDestructive: true,
                onTap: () {
                  AppSnackbar.show(
                    title: "Security Lock", 
                    message: "Tap and HOLD to deactivate emergency signal.",
                    isWarning: true,
                  );
                },
                onLongPress: () {
                  _showCancelPinDialog(context, controller);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildVoiceActionTile(controller),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideY(begin: 0.1);
  }

  Widget _buildVoiceActionTile(SosController controller) {
    return Obx(() => GestureDetector(
      onTap: () {
        if (controller.isRecording.value) {
          controller.stopVoiceRecording();
        } else {
          controller.startVoiceRecording();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: controller.isRecording.value ? Colors.red.shade900 : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: controller.isRecording.value ? Colors.red.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05),
          ),
          boxShadow: controller.isRecording.value ? [
            BoxShadow(color: Colors.red.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2)
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.isRecording.value ? Remix.stop_circle_fill : Remix.mic_2_fill,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isRecording.value ? "TAP TO STOP & SYNC" : "RECORD SITUATION LOG",
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                  ),
                  Text(
                    controller.isRecording.value ? "Active recording: ${controller.recordingDuration.value}s" : "Send tactical audio to responders.",
                    style: GoogleFonts.outfit(fontSize: 11, color: Colors.white60),
                  ),
                ],
              ),
            ),
            if (controller.isRecording.value)
              const Icon(Remix.pulse_fill, color: Colors.white, size: 20)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(end: const Offset(1.3, 1.3)),
          ],
        ),
      ),
    ));
  }

  void _showCancelPinDialog(BuildContext context, SosController controller) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.outfit(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
    );

    Get.dialog(
      Dialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Remix.shield_keyhole_fill, color: Colors.blue, size: 48),
              const SizedBox(height: 16),
              Text(
                "VERIFY IDENTITY",
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter your 4-digit Emergency PIN to\ncancel the SOS signal.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 32),
              Pinput(
                length: 4,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.blue),
                  ),
                ),
                onCompleted: (pin) async {
                  bool success = await controller.verifyCancelPin(pin);
                  if (success) {
                    // Controller handles closing overlays and returning to home.
                    // No additional Get.back() needed here to avoid over-popping.
                    AppSnackbar.show(
                      title: "Identity Verified", 
                      message: "Emergency broadcast has been decommissioned.", 
                      isSuccess: true
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => Get.back(),
                child: Text("CANCEL VERIFICATION", style: GoogleFonts.outfit(color: Colors.white30, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildPrivacyToggle(SosController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Obx(() => SwitchListTile(
        value: controller.isAnonymous.value,
        onChanged: (val) => controller.isAnonymous.value = val,
        title: Text(
          "ANONYMOUS MODE", 
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)
        ),
        subtitle: Text(
          "Hide your identity from community helpers. Recommended for discreet rescue.", 
          style: GoogleFonts.outfit(fontSize: 11, color: Colors.white60)
        ),
        activeThumbColor: Colors.blue,
        contentPadding: EdgeInsets.zero,
      )),
    );
  }

  Future<void> _launchMaps() async {
    final query = "Police Station near me";
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      AppSnackbar.show(title: "Navigation Error", message: "Could not open map application.", isError: true);
    }
  }

  Widget _buildSecondaryButton(String label, IconData icon, Color color,
      {bool isDestructive = false, VoidCallback? onTap, VoidCallback? onLongPress}) {
    return GestureDetector(
      onTap: onTap ?? (label == "ESCAPE ROUTE" ? _launchMaps : null),
      onLongPress: onLongPress,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isDestructive ? Colors.white.withValues(alpha: 0.05) : color,
          borderRadius: BorderRadius.circular(18),
          border: isDestructive ? Border.all(color: Colors.white10) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
