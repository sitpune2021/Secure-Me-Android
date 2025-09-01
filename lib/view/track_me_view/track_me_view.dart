import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_me/controller/track_me_controller.dart/track_me_controller.dart';

class TrackMeView extends StatelessWidget {
  const TrackMeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TrackMeController controller = Get.put(TrackMeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track Me",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          children: const [
                            Text(
                              "Current Location",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            Text("Destination", style: TextStyle(fontSize: 16)),
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

            const SizedBox(height: 20),

            // Map Preview
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/map_sample.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.purple : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
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
