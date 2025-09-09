import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:secure_me/controller/location_controller.dart/location_controller.dart';

class ShareLocationView extends StatelessWidget {
  ShareLocationView({super.key});

  final LocationController controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share My Live Location"),
        backgroundColor: Colors.white,
      ),

      body: Obx(() {
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(thickness: 1),
        );
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.currentPosition.value == null) {
          return const Center(child: Text("Unable to fetch location"));
        }

        return GoogleMap(
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
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // FloatingActionButton.extended(
          //   onPressed: controller.moveToCurrentLocation,
          //   label: const Text("My Location"),
          //   icon: const Icon(Icons.my_location),
          // ),
          FloatingActionButton.extended(
            onPressed: () => controller.showShareOptions(),
            label: Text(
              "Share Live Location",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}
