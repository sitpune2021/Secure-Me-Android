import 'dart:developer' as dev;
import 'package:get/get.dart';



class ChatMessage {
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isVoice;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isVoice = false,
  });
}

class EmergencyChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxString activeGroupId = "".obs;

  void createEmergencyGroup(String signalId, List<String> participants) {
    activeGroupId.value = "group_$signalId";
    messages.clear();
    
    // System message
    messages.add(ChatMessage(
      senderId: "system",
      senderName: "SECURE-ME",
      message: "Emergency Group Created. Responders: ${participants.join(', ')}",
      timestamp: DateTime.now(),
    ));

    // Police joining message
    Future.delayed(const Duration(seconds: 2), () {
      if (activeGroupId.isNotEmpty) {
        messages.add(ChatMessage(
          senderId: "police_01",
          senderName: "Officer Smith",
          message: "Responding to your location now. Keep your phone active.",
          timestamp: DateTime.now(),
        ));
      }
    });
  }

  void sendMessage(String text, {String senderId = "user_me", String senderName = "Me", bool isVoice = false}) {
    messages.add(ChatMessage(
      senderId: senderId,
      senderName: senderName,
      message: text,
      timestamp: DateTime.now(),
      isVoice: isVoice,
    ));
  }

  void recordVoiceMessage() {
    // Simulating recording and sending a voice message
    dev.log("🎙️ Recording emergency voice message...", name: "EmergencyChatController");
    Future.delayed(const Duration(seconds: 2), () {
      sendMessage("VOICE MESSAGE (0:02)", isVoice: true);
    });
  }

  void deleteGroup() {
    // Archiving logs for safety/legal (simulation)
    dev.log("Archiving chat logs for group ${activeGroupId.value}", name: 'EmergencyChatController');
    activeGroupId.value = "";
    messages.clear();
  }
}
