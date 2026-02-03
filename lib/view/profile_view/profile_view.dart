import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String userName = "User";
  String userPhone = "+91 XXXXXXXXXX";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await PreferenceHelper.getUserName();
    final phone = await PreferenceHelper.getUserPhone();

    setState(() {
      if (name != null && name.isNotEmpty) {
        userName = name;
      }
      if (phone != null && phone.isNotEmpty) {
        userPhone = phone;
      }
    });
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
          surfaceTintColor: Colors.transparent,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: effectiveDark
                              ? [
                                  AppColors.glowPurpleTopLeft,
                                  AppColors.darkPrimary,
                                ]
                              : [Colors.grey.shade300, Colors.grey.shade200],
                        ),
                        boxShadow: effectiveDark
                            ? [
                                BoxShadow(
                                  color: AppColors.glowPurpleTopLeft
                                      .withOpacity(0.7),
                                  blurRadius: 25,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: AppColors.darkPrimary.withOpacity(0.5),
                                  blurRadius: 40,
                                  spreadRadius: 12,
                                ),
                              ]
                            : [],
                      ),
                      child: Container(
                        width: screenWidth < 380 ? 56 : 70,
                        height: screenWidth < 380 ? 56 : 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: effectiveDark
                                ? [
                                    AppColors.glowPurpleTopLeft,
                                    AppColors.darkPrimary,
                                  ]
                                : [Colors.purple, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: screenWidth < 380 ? 30 : 38,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth < 380 ? 16 : 18,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userPhone,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth < 380 ? 12 : 14,
                            color: subTextColor,
                          ),
                        ),
                      ],
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
                  onTap: () async {
                    await PreferenceHelper.clearUserData();
                    Get.offAllNamed(AppRoutes.loginView);
                  },
                ),
              ],
            ),
          ),
        ),
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
