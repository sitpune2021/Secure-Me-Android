import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      backgroundColor: Colors.white, // light background

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "New Contact",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.snackbar(
                          "Saved",
                          "Contact saved successfully",
                          backgroundColor: Colors.green.shade400,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Text(
                      "Save",
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(color: Colors.black26),

              Expanded(
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
                        ),
                        const SizedBox(height: 20),

                        // Last Name
                        _buildProfileField(
                          "Last Name",
                          _lastnameController,
                          validator: (value) => value == null || value.isEmpty
                              ? "Last Name is required"
                              : null,
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
                        ),

                        SizedBox(height: Get.height * 0.08),

                        // Add Button
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
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
                                    backgroundColor: Colors.green.shade400,
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
            ],
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
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.black54),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black87),
        ),
      ),
    );
  }
}
