import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/setting_controller/setting_controller.dart';
import 'package:secure_me/routes/app_pages.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // light theme
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    "Setting",
                    style: GoogleFonts.poppins(
                      fontSize: Get.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.03),

              // Add Edit Emergency
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Add Edit Emergency",
                  style: GoogleFonts.poppins(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.black),
                onTap: () {
                  Get.toNamed(AppRoutes.contactList);
                },
              ),

              Divider(color: Colors.grey.shade300),

              // Auto Call on SOS
              Obx(
                () => SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Auto Call On Sos",
                    style: GoogleFonts.poppins(
                      fontSize: Get.width * 0.045,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  value: controller.autoCallOnSos.value,
                  onChanged: controller.toggleAutoCall,
                  activeColor: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
