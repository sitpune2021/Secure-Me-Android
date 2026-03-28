import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_me/controller/track_me_controller.dart';
import 'package:remixicon/remixicon.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackMeView extends StatefulWidget {
  const TrackMeView({super.key});

  @override
  State<TrackMeView> createState() => _TrackMeViewState();
}

class _TrackMeViewState extends State<TrackMeView> {
  final TrackMeController controller = Get.put(TrackMeController());
  late GoogleMapController mapController;

  static const _pGooglePlex = CameraPosition(
    target: LatLng(18.5204, 73.8567), // Pune Coordinate
    zoom: 14.4746,
  );

  // MOCK SAFETY ZONES
  final Set<Circle> _safetyZones = {
    Circle(
      circleId: const CircleId("safe_zone_1"),
      center: const LatLng(18.5244, 73.8587),
      radius: 300,
      fillColor: Colors.green.withValues(alpha: 0.25),
      strokeColor: Colors.green,
      strokeWidth: 2,
    ),
    Circle(
      circleId: const CircleId("danger_zone_1"),
      center: const LatLng(18.5144, 73.8487),
      radius: 400,
      fillColor: Colors.red.withValues(alpha: 0.25),
      strokeColor: Colors.red,
      strokeWidth: 2,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "TRACK ME",
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Map Header Area (Indicators) ──────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                _indicatorChip("Safe Areas", Colors.green),
                const SizedBox(width: 12),
                _indicatorChip("High Caution", Colors.red),
              ],
            ),
          ),

          // ── Interactive Map Section ──────────────────────────────────
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: GoogleMap(
                  onMapCreated: (c) {
                    mapController = c;
                  },
                  style: isDark ? _darkMapStyle : null,
                  initialCameraPosition: _pGooglePlex,
                  circles: _safetyZones,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
          ),

          // ── Bottom Controls ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _buildStepIcon(Remix.map_pin_2_fill, theme.primaryColor),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Safe Sentinel", style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
                          Text("Pulse Active • 123 Safety St.", style: GoogleFonts.outfit(fontSize: 12, color: theme.hintColor)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTransportModes(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicatorChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildTransportModes() {
    final modes = [
      {'icon': Remix.bus_line, 'id': 0},
      {'icon': Remix.car_line, 'id': 1},
      {'icon': Remix.bike_line, 'id': 2},
      {'icon': Remix.walk_line, 'id': 3},
    ];

    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: modes.map((m) {
            final isSelected = controller.selectedTransport.value == m['id'];
            return GestureDetector(
              onTap: () => controller.selectTransport(m['id'] as int),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).dividerColor.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(m['icon'] as IconData, color: isSelected ? Colors.white : Theme.of(context).hintColor),
              ),
            );
          }).toList(),
        ));
  }

  static const String _darkMapStyle = '''
[
  { "elementType": "geometry", "stylers": [{ "color": "#212121" }] },
  { "elementType": "labels.icon", "stylers": [{ "visibility": "off" }] },
  { "elementType": "labels.text.fill", "stylers": [{ "color": "#757575" }] },
  { "elementType": "labels.text.stroke", "stylers": [{ "color": "#212121" }] },
  { "featureType": "administrative", "elementType": "geometry", "stylers": [{ "color": "#757575" }] },
  { "featureType": "poi", "elementType": "geometry", "stylers": [{ "color": "#181818" }] },
  { "featureType": "road", "elementType": "geometry.fill", "stylers": [{ "color": "#2c2c2c" }] },
  { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#000000" }] }
]
''';
}
