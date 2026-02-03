import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';
import 'package:secure_me/theme/app_color.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      return Scaffold(
        backgroundColor: AppColors.background(isDark),
        appBar: AppBar(
          backgroundColor: AppColors.background(isDark),
          leading: IconButton(
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: AppColors.text(isDark),
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Notification',
            style: TextStyle(color: AppColors.text(isDark)),
          ),
          iconTheme: IconThemeData(color: AppColors.text(isDark)),
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'Notification',
            style: TextStyle(color: AppColors.text(isDark)),
          ),
        ),
      );
    });
  }
}
