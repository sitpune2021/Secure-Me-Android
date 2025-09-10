import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/community_controller/community_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,

      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        title: Text(
          "Community",
          style: GoogleFonts.poppins(
            fontSize: Get.width * 0.055,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        centerTitle: Platform.isAndroid ? false : true,
        surfaceTintColor: Colors.transparent,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: isDark ? AppColors.darkText : AppColors.lightText,
        //   ),
        //   onPressed: () => Get.back(),
        // ),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            // 🌌 Glow Center-Bottom (Dark theme only)
            if (isDark)
              Positioned(
                bottom: Get.height * 0.2,
                left: Get.width * 0.1,
                right: Get.width * 0.1,
                child: Container(
                  width: Get.width * 0.7,
                  height: Get.width * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      radius: 0.6,
                    ),
                  ),
                ),
              ),

            // 📋 Communities List
            Padding(
              padding: EdgeInsets.all(Get.width * 0.05),
              child: Obx(
                () => controller.communities.isEmpty
                    ? Center(
                        child: Text(
                          "No communities found",
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.04,
                            color: isDark
                                ? AppColors.greyTextDark
                                : AppColors.greyTextLight,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.communities.length,
                        itemBuilder: (context, index) {
                          final community = controller.communities[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: Get.height * 0.02),
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05,
                              vertical: Get.height * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (isDark
                                          ? AppColors.darkCard
                                          : AppColors.lightCard)
                                      .withOpacity(0.9),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: (isDark ? AppColors.accent : Colors.grey)
                                    .withOpacity(0.7),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isDark ? AppColors.accent : Colors.grey)
                                          .withOpacity(0.3),
                                  blurRadius: 25,
                                  spreadRadius: -5,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.group,
                                  size: Get.width * 0.07,
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                                ),
                                SizedBox(width: Get.width * 0.03),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      community.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: Get.width * 0.045,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkText
                                            : AppColors.lightText,
                                      ),
                                    ),
                                    SizedBox(height: Get.height * 0.005),
                                    Text(
                                      "(${community.members})",
                                      style: GoogleFonts.poppins(
                                        fontSize: Get.width * 0.035,
                                        color: isDark
                                            ? AppColors.greyTextDark
                                            : AppColors.greyTextLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
