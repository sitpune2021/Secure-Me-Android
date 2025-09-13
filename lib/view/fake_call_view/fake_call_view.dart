import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/fake_call_controller/fake_call_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class FakeCallView extends StatelessWidget {
  FakeCallView({super.key});

  final FakeCallController controller = Get.put(FakeCallController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0B0213) : Colors.white,
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF0B0213) : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Fake Call",
            style: GoogleFonts.poppins(
              fontSize: Get.height * 0.022,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
            vertical: Get.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
                thickness: 1,
              ),
              SizedBox(height: Get.height * 0.02),

              /// Call Delay
              Text(
                "Set Call Delay",
                style: GoogleFonts.poppins(
                  fontSize: Get.height * 0.02,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: Get.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDelayButton("5 Sec", isDark),
                  _buildDelayButton("30 Sec", isDark),
                  _buildDelayButton("1 Min", isDark),
                ],
              ),

              SizedBox(height: Get.height * 0.03),

              /// Caller Selection
              Text(
                "Choose Caller",
                style: GoogleFonts.poppins(
                  fontSize: Get.height * 0.02,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: Get.height * 0.015),
              _buildCallerItem("assets/images/mom.png", "Mom", isDark),
              _buildCallerItem("assets/images/police.png", "Police", isDark),
              _buildCallerItem("assets/images/boss.png", "Boss", isDark),

              const Spacer(),

              /// Countdown Text
              Obx(() {
                if (controller.countdownText.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: Get.height * 0.015),
                  child: Center(
                    child: Text(
                      controller.countdownText.value,
                      style: GoogleFonts.poppins(
                        fontSize: Get.height * 0.018,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                );
              }),

              /// Start Fake Call Button
              Padding(
                padding: EdgeInsets.only(
                  bottom: Platform.isAndroid ? 0 : Get.height * .015,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: Get.height * 0.07,
                  child: Obx(() {
                    bool isDisabled = controller.countdownText.value.isNotEmpty;
                    return ElevatedButton(
                      onPressed: isDisabled
                          ? null
                          : () async {
                              controller.startCustomFakeCall();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: isDisabled
                              ? null
                              : (isDark
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF9C27B0),
                                          Color(0xFFE040FB),
                                        ],
                                      )
                                    : null),
                          color: isDisabled
                              ? Colors.grey
                              : (!isDark ? Colors.purple : null),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Start Fake Call",
                            style: GoogleFonts.poppins(
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDelayButton(String text, bool isDark) {
    final FakeCallController controller = Get.find();
    return GestureDetector(
      onTap: () => controller.setDelay(text),
      child: Obx(() {
        bool isSelected = controller.selectedDelay.value == text;
        return Container(
          width: Get.width * 0.25,
          height: Get.height * 0.05,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white10 : Colors.purple.shade50)
                : (isDark ? Colors.white12 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? Colors.purpleAccent
                  : (isDark ? Colors.white24 : Colors.grey.shade400),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: isSelected
                  ? Colors.purpleAccent
                  : (isDark ? Colors.white70 : Colors.black),
              fontWeight: FontWeight.w600,
              fontSize: Get.height * 0.018,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCallerItem(String imgPath, String name, bool isDark) {
    final FakeCallController controller = Get.find();
    return GestureDetector(
      onTap: () => controller.setCaller(name),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
        child: Row(
          children: [
            CircleAvatar(
              radius: Get.height * 0.035,
              backgroundImage: AssetImage(imgPath),
            ),
            SizedBox(width: Get.width * 0.04),
            Expanded(
              child: Obx(() {
                bool isSelected = controller.selectedCaller.value == name;
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        "$name\nIncoming Call From $name",
                        style: GoogleFonts.poppins(
                          fontSize: Get.height * 0.018,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: isSelected
                              ? Colors.purpleAccent
                              : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: Colors.purpleAccent,
                        size: Get.height * 0.03,
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
