import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/controller/sos_controller/sos_controller.dart';
import 'package:secure_me/model/emergency_message.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class EmergencyChatView extends StatelessWidget {
  final String groupId;
  const EmergencyChatView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final SosController controller = Get.find<SosController>();
    final primaryColor = Colors.orange.shade800;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context, primaryColor, controller),
      body: Column(
        children: [
          _buildInfoBanner(),
          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.chatScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                return _buildMessageBubble(message, controller);
              },
            )),
          ),
          _buildChatInput(controller, primaryColor),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Color color, SosController controller) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Remix.arrow_left_s_line, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "INCIDENT CHANNEL: $groupId",
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
          ),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ).animate(onPlay: (c) => c.repeat()).fadeOut(),
              const SizedBox(width: 6),
              Text(
                "ENCRYPTED • AUTO-DELETING SESSION",
                style: GoogleFonts.outfit(fontSize: 9, color: Colors.white38, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Remix.shield_flash_fill, color: Colors.orange),
          onPressed: () {
            // Quick status update toggle
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(color: Colors.white10, height: 1),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.blue.withValues(alpha: 0.1),
      child: Row(
        children: [
          const Icon(Remix.information_fill, color: Colors.blue, size: 14),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Situational context is shared with verified responders only.",
              style: GoogleFonts.outfit(fontSize: 10, color: Colors.blue.shade100, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(EmergencyMessage message, SosController controller) {
    final bool isSystem = message.senderId == "system";
    final bool isMe = message.senderId != "system" && !message.senderName.startsWith("Officer") && message.senderId != "responder_1";

    if (isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(
            message.content,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38, fontWeight: FontWeight.w600),
          ),
        ),
      ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe) _buildAvatar(message),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        message.senderName,
                        style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, color: isMe ? Colors.orange : Colors.blue, letterSpacing: 0.5),
                      ),
                      if (message.senderRole != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          "• ${message.senderRole?.toUpperCase()}",
                          style: GoogleFonts.outfit(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.orange.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMe ? 20 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 20),
                      ),
                      border: Border.all(color: isMe ? Colors.orange.withValues(alpha: 0.3) : Colors.white10),
                    ),
                    child: _buildMessageContent(message),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: GoogleFonts.outfit(fontSize: 9, color: Colors.white24),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              if (isMe) _buildAvatar(message),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: isMe ? 0.1 : -0.1);
  }

  Widget _buildAvatar(EmergencyMessage message) {
    final bool isResponder = message.senderRole == 'police';
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isResponder ? Colors.blue.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: isResponder ? Colors.blue : Colors.orange, width: 1.5),
      ),
      child: Icon(
        isResponder ? Remix.shield_user_fill : Remix.user_3_fill,
        size: 16,
        color: isResponder ? Colors.blue : Colors.orange,
      ),
    );
  }

  Widget _buildMessageContent(EmergencyMessage message) {
    if (message.type == MessageType.location) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Remix.map_pin_2_fill, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(
            "LIVE LOCATION SHARED",
            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.green, letterSpacing: 0.5),
          ),
        ],
      );
    }
    
    if (message.type == MessageType.voice) {
       return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Remix.mic_fill, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          Text(
            "VOICE MEMO ATTACHED",
            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.orange, letterSpacing: 0.5),
          ),
        ],
      );
    }

    return Text(
      message.content,
      style: GoogleFonts.outfit(fontSize: 14, color: Colors.white, height: 1.4),
    );
  }

  Widget _buildChatInput(SosController controller, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => controller.startVoiceRecording(),
              icon: const Icon(Remix.mic_2_line, color: Colors.white54),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: TextField(
                  controller: controller.chatInputController,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "TYPE STATUS UPDATE...",
                    hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 13, fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => controller.sendChatMessage(controller.chatInputController.text),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(Remix.send_plane_2_fill, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
