import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/core/theme.dart';

class EmergencyChatWidget extends StatelessWidget {
  const EmergencyChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _buildHandle(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text('EMERGENCY GROUP', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryRed)),
                const Spacer(),
                const CircleAvatar(radius: 4, backgroundColor: Colors.red),
                const SizedBox(width: 4),
                Text('4 ACTIVE', style: GoogleFonts.poppins(fontSize: 10, color: Colors.white54)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildMessage('POLICE DISPATCH', 'Unit 7 is 2 min away.', AppTheme.primaryBlue, true),
                _buildMessage('HELPER (Alex)', 'I am at the corner, looking for you!', AppTheme.primaryGreen, false),
                _buildMessage('FAMILY (Mom)', 'Stay on the line, we are watching!', Colors.white, false),
              ],
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildMessage(String sender, String text, Color color, bool isBlue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(sender, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(width: 6),
              Text('12:44 PM', style: GoogleFonts.poppins(fontSize: 8, color: Colors.white24)),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isBlue ? AppTheme.primaryBlue.withValues(alpha: 0.1) : AppTheme.glassBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isBlue ? AppTheme.primaryBlue.withValues(alpha: 0.2) : Colors.white10),
            ),
            child: Text(text, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppTheme.glassBackground,
      child: Row(
        children: [
          const Icon(Icons.mic, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Share update...',
                  hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 12),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
