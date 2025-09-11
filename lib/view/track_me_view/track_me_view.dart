import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/track_me_controller.dart/track_me_controller.dart';
import 'package:secure_me/controller/theme_controller/theme_controller.dart';

class TrackMeView extends StatelessWidget {
  const TrackMeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TrackMeController controller = Get.put(TrackMeController());
    final ThemeController themeController = Get.find();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final theme = themeController.theme;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Track Me",
            style: GoogleFonts.poppins(
              color: theme.colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        ),
        backgroundColor: theme.colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Location",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // Current/Destination + Transport Options Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.white24 : Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: theme.colorScheme.primary,
                            ),
                            Container(
                              height: 30,
                              width: 2,
                              color: isDark
                                  ? Colors.white24
                                  : Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.radio_button_checked,
                              color: Colors.red.shade400,
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Location",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Destination",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Transport Options
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTransportOption(
                            Icons.directions_bus,
                            "Bus",
                            controller,
                            0,
                            theme,
                          ),
                          _buildTransportOption(
                            Icons.directions_car,
                            "Car",
                            controller,
                            1,
                            theme,
                          ),
                          _buildTransportOption(
                            Icons.pedal_bike,
                            "Bike",
                            controller,
                            2,
                            theme,
                          ),
                          _buildTransportOption(
                            Icons.directions_walk,
                            "Walk",
                            controller,
                            3,
                            theme,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTransportOption(
    IconData icon,
    String label,
    TrackMeController controller,
    int index,
    ThemeData theme,
  ) {
    final bool isSelected = controller.selectedTransport.value == index;

    return GestureDetector(
      onTap: () => controller.selectTransport(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color?.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
