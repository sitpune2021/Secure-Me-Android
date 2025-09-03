import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PushNotificationView extends StatelessWidget {
  const PushNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // light theme
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            color: Colors.black,
            size: Get.height * 0.03,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Push Notification",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: Platform.isAndroid ? false : true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey.shade300, thickness: 1),
            SizedBox(height: Get.height * 0.02),

            // SOS Trigger Alerts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SOS trigger alerts",
                  style: GoogleFonts.poppins(
                    fontSize: Get.height * 0.02,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (val) {},
                  activeColor: Colors.blue,
                ),
              ],
            ),

            SizedBox(height: Get.height * 0.025),

            // Trusted Contact Response
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trusted Contact Response",
                  style: GoogleFonts.poppins(
                    fontSize: Get.height * 0.02,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (val) {},
                  activeColor: Colors.blue,
                ),
              ],
            ),

            SizedBox(height: Get.height * 0.025),

            // Danger Zone Alert
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Danger Zone Alert",
                  style: GoogleFonts.poppins(
                    fontSize: Get.height * 0.02,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (val) {},
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
