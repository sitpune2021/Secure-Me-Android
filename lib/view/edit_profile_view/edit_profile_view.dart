import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isThemeDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
        centerTitle: Platform.isAndroid ? false : true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Get.width * 0.05,
          right: Get.width * 0.05,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar with background glow
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // 🌟 Show Glow only in Dark Theme
                  if (isThemeDark)
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

                  // Avatar + White Border
                  Container(
                    padding: const EdgeInsets.all(2), // white border thickness
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

                  // ✏️ Edit Icon (still theme-aware if you want)
                  Positioned(
                    right: 68,
                    bottom: 170,
                    child: Container(
                      width: Get.width * 0.1,
                      height: Get.width * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1),
                        gradient: LinearGradient(
                          colors: isThemeDark
                              ? [
                                  AppColors.darkRadialGlow,
                                  AppColors.lightSecondary,
                                ]
                              : [
                                  AppColors.lightSecondary,
                                  AppColors.lightPrimary,
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
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
              }, theme),
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
                theme,
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
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                  ).hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
                theme,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: Get.height * 0.06),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2FF7), Color(0xFF9C1AFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isThemeDark
                          ? AppColors.darkRadialGlow
                          : const Color(0xFF7B2FF7),
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
                          backgroundColor: Colors.green.shade100,
                          colorText: Colors.black87,
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
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    String hint,
    String? Function(String?) validator,
    ThemeData theme, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: theme.textTheme.bodyMedium?.color,
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
              color:
                  theme.inputDecorationTheme.hintStyle?.color ??
                  Colors.grey.shade400,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          ),
          style: GoogleFonts.poppins(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: Get.height * 0.01),
        Container(height: 1, color: theme.dividerColor),
      ],
    );
  }
}
