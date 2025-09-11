import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: GoogleFonts.poppins(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          elevation: 0,
          iconTheme: IconThemeData(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          centerTitle: Platform.isAndroid ? false : true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.03),
                // Profile Avatar with Glow
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    if (isDark)
                      Container(
                        width: Get.width * 0.8,
                        height: Get.width * 0.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.darkRadialGlow.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            stops: const [0.1, 1],
                            radius: 0.7,
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=47",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.05),
                // Name Field
                _buildProfileField("Name", _nameController, "Enter Name", (
                  value,
                ) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                }, isDark),
                SizedBox(height: Get.height * 0.03),
                // Phone Field
                _buildProfileField(
                  "Phone",
                  _phoneController,
                  "+917067541230",
                  (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone number is required";
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Enter a valid 10-digit phone number";
                    }
                    return null;
                  },
                  isDark,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                SizedBox(height: Get.height * 0.03),
                // Email Field
                _buildProfileField(
                  "Email",
                  _emailController,
                  "abc@email.com",
                  (value) {
                    if (value == null || value.trim().isEmpty)
                      return "Email is required";
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                    ).hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  isDark,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: Get.height * 0.06),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [
                                AppColors.darkRadialGlow,
                                AppColors.lightSecondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF7B2FF7), Color(0xFF9C1AFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          vertical: Get.height * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Get.snackbar(
                            "Edit",
                            "Profile updated successfully",
                            backgroundColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Text(
                        "Save",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
    });
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    String hint,
    String? Function(String?) validator,
    bool isDark, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 14,
          ),
        ),
        SizedBox(height: Get.height * 0.008),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          ),
          style: GoogleFonts.poppins(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Get.height * 0.01),
        Container(
          height: 1,
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ],
    );
  }
}
