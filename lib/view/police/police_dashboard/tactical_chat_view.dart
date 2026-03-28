import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remixicon/remixicon.dart';

class TacticalChatView extends StatefulWidget {
  final String groupName;
  const TacticalChatView({super.key, required this.groupName});

  @override
  State<TacticalChatView> createState() => _TacticalChatViewState();
}

class _TacticalChatViewState extends State<TacticalChatView> {
  final _messageController = TextEditingController();
  final _messages = <ChatMessage>[
    ChatMessage(sender: "SYSTEM", content: "Tactical Response Unit Dispatched", isSystem: true, time: "12:01"),
    ChatMessage(sender: "Rahul K.", content: "I'm 2m away, reaching soon", isSystem: false, time: "12:02"),
    ChatMessage(sender: "OFFICER", content: "Maintain perimeter, I'm at the location", isMe: true, isSystem: false, time: "12:03"),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.groupName.toUpperCase(),
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            Text(
              "4 Active Responders | Tactical Channel",
              style: GoogleFonts.outfit(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Remix.phone_fill, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(primaryColor),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.content,
            style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.blue, letterSpacing: 1),
          ),
        ),
      );
    }

    final isMe = message.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Text(
                  message.sender,
                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 20),
                ),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
              ),
              child: Text(
                message.content,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 12, left: 12),
              child: Text(
                message.time,
                style: GoogleFonts.outfit(fontSize: 9, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Tactical command update...",
                    hintStyle: GoogleFonts.outfit(fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                if (_messageController.text.isNotEmpty) {
                  setState(() {
                    _messages.add(ChatMessage(
                      sender: "OFFICER",
                      content: _messageController.text,
                      isMe: true,
                      time: "12:04",
                    ));
                    _messageController.clear();
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                child: const Icon(Remix.send_plane_2_fill, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String content;
  final String time;
  final bool isMe;
  final bool isSystem;

  ChatMessage({
    required this.sender,
    required this.content,
    required this.time,
    this.isMe = false,
    this.isSystem = false,
  });
}
