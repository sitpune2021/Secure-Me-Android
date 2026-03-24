import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/sos_controller/sos_controller.dart';

class SosActivatedView extends StatelessWidget {
  const SosActivatedView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final SosController sosController = Get.put(SosController());

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final theme = themeController.theme;

      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.08),
            child: Column(
              children: [
                const Spacer(), // pushes content to center
                // 🔔 SOS Image + Text
                Column(
                  children: [
                    Image.asset(
                      "assets/images/bell.png",
                      height: Get.height * 0.25,
                    ),
                    SizedBox(height: Get.height * 0.03),
                    if (sosController.isTriggering.value) ...[
                      const CircularProgressIndicator(color: Colors.red),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        "Triggering SOS...",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ] else ...[
                      Text(
                        sosController.triggerMessage.value.isNotEmpty
                            ? sosController.triggerMessage.value
                            : "SOS Activated!",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.05,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),

                SizedBox(height: Get.height * 0.04),
                
                // 👥 Instant Emergency Response Group
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Instant Response Group",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _helperTile("Police Officers", "Near you (Alerted)", Icons.shield, Colors.blue, "3 Online"),
                            _helperTile("Gym Bros", "Physical Strength Support", Icons.fitness_center, Colors.orange, "5 Nearby"),
                            _helperTile("Local Helpers", "Civilians nearby", Icons.groups, Colors.green, "12 Active"),
                            _helperTile("Family Members", "Emergency contacts notified", Icons.favorite, Colors.pink, "Notified"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Get.height * 0.02),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: Get.height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.back(); // Close screen or stop SOS
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                        fontSize: Get.width * 0.045,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _helperTile(String title, String subtitle, IconData icon, Color color, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha:0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha:0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
