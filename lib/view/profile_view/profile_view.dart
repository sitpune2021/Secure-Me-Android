import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Get.back();
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "Profile",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: Platform.isAndroid ? false : true,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  // const CircleAvatar(
                  //   radius: 35,
                  //   backgroundImage: AssetImage(
                  //     "assets/images/user.jpg",
                  //   ), // replace with NetworkImage if needed
                  // ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rupa Jenny",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "+91 9670302800",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),

              // Menu items
              _buildMenuItem("Edit Profile", () {
                Get.toNamed(AppRoutes.editProfile);
              }),
              _buildMenuItem("Location", () {
                Get.toNamed(AppRoutes.location);
              }),
              _buildMenuItem("Friends", () {
                Get.toNamed(AppRoutes.friends);
              }),
              _buildMenuItem("Push Notifications", () {
                Get.toNamed(AppRoutes.pushnotification);
              }),
              _buildMenuItem("Settings", () {
                Get.toNamed(AppRoutes.setting);
              }),
              _buildMenuItem("Help", () {
                // Get.toNamed(AppRoutes.help);
              }),

              // Dark Mode switch
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Dark Mode",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                ),
                trailing: Obx(
                  () => Switch(
                    value: themeController.isDarkMode.value,
                    activeColor: theme.primaryColor,
                    onChanged: (val) {
                      themeController.toggleTheme(val);
                    },
                  ),
                ),
              ),

              const Divider(),

              // More
              const SizedBox(height: 10),
              Text(
                "More",
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),

              _buildMenuItem("About Us", () {
                // Get.toNamed(AppRoutes.aboutUs);
              }),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: Colors.black54),
                title: Text(
                  "Log Out",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                ),
                onTap: () {
                  Get.offAllNamed(AppRoutes.loginView);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
      onTap: onTap,
    );
  }
}
