import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';
import 'package:secure_me/utils/preference_helper.dart';

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
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    log(
      '🔍 EditProfileView: Loading user data from SharedPreferences...',
      name: 'EditProfileView',
    );
    final name = await PreferenceHelper.getUserName();
    final email = await PreferenceHelper.getUserEmail();
    final phone = await PreferenceHelper.getUserPhone();

    log(
      '🔍 EditProfileView: Retrieved - Name: $name, Email: $email, Phone: $phone',
      name: 'EditProfileView',
    );

    setState(() {
      if (name != null && name.isNotEmpty) {
        _nameController.text = name;
        log(
          '✅ EditProfileView: Name field populated: $name',
          name: 'EditProfileView',
        );
      }
      if (email != null && email.isNotEmpty) {
        _emailController.text = email;
        log(
          '✅ EditProfileView: Email field populated: $email',
          name: 'EditProfileView',
        );
      }
      if (phone != null && phone.isNotEmpty) {
        _phoneController.text = phone;
        log(
          '✅ EditProfileView: Phone field populated: $phone',
          name: 'EditProfileView',
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
                              AppColors.transparent,
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
                        color: AppColors.pureWhite,
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
                        backgroundColor: AppColors.transparent,
                        shadowColor: AppColors.transparent,
                        padding: EdgeInsets.symmetric(
                          vertical: Get.height * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          log(
                            '💾 EditProfileView: Saving updated profile data...',
                            name: 'EditProfileView',
                          );

                          // Save updated data to SharedPreferences
                          await PreferenceHelper.saveUserName(
                            _nameController.text.trim(),
                          );
                          await PreferenceHelper.saveUserEmail(
                            _emailController.text.trim(),
                          );
                          await PreferenceHelper.saveUserPhone(
                            _phoneController.text.trim(),
                          );

                          log(
                            '✅ EditProfileView: Profile data saved successfully',
                            name: 'EditProfileView',
                          );

                          Get.snackbar(
                            "Success",
                            "Profile updated successfully",
                            backgroundColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                            colorText: AppColors.pureWhite,
                            snackPosition: SnackPosition.BOTTOM,
                          );

                          // Navigate back after a short delay
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Get.back();
                          });
                        }
                      },
                      child: Text(
                        "Save",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pureWhite,
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
        // Label
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 14,
          ),
        ),
        SizedBox(height: Get.height * 0.008),

        // TextField
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: GoogleFonts.poppins(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: false, // 🔹 prevent Material filled rounded effect
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.darkRadialGlow
                    : AppColors.lightPrimary,
                width: 2,
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: isDark ? AppColors.greyShade400 : AppColors.greyShade600,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          ),
        ),

        SizedBox(height: Get.height * 0.01),
      ],
    );
  }
}
