import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/community_controller/community_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  void _showAddContactSheet(
    BuildContext context,
    CommunityController controller,
    String communityId,
    String communityName,
    bool isDark,
  ) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final primaryColor = AppColors.primary(isDark);

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.pureWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Add Contact",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              Text(
                "to \"$communityName\"",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.greyTextDark
                      : AppColors.greyTextLight,
                ),
              ),
              const SizedBox(height: 24),
              // Name Field
              TextFormField(
                controller: nameCtrl,
                style: GoogleFonts.poppins(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: GoogleFonts.poppins(
                    color: isDark
                        ? AppColors.greyTextDark
                        : AppColors.greyTextLight,
                  ),
                  prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkBackground.withValues(alpha: 0.5)
                      : AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Name is required" : null,
              ),
              const SizedBox(height: 16),
              // Phone Field
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                style: GoogleFonts.poppins(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: GoogleFonts.poppins(
                    color: isDark
                        ? AppColors.greyTextDark
                        : AppColors.greyTextLight,
                  ),
                  prefixIcon: Icon(Icons.phone_outlined, color: primaryColor),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkBackground.withValues(alpha: 0.5)
                      : AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Phone is required";
                  if (v.length < 10) return "Enter valid 10-digit number";
                  return null;
                },
              ),
              const SizedBox(height: 28),
              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isAddingContact.value
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              controller.addCommunityContact(
                                name: nameCtrl.text.trim(),
                                phoneNo: phoneCtrl.text.trim(),
                                communityId: communityId,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isAddingContact.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            "Add Contact",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityController());
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final primaryColor = AppColors.primary(isDark);

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
          surfaceTintColor: AppColors.transparent,
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
                          AppColors.accent.withValues(alpha: 0.4),
                          AppColors.transparent,
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
                            // Use index+1 as community_id fallback;
                            // replace with community.id once API is integrated
                            final communityId = (index + 1).toString();

                            return Container(
                              margin: EdgeInsets.only(
                                bottom: Get.height * 0.02,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
                                vertical: Get.height * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (isDark
                                            ? AppColors.darkCard
                                            : AppColors.lightCard)
                                        .withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color:
                                      (isDark
                                              ? AppColors.accent
                                              : AppColors.grey)
                                          .withValues(alpha: 0.7),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isDark
                                                ? AppColors.accent
                                                : AppColors.grey)
                                            .withValues(alpha: 0.3),
                                    blurRadius: 25,
                                    spreadRadius: -5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.group,
                                    size: Get.width * 0.07,
                                    color: isDark
                                        ? AppColors.darkText
                                        : AppColors.lightText,
                                  ),
                                  SizedBox(width: Get.width * 0.03),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  ),
                                  // ➕ Add Contact to community button
                                  GestureDetector(
                                    onTap: () => _showAddContactSheet(
                                      context,
                                      controller,
                                      communityId,
                                      community.name,
                                      isDark,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withValues(
                                          alpha: 0.12,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person_add_alt_1_rounded,
                                        size: Get.width * 0.05,
                                        color: primaryColor,
                                      ),
                                    ),
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
    });
  }
}
