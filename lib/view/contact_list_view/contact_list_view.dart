import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/contact_controller/contact_controller.dart';
import 'package:secure_me/routes/app_pages.dart';

class ContactListView extends StatelessWidget {
  final ContactController controller = Get.put(ContactController());

  ContactListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // light theme background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
            vertical: Get.height * 0.02,
          ),
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
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                      SizedBox(width: Get.width * 0.02),
                      Text(
                        "Contact List",
                        style: GoogleFonts.poppins(
                          fontSize: Get.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: () {
                        Get.toNamed(AppRoutes.addContact);
                        // Get.snackbar(
                        //   "Add Contact",
                        //   "Feature coming soon",
                        //   snackPosition: SnackPosition.BOTTOM,
                        //   backgroundColor: Colors.grey.shade200,
                        //   colorText: Colors.black,
                        // );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: Get.height * 0.02),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  style: GoogleFonts.poppins(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: GoogleFonts.poppins(color: Colors.black54),
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.02),
              Divider(color: Colors.grey.shade400),

              // Contact List
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = controller.filteredContacts[index];
                      return ListTile(
                        title: Text(
                          contact,
                          style: GoogleFonts.poppins(
                            fontSize: Get.width * 0.045,
                            color: Colors.black,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black54,
                          size: 18,
                        ),
                        onTap: () {
                          Get.snackbar(
                            "Selected",
                            contact,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.grey.shade200,
                            colorText: Colors.black,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
