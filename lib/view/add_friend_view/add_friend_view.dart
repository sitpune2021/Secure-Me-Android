import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/add_friend_controller/add_friend_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

class AddFriendsView extends StatelessWidget {
  const AddFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddFriendsController controller = Get.put(AddFriendsController());
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;

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
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: Get.width * .04),
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.addContact),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark
                          ? Colors.purpleAccent
                          : Colors.grey.shade500,
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
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.05),
            child: Column(
              children: [
                // 🔹 Search Box (theme-aware)
                // 🔹 Search Box (theme-aware)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.lightDivider,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) =>
                        controller.searchFriends(value), // ✅ call controller
                    style: GoogleFonts.poppins(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSearchBg
                          : AppColors.lightSearchBg,
                      hintText: "Search by name or number",
                      hintStyle: GoogleFonts.poppins(
                        color: isDark
                            ? AppColors.darkHint
                            : AppColors.lightHint,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark
                            ? AppColors.darkHint
                            : AppColors.lightHint,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Get.height * 0.02),

                Divider(
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                  thickness: 1,
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
    });
  }
}
