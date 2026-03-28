import 'package:get/get.dart';

class PoliceController extends GetxController {
  // Availability status
  var isOnline = true.obs;
  
  // Tactical metrics
  var activeCasesCount = 0.obs;
  var resolvedCasesCount = 12.obs;
  var pendingResponsesCount = 1.obs;

  // Active Emergency Signal
  var activeSignal = Rxn<EmergencySignal>();
  
  // Case History
  var caseHistory = <EmergencySignal>[
    EmergencySignal(
      id: "SIG-999",
      victimName: "John Doe",
      distance: "1.2 km",
      time: "2h ago",
      severity: "Medium",
      latitude: 18.5204,
      longitude: 73.8567,
    ),
    EmergencySignal(
      id: "SIG-998",
      victimName: "Jane Smith",
      distance: "3.5 km",
      time: "5h ago",
      severity: "High",
      latitude: 18.5104,
      longitude: 73.8467,
    ),
  ].obs;

  void toggleAvailability(bool status) {
    isOnline.value = status;
  }

  void acceptCase(EmergencySignal signal) {
    activeSignal.value = signal;
    activeCasesCount.value++;
    pendingResponsesCount.value = (pendingResponsesCount.value - 1).clamp(0, 100);
    // Logic to notify backend and group
  }

  void resolveCase(String notes) {
    if (activeSignal.value != null) {
      final resolvedSignal = activeSignal.value!;
      caseHistory.insert(0, resolvedSignal);
      activeSignal.value = null;
      activeCasesCount.value = (activeCasesCount.value - 1).clamp(0, 100);
      resolvedCasesCount.value++;
      // Logic to save notes and notify backend
    }
  }

  void declineCase() {
    activeSignal.value = null;
    pendingResponsesCount.value = (pendingResponsesCount.value - 1).clamp(0, 100);
  }
}

class EmergencySignal {
  final String id;
  final String victimName;
  final String distance;
  final String time;
  final String severity;
  final double latitude;
  final double longitude;
  final List<HelperInfo> helpers;

  EmergencySignal({
    required this.id,
    required this.victimName,
    required this.distance,
    required this.time,
    required this.severity,
    required this.latitude,
    required this.longitude,
    this.helpers = const [],
  });
}

class HelperInfo {
  final String name;
  final String status; // 'accepted', 'declined', 'on_way', 'reached'
  final String role; // 'Gym Person', 'Civilian'

  HelperInfo({
    required this.name,
    required this.status,
    required this.role,
  });
}
