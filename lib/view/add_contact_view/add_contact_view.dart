import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/controller/add_contact_controller/add_contact_controller.dart';
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
  final TextEditingController _emailController = TextEditingController();

  final ThemeController themeController = Get.find<ThemeController>();
  final AddContactController addContactController = Get.put(
    AddContactController(),
  );

  String _selectedRole = "Gym_Person";
  final List<String> _roles = ["User", "Gym_Person", "Guardian", "Police"];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args['isEdit'] == true) {
      final contact = args['contact'];
      if (contact != null) {
        addContactController.isEditing.value = true;
        addContactController.editingContactId.value = contact.id ?? -1;

        // Populate fields
        _phoneController.text = contact.phoneNo ?? "";
        _emailController.text = contact.email ?? "";

        final name = contact.name ?? "";
        final parts = name.split(" ");
        _firstnameController.text = parts.isNotEmpty ? parts[0] : "";
        _lastnameController.text = parts.length > 1
            ? parts.sublist(1).join(" ")
            : "";

        if (_roles.contains(contact.userRole)) {
          _selectedRole = contact.userRole!;
        }
      }
    } else {
      addContactController.isEditing.value = false;
      addContactController.editingContactId.value = -1;
    }
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
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          elevation: 1,
          title: Text(
            addContactController.isEditing.value
                ? "Update Contact"
                : "New Contact",
            style: GoogleFonts.poppins(
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          centerTitle: Platform.isAndroid ? false : true,
          surfaceTintColor: AppColors.transparent,
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
              onPressed: addContactController.isLoading.value
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        addContactController.addContact(
                          name:
                              '${_firstnameController.text.trim()} ${_lastnameController.text.trim()}',
                          phoneNo: _phoneController.text.trim(),
                          email: _emailController.text.trim(),
                          userRole: _selectedRole,
                        );
                      }
                    },
              child: Text(
                "Save",
                style: GoogleFonts.poppins(
                  color: isDark
                      ? AppColors
                            .darkHint // Changed to safe color
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
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return "Enter a valid 10-digit phone number";
                        }
                        return null;
                      },
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    // Email
                    _buildProfileField(
                      "Email",
                      _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                        ).hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    // Role
                    _buildRoleDropdown(isDark),

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
                            backgroundColor: AppColors.transparent,
                            shadowColor: AppColors.transparent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: addContactController.isLoading.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    addContactController.addContact(
                                      name:
                                          '${_firstnameController.text.trim()} ${_lastnameController.text.trim()}',
                                      phoneNo: _phoneController.text.trim(),
                                      email: _emailController.text.trim(),
                                      userRole: _selectedRole,
                                    );
                                  }
                                },
                          child: addContactController.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  addContactController.isEditing.value
                                      ? "Update"
                                      : "Add",
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
          ),
        ),
      );
    });
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
        filled: false, // <-- make sure filled is false
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
            color: isDark ? AppColors.darkRadialGlow : AppColors.lightPrimary,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        labelText: "Role",
        labelStyle: GoogleFonts.poppins(
          color: isDark ? AppColors.darkHint : AppColors.lightHint,
        ),
        filled: false,
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
            color: isDark ? AppColors.darkRadialGlow : AppColors.lightPrimary,
            width: 2,
          ),
        ),
      ),
      dropdownColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      style: GoogleFonts.poppins(
        color: isDark ? AppColors.darkText : AppColors.lightText,
        fontSize: 16,
      ),
      items: _roles.map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(role.replaceAll('_', ' ')),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedRole = val;
          });
        }
      },
    );
  }
}
