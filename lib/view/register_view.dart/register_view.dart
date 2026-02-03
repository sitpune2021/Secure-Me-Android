import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/register_controller/register_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final ThemeController themeController = Get.find<ThemeController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final theme = themeController.theme;

      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            ),
          ),
          title: Text(
            "Create Account",
            style: GoogleFonts.poppins(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Get.width * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.02),

                // Profile Avatar with glow (Glow only in Dark Mode)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isDark)
                      Container(
                        width: Get.width * 0.42,
                        height: Get.width * 0.42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.4),
                              spreadRadius: 8,
                              blurRadius: 24,
                            ),
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.3),
                              spreadRadius: 16,
                              blurRadius: 48,
                            ),
                          ],
                        ),
                      ),
                    CircleAvatar(
                      radius: Get.width * 0.18,
                      backgroundImage: const NetworkImage(
                        "https://i.pravatar.cc/150?img=47",
                      ),
                    ),
                    Positioned(
                      top: Get.height * 0.02,
                      right: Get.width * 0.01,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    AppColors.darkRadialGlow,
                                    AppColors.lightPrimary,
                                  ]
                                : [
                                    AppColors.glowPurple,
                                    AppColors.darkRadialGlow,
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                            width: 1.2,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.edit,
                          color: theme.colorScheme.onSurface,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Get.height * 0.05),

                // Name Field
                _buildProfileField("Name", _nameController, "Abc", isDark, (
                  value,
                ) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                }),
                SizedBox(height: Get.height * 0.03),

                // Phone Field
                _buildProfileField(
                  "Phone",
                  _phoneController,
                  "1111111111",
                  isDark,
                  (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Phone number is required";
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Enter a valid 10-digit phone number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                SizedBox(height: Get.height * 0.03),

                _buildProfileField(
                  "Email",
                  _emailController,
                  "abc@email.com",
                  isDark,
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
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: Get.height * 0.03),

                // Password Field
                _buildProfileField(
                  "Password",
                  _passwordController,
                  "********",
                  isDark,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: Get.height * 0.06),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: Get.height * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: isDark
                            ? AppColors.glowPurpleTopLeft
                            : AppColors.lightPrimary,
                      ),
                      onPressed: registerController.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                registerController.registerUser(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                              }
                            },
                      child: registerController.isLoading.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Register",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
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
    bool isDark,
    String? Function(String?) validator, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isDark
                ? AppColors.darkText.withOpacity(0.7)
                : AppColors.lightText.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        SizedBox(height: Get.height * 0.008),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: isDark
                  ? AppColors.darkHint.withOpacity(0.7)
                  : AppColors.lightHint.withOpacity(0.7),
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
