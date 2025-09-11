import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:secure_me/controller/location_controller.dart/location_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class ShareLocationView extends StatelessWidget {
  ShareLocationView({super.key});

  final LocationController controller = Get.put(LocationController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final theme = themeController.theme;

      return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          title: Text(
            "Share My Live Location",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),

        body: Obx(() {
          if (controller.isFetching.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.currentPosition.value == null) {
            return Center(
              child: Text(
                "Unable to fetch location",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            );
          }

          return Column(
            children: [
              Divider(thickness: 1, color: theme.dividerColor),
              Expanded(
                child: GoogleMap(
                  onMapCreated: controller.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: controller.currentPosition.value!,
                    zoom: 16,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: {
                    Marker(
                      markerId: const MarkerId("currentLocation"),
                      position: controller.currentPosition.value!,
                    ),
                  },
                ),
              ),
            ],
          );
        }),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          onPressed: () => controller.showShareOptions(),
          icon: Icon(Icons.share, color: theme.colorScheme.onPrimary),
          label: Text(
            "Share Live Location",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      );
    });
  }
}
