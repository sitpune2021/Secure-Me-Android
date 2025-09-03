import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/routes/app_pages.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "New Contact",
          style: GoogleFonts.poppins(
            fontSize: Get.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     if (!Platform.isIOS)
        //       IconButton(
        //         icon: Icon(Icons.arrow_back, color: Colors.black),
        //         onPressed: () => Get.back(),
        //       ),
        //     Text(
        //       "Add Friends",
        //       style: GoogleFonts.poppins(
        //         fontSize: Get.width * 0.05,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.black,
        //       ),
        //     ),
        //     const Spacer(),
        //     InkWell(
        //       onTap: () {
        //         // TODO: Add new friend action
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: Colors.purple,
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //         padding: const EdgeInsets.all(8),
        //         child: const Icon(Icons.add, color: Colors.white, size: 24),
        //       ),
        //     ),
        //   ],
        // ),
        centerTitle: Platform.isAndroid ? false : true,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: Get.width * .01,
              right: Get.width * .03,
            ),
            child: TextButton(
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
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // child: Container(
            //   height: Get.height * .05,
            //   width: Get.width * .15,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black54),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: IconButton(
            //     icon: const Icon(Icons.add, color: Colors.black),
            //     onPressed: () {
            //       Get.toNamed(AppRoutes.addContact);
            //       // Get.snackbar(
            //       //   "Add Contact",
            //       //   "Feature coming soon",
            //       //   snackPosition: SnackPosition.BOTTOM,
            //       //   backgroundColor: Colors.grey.shade200,
            //       //   colorText: Colors.black,
            //       // );
            //     },
            //   ),
            // ),
          ),
        ],
        leading: Platform.isIOS
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Get.back(),
              )
            : null,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
