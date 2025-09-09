import 'dart:io';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
        ),

        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     if (!Platform.isIOS)
        //       IconButton(
        //         icon: Icon(Icons.arrow_back, color: Colors.black),
        //         onPressed: () => Get.back(),
        //       ),
        //     Text(
        //       "Add Friends",
        //       style: GoogleFonts.poppins(
        //         fontSize: Get.width * 0.05,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.black,
        //       ),
        //     ),
        //     const Spacer(),
        //     InkWell(
        //       onTap: () {
        //         // TODO: Add new friend action
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: Colors.purple,
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //         padding: const EdgeInsets.all(8),
        //         child: const Icon(Icons.add, color: Colors.white, size: 24),
        //       ),
        //     ),
        //   ],
        // ),
        centerTitle: Platform.isAndroid ? false : true,
        surfaceTintColor: Colors.transparent,
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: Get.width * .03),
        //     child: InkWell(
        //       onTap: () {
        //         // TODO: Add new friend action
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: Colors.purple,
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //         padding: const EdgeInsets.all(8),
        //         child: const Icon(Icons.add, color: Colors.white, size: 24),
        //       ),
        //     ),
        //   ),
        // ],
        leading: Platform.isIOS
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Get.back(),
              )
            : null,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: Get.width * .035,
          right: Get.width * .035,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              trailing: Icon(
                Icons.chevron_right,
                size: Get.width * .1,
                color: Colors.black,
              ),
              onTap: () {
                Get.toNamed(AppRoutes.contactList);
              },
            ),

            //Divider(color: Colors.grey.shade300),

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
    );
  }
}
