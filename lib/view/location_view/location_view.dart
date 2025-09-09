import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationView extends StatelessWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White theme background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Location",
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

            // Auto Call Location on SOS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Auto Call Location On SOS",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
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

            SizedBox(height: Get.height * 0.03),

            // Share Live Location
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: Text(
                "Share Live Location",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              ),
              onTap: () {
                // Handle navigation
              },
            ),

            SizedBox(height: Get.height * 0.015),

            // View Nearby Friends
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.people_alt, color: Colors.blue),
              title: Text(
                "View Nearby Friends",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black,
              ),
              onTap: () {
                // Handle navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}
