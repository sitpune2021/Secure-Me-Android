import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/contact_controller/contact_controller.dart';
import 'package:secure_me/routes/app_pages.dart';
import 'package:secure_me/theme/app_color.dart';

class ContactListView extends StatelessWidget {
  final ContactController controller = Get.put(ContactController());

  ContactListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: Text(
          "Contact List",
          style: GoogleFonts.poppins(
            fontSize: Get.width * 0.05,
            fontWeight: FontWeight.bold,
            color:
                theme.appBarTheme.titleTextStyle?.color ??
                (isDark ? AppColors.darkText : AppColors.lightText),
          ),
        ),
        centerTitle: Platform.isAndroid ? false : true,
        surfaceTintColor: AppColors.transparent,
        leading: Platform.isIOS
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color:
                      theme.iconTheme.color ??
                      (isDark ? AppColors.darkText : AppColors.lightText),
                ),
                onPressed: () => Get.back(),
              )
            : null,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: Get.width * .01,
              right: Get.width * .03,
            ),
            child: Container(
              height: Get.height * .05,
              width: Get.width * .12,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkAddButtonBg
                    : AppColors.lightAddButtonBg,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: AppColors.pureBlack.withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  size: 22,
                ),
                onPressed: () => Get.toNamed(AppRoutes.addContact),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    AppColors.darkBackground,
                    AppColors.darkSecondaryBackground,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    AppColors.lightBackground,
                    AppColors.lightBackground,
                  ],
                ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? RadialGradient(
                    colors: [
                      AppColors.darkRadialGlow.withOpacity(0.7),
                      AppColors.transparent,
                    ],
                    radius: 1,
                    center: Alignment.topRight,
                  )
                : const RadialGradient(
                    colors: [AppColors.transparent, AppColors.transparent],
                    radius: 1,
                    center: Alignment.topRight,
                  ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05,
                vertical: Get.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Search bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25,
                      ), // match TextField radius
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      onChanged: (value) => controller.updateSearch(value),
                      style: GoogleFonts.poppins(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText, // typed text
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkSearchBg
                            : AppColors.lightSearchBg, // background color
                        hintText: "Search",
                        hintStyle: GoogleFonts.poppins(
                          color: isDark
                              ? AppColors.darkHint
                              : AppColors.lightHint, // hint text
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark
                              ? AppColors.darkHint
                              : AppColors.lightHint, // icon
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide
                              .none, // removes internal TextField border
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
                  ),

                  // 📋 Contact List
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
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: isDark
                                  ? AppColors.darkUnselected
                                  : AppColors.lightUnselected,
                              size: 18,
                            ),
                            onTap: () {
                              Get.snackbar(
                                "Selected",
                                contact,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    theme.snackBarTheme.backgroundColor ??
                                    (isDark
                                        ? AppColors.darkBackground
                                        : AppColors.lightBackground),
                                colorText:
                                    theme
                                        .snackBarTheme
                                        .contentTextStyle
                                        ?.color ??
                                    (isDark
                                        ? AppColors.darkText
                                        : AppColors.lightText),
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
        ),
      ),
    );
  }
}
