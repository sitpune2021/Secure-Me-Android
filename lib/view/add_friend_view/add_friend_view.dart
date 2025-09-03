import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/add_friend_controller/add_friend_controller.dart';

class AddFriendsView extends StatelessWidget {
  const AddFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddFriendsController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header Row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    "Add Friends",
                    style: GoogleFonts.poppins(
                      fontSize: Get.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      // TODO: Add new friend action
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Get.height * 0.02),

              // 🔹 Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  onChanged: (value) => controller.searchFriends(value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search by name or phone",
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.02),

              // 🔹 Friends List
              Expanded(
                child: Obx(() {
                  if (controller.filteredFriends.isEmpty) {
                    return const Center(child: Text("No friends found"));
                  }
                  return ListView.builder(
                    itemCount: controller.filteredFriends.length,
                    itemBuilder: (context, index) {
                      final friend = controller.filteredFriends[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: Get.height * 0.015),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(friend["image"]!),
                          ),
                          title: Text(
                            friend["name"]!,
                            style: GoogleFonts.poppins(
                              fontSize: Get.width * 0.045,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            friend["phone"]!,
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                          onTap: () {
                            Get.snackbar("Friend Selected", friend["name"]!);
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
