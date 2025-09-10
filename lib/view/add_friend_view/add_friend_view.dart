import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/add_friend_controller/add_friend_controller.dart';

class AddFriendsView extends StatelessWidget {
  const AddFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddFriendsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0B1A) : Colors.white,

      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D0B1A) : Colors.white,
        elevation: 0,
        title: Text(
          'Add Friends',
          style: GoogleFonts.poppins(
            fontSize: Get.width * 0.055,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.pinkAccent : Colors.black,
          ),
        ),
        centerTitle: Platform.isAndroid ? false : true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Get.width * .04),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.purpleAccent : Colors.grey.shade500,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.add,
                color: isDark ? Colors.white : Colors.black,
                size: 26,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.05),
          child: Column(
            children: [
              // 🔹 Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1C2A) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isDark ? Colors.purpleAccent : Colors.grey.shade500,
                    width: 1,
                  ),
                ),
                child: TextField(
                  onChanged: (value) => controller.searchFriends(value),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    icon: Icon(
                      Icons.search,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.02),

              // 🔹 Friends List
              Expanded(
                child: Obx(() {
                  if (controller.filteredFriends.isEmpty) {
                    return Center(
                      child: Text(
                        "No friends found",
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.filteredFriends.length,
                    itemBuilder: (context, index) {
                      final friend = controller.filteredFriends[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: Get.height * 0.015),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E1C2A)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? Colors.purpleAccent
                                : Colors.grey.shade500,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.04,
                            vertical: Get.height * 0.01,
                          ),
                          leading: CircleAvatar(
                            radius: Get.width * 0.08,
                            backgroundImage: AssetImage(friend["image"]!),
                          ),
                          title: Text(
                            friend["name"]!,
                            style: GoogleFonts.poppins(
                              fontSize: Get.width * 0.045,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            friend["phone"]!,
                            style: GoogleFonts.poppins(
                              fontSize: Get.width * 0.035,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey,
                            ),
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
