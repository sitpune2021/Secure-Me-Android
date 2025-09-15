import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          leading: IconButton(
            icon: Icon(
             Platform.isAndroid? Icons.arrow_back:Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Notification',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          iconTheme: IconThemeData(
            color: isDark ? Colors.white : Colors.black,
          ),
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'Notification',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ),
      );
    });
  }
}
