import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/controller/profile_controller/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    // Fetch latest profile data when entering the view
    profileController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final double screenWidth = Get.width;

    return Obx(() {
      // Get the correct theme values from controller
      final isDark = themeController.isDarkMode.value;
      final userOverride = themeController.userOverride.value;

      // Determine effective theme (user preference or system)
      final effectiveDark = userOverride
          ? isDark
          : WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark;

      final textColor = effectiveDark
          ? AppColors.darkText
          : AppColors.lightText;
      final subTextColor = effectiveDark
          ? AppColors.darkHint
          : AppColors.lightHint;
      final backgroundColor = effectiveDark
          ? AppColors.darkBackground
          : AppColors.lightBackground;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          surfaceTintColor: AppColors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Profile",
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: screenWidth < 380 ? 18 : 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          centerTitle: Platform.isAndroid ? false : true,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile Header
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // 🌟 Premium Multiple Glow Layers (Dark Mode only)
                          if (effectiveDark) ...[
                            Container(
                              width: 95,
                              height: 95,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.glowPurple.withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 85,
                              height: 85,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.purpleAccent.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // 💍 Neon Ring Border
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: effectiveDark
                                    ? [
                                        AppColors.glowPurple,
                                        AppColors.pinkAccent,
                                      ]
                                    : [
                                        AppColors.lightPrimary,
                                        AppColors.lightSecondary,
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: backgroundColor,
                              backgroundImage:
                                  profileController.userData['profile_image'] !=
                                      null
                                  ? NetworkImage(
                                      "${AppUrl.host}/${profileController.userData['profile_image']}",
                                    )
                                  : const NetworkImage(
                                      "https://i.pravatar.cc/150?img=47",
                                    ),
                            ),
                          ),

                          // 📸 Camera Icon
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary(effectiveDark),
                                border: Border.all(
                                  color: backgroundColor,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileController.userData['name'] ?? "User",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth < 380 ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profileController.userData['email'] ??
                                  "email@example.com",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth < 380 ? 12 : 14,
                                color: subTextColor.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profileController.userData['phone_no'] ??
                                  "+91 XXXXXXXXXX",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth < 380 ? 12 : 14,
                                color: textColor.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(color: subTextColor.withOpacity(0.3)),

                  /// Menu Items
                  _buildMenuItem(
                    "Edit Profile",
                    () => Get.toNamed(AppRoutes.editProfile),
                    screenWidth,
                    textColor,
                  ),
                  _buildMenuItem(
                    "Location",
                    () => Get.toNamed(AppRoutes.location),
                    screenWidth,
                    textColor,
                  ),
                  _buildMenuItem(
                    "Friends",
                    () => Get.toNamed(AppRoutes.friends),
                    screenWidth,
                    textColor,
                  ),
                  _buildMenuItem(
                    "Push Notifications",
                    () => Get.toNamed(AppRoutes.pushnotification),
                    screenWidth,
                    textColor,
                  ),
                  _buildMenuItem(
                    "Settings",
                    () => Get.toNamed(AppRoutes.setting),
                    screenWidth,
                    textColor,
                  ),
                  _buildMenuItem("Help", () {}, screenWidth, textColor),

                  if (profileController.userData['user_role'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              (effectiveDark
                                      ? AppColors.darkCard
                                      : AppColors.lightCard)
                                  .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                (effectiveDark
                                        ? AppColors.darkDivider
                                        : AppColors.lightDivider)
                                    .withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "User Role",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: subTextColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary(
                                  effectiveDark,
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                profileController.userData['user_role'] ??
                                    "User",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary(effectiveDark),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (profileController.userData['created_at'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              (effectiveDark
                                      ? AppColors.darkCard
                                      : AppColors.lightCard)
                                  .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                (effectiveDark
                                        ? AppColors.darkDivider
                                        : AppColors.lightDivider)
                                    .withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Member Since",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: subTextColor,
                              ),
                            ),
                            Text(
                              profileController.userData['created_at']
                                  .toString()
                                  .split('T')[0],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  /// Dark Mode Switch with System Option

                  ///
                  ///
                  _theme(
                    "Theme Mode",
                    () {
                      Get.toNamed(AppRoutes.theme);
                    },
                    screenWidth,
                    textColor,
                  ),

                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     ListTile(
                  //       contentPadding: EdgeInsets.zero,
                  //       title: Text(
                  //         "Dark Mode",
                  //         style: GoogleFonts.poppins(
                  //           fontSize: screenWidth < 380 ? 14 : 16,
                  //           color: textColor,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //       trailing: Switch(
                  //         value: themeController.isDarkMode.value,
                  //         activeColor: effectiveDark
                  //             ? AppColors.glowPurpleTopLeft
                  //             : AppColors.lightPrimary,
                  //         onChanged: (value) {
                  //           themeController.toggleTheme(value);
                  //         },
                  //       ),
                  //     ),

                  //   ],
                  // ),
                  Divider(color: subTextColor.withOpacity(0.3)),

                  /// More Section
                  const SizedBox(height: 10),
                  Text(
                    "More",
                    style: GoogleFonts.poppins(
                      color: subTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildMenuItem("About Us", () {}, screenWidth, textColor),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.logout, color: subTextColor),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth < 380 ? 14 : 16,
                        color: textColor,
                      ),
                    ),
                    onTap: () {
                      profileController.logout();
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildMenuItem(
    String title,
    VoidCallback onTap,
    double screenWidth,
    Color textColor,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: screenWidth < 380 ? 14 : 16,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: textColor.withOpacity(0.6)),
      onTap: onTap,
    );
  }
}

Widget _theme(
  String title,
  VoidCallback onTap,
  double screenWidth,
  Color textColor,
) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: screenWidth < 380 ? 14 : 16,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Icon(Icons.chevron_right, color: textColor.withOpacity(0.6)),
    onTap: onTap,
  );
}
