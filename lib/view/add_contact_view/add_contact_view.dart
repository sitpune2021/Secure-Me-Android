import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

class AddContactView extends StatefulWidget {
  const AddContactView({super.key});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 1,
        title: Text(
          "New Contact",
          style: GoogleFonts.poppins(
            fontSize: Get.width * 0.05,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        centerTitle: Platform.isAndroid ? false : true,
        surfaceTintColor: Colors.transparent,
        leading: Platform.isIOS
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                onPressed: () => Get.back(),
              )
            : null,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Get.snackbar(
                  "Saved",
                  "Contact saved successfully",
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
                color: isDark
                    ? AppColors.saveButtonColor
                    : AppColors.lightPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // First Name
                  _buildProfileField(
                    "First Name",
                    _firstnameController,
                    validator: (value) => value == null || value.isEmpty
                        ? "First Name is required"
                        : null,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // Last Name
                  _buildProfileField(
                    "Last Name",
                    _lastnameController,
                    validator: (value) => value == null || value.isEmpty
                        ? "Last Name is required"
                        : null,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // Phone Number
                  _buildProfileField(
                    "Mobile Number",
                    _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Phone number is required";
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value))
                        return "Enter a valid 10-digit phone number";
                      return null;
                    },
                    isDark: isDark,
                  ),

                  SizedBox(height: Get.height * 0.08),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.addButtonGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.snackbar(
                              "Success",
                              "Contact added successfully",
                              backgroundColor: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: Text(
                          "Add",
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
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.poppins(
        color: isDark ? AppColors.darkText : AppColors.lightText,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: isDark ? AppColors.darkHint : AppColors.lightHint,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? AppColors.darkRadialGlow : AppColors.lightPrimary,
          ),
        ),
      ),
    );
  }
}
