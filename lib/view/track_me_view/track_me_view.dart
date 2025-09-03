import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/track_me_controller.dart/track_me_controller.dart';

class TrackMeView extends StatelessWidget {
  const TrackMeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TrackMeController controller = Get.put(TrackMeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track Me",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

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
              ),
            ),
            const SizedBox(height: 12),

            // ONE card with Current/Destination + Transport Options
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current + Destination
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icons + line
                      Column(
                        children: [
                          const Icon(Icons.location_on, color: Colors.purple),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade400,
                          ),
                          const Icon(
                            Icons.radio_button_checked,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      // Labels
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Location",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Destination",
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Transport Options INSIDE same card
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTransportOption(
                          Icons.directions_bus,
                          "Bus",
                          controller,
                          0,
                        ),
                        _buildTransportOption(
                          Icons.directions_car,
                          "Car",
                          controller,
                          1,
                        ),
                        _buildTransportOption(
                          Icons.pedal_bike,
                          "Bike",
                          controller,
                          2,
                        ),
                        _buildTransportOption(
                          Icons.directions_walk,
                          "Walk",
                          controller,
                          3,
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
  }

  Widget _buildTransportOption(
    IconData icon,
    String label,
    TrackMeController controller,
    int index,
  ) {
    final bool isSelected = controller.selectedTransport.value == index;

    return GestureDetector(
      onTap: () => controller.selectTransport(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.purple.shade50 : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.purple : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.purple : Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
