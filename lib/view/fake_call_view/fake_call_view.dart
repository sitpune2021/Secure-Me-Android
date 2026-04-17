import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/fake_call_controller/fake_call_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FakeCallView extends StatelessWidget {
  FakeCallView({super.key});

  final FakeCallController controller = Get.put(FakeCallController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Fake Incoming Call",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Illustration/Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Remix.phone_find_line, size: 48, color: primaryColor),
                  ).animate().scale(delay: const Duration(milliseconds: 200)),
                ),
                const SizedBox(height: 32),


                // Section: Caller
                _buildSectionHeader(context, "CHOOSE CALLER IDENTITY"),
                const SizedBox(height: 16),
                _buildCallerList(context, controller),

                const SizedBox(height: 40),

                // Countdown Display
                Obx(() {
                  if (controller.countdownText.value.isEmpty) return const SizedBox.shrink();
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        controller.countdownText.value,
                        style: GoogleFonts.outfit(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2);
                }),

                const SizedBox(height: 16),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: Obx(() {
                    bool isCounting = controller.countdownText.value.isNotEmpty;
                    return ElevatedButton(
                      onPressed: isCounting ? null : () => controller.startCustomFakeCall(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCounting ? Colors.grey.withValues(alpha: 0.2) : primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        isCounting ? "Triggering..." : "Trigger Tactical Call",
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Theme.of(context).primaryColor,
      ),
    );
  }


  Widget _buildCallerList(BuildContext context, FakeCallController controller) {
    final callers = [
      {'name': 'Mom', 'icon': Remix.heart_fill, 'color': Colors.red},
      {'name': 'Police', 'icon': Remix.government_fill, 'color': Colors.blue},
      {'name': 'Boss', 'icon': Remix.briefcase_fill, 'color': Colors.amber},
      {'name': 'Best Friend', 'icon': Remix.star_fill, 'color': Colors.green},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: callers.map((caller) {
          final isLast = callers.indexOf(caller) == callers.length - 1;
          return Obx(() {
            bool isSelected = controller.selectedCaller.value == caller['name'];
            return Column(
              children: [
                ListTile(
                  onTap: () => controller.setCaller(caller['name'] as String),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (caller['color'] as Color).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(caller['icon'] as IconData, color: caller['color'] as Color, size: 24),
                  ),
                  title: Text(
                    caller['name'] as String,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  subtitle: Text(
                    "Incoming call from ${caller['name']}",
                    style: GoogleFonts.outfit(fontSize: 12, color: Theme.of(context).hintColor),
                  ),
                  trailing: Radio<String>(
                    value: caller['name'] as String,
                    groupValue: controller.selectedCaller.value,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val) => controller.setCaller(val!),
                  ),
                ),
                if (!isLast) Divider(indent: 70, endIndent: 20, color: Theme.of(context).dividerColor.withValues(alpha: 0.05), height: 1),
              ],
            );
          });
        }).toList(),
      ),
    );
  }
}
