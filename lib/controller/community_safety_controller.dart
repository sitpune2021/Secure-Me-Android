import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SafetyZone {
  final String id;
  final String name;
  final LatLng point;
  final String status; // 'Safe Area', 'Danger Zone'
  final String description;
  final int activeResponders;
  final Color color;

  SafetyZone({
    required this.id,
    required this.name,
    required this.point,
    required this.status,
    required this.description,
    this.activeResponders = 0,
    required this.color,
  });
}

class ResponderSignal {
  final String id;
  final String type; // police, helper, medic
  final double distance; // in meters (simulated)
  final double angle; // in degrees for radar positioning

  ResponderSignal({
    required this.id,
    required this.type,
    required this.distance,
    required this.angle,
  });
}

class CommunitySafetyController extends GetxController {
  final RxList<SafetyZone> safetyZones = <SafetyZone>[].obs;
  final RxList<ResponderSignal> scannedResponders = <ResponderSignal>[].obs;
  final RxBool isScanning = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSafetyData();
  }

  void _loadSafetyData() {
    safetyZones.addAll([
      SafetyZone(
        id: "s1",
        name: "Security Node: South Hub",
        point: const LatLng(18.5204, 73.8567),
        status: "Safe Area",
        description: "Tactical HQ with 24/7 security patrol and medical standby.",
        activeResponders: 14,
        color: Colors.green,
      ),
      SafetyZone(
        id: "s2",
        name: "Central Park West Outpost",
        point: const LatLng(18.5250, 73.8600),
        status: "Safe Area",
        description: "Open visibility zone with direct emergency line monitoring.",
        activeResponders: 6,
        color: Colors.green,
      ),
      SafetyZone(
        id: "s3",
        name: "Metro Station Safe Zone",
        point: const LatLng(18.515, 73.865),
        status: "Safe Area",
        description: "Verified Transit Hub with active civilian sentinels.",
        activeResponders: 9,
        color: Colors.green,
      ),
      SafetyZone(
        id: "d1",
        name: "Market Alleyway (Restricted)",
        point: const LatLng(18.518, 73.854),
        status: "Danger Zone",
        description: "Critical risk after sunset. Low lighting and blind spots.",
        color: Colors.red,
      ),
      SafetyZone(
        id: "d2",
        name: "Abandoned Mill Site",
        point: const LatLng(18.5300, 73.8700),
        status: "Danger Zone",
        description: "Structural instability. High reports of unauthorized activity.",
        color: Colors.red,
      ),
      SafetyZone(
        id: "d3",
        name: "Upper Ridge Road",
        point: const LatLng(18.529, 73.840),
        status: "Danger Zone",
        description: "Isolation zone. Recommended travel only in groups.",
        color: Colors.red,
      ),
    ]);

    // Initial signals for radar
    _generateMockSignals();
  }

  void startRadarScan() async {
    isScanning.value = true;
    scannedResponders.clear();
    
    // Simulate staggered radar findings
    await Future.delayed(const Duration(milliseconds: 1000));
    scannedResponders.add(ResponderSignal(id: "p1", type: "police", distance: 120, angle: 45));
    
    await Future.delayed(const Duration(milliseconds: 1500));
    scannedResponders.add(ResponderSignal(id: "h1", type: "helper", distance: 300, angle: 220));
    
    await Future.delayed(const Duration(milliseconds: 800));
    scannedResponders.add(ResponderSignal(id: "m1", type: "medic", distance: 580, angle: 315));
    
    await Future.delayed(const Duration(milliseconds: 1200));
    scannedResponders.add(ResponderSignal(id: "p2", type: "police", distance: 450, angle: 110));
    
    isScanning.value = false;
  }

  void _generateMockSignals() {
    scannedResponders.addAll([
      ResponderSignal(id: "p1", type: "police", distance: 120, angle: 45),
      ResponderSignal(id: "h1", type: "helper", distance: 300, angle: 220),
    ]);
  }

  // legacy hotspots for old dashboard compatibility
  List<dynamic> get hotspots => safetyZones.where((z) => z.status == "Danger Zone").map((z) => {
    "id": z.id,
    "location": z.name,
    "safetyLevel": "High Risk",
    "incidentCount": 14,
    "color": Colors.red,
  }).toList();
  
  List<dynamic> get safeHavens => safetyZones.where((z) => z.status == "Safe Area").map((z) => {
    "id": z.id,
    "location": z.name,
    "safetyLevel": "Verified Hub",
    "responders": z.activeResponders,
    "color": Colors.green,
  }).toList();
}
