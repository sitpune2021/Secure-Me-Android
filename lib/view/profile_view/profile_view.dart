import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:secure_me/routes/app_pages.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Karina Mandhare",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),

            // Menu Items
            _buildMenuItem(Icons.settings, "Setting", () {
              // Get.toNamed(AppRoutes.setting);
            }),
            _buildMenuItem(Icons.group_outlined, "Friends", () {
              // Get.toNamed(AppRoutes.friends);
            }),
            _buildMenuItem(RemixIcons.question_line, "Help", () {
              // Get.toNamed(AppRoutes.help);
            }),
            _buildMenuItem(RemixIcons.information_2_line, "App Info", () {
              // Get.toNamed(AppRoutes.appInfo);
            }),
            _buildMenuItem(Icons.star_border, "Feedback", () {
              // Get.toNamed(AppRoutes.feedback);
            }),
            _buildMenuItem(Icons.logout, "Log Out", () {
              Get.offAllNamed(AppRoutes.loginView);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
