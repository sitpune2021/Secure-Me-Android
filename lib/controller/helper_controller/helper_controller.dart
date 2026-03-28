import 'package:get/get.dart';

class HelperController extends GetxController {
  // Availability status
  var isOnline = true.obs;
  
  // Tactical metrics
  var totalHelped = 12.obs;
  var successfulAssists = 10.obs;
  var pendingResponsesCount = 2.obs;

  // Active Help Signal
  var activeSignal = Rxn<HelperEmergencySignal>();
  
  // Case History
  var helpHistory = <HelperEmergencySignal>[
    HelperEmergencySignal(
      id: "SIG-888",
      victimName: "Rohit M.",
      distance: "400m",
      time: "1d ago",
      severity: "Medium",
      latitude: 18.5204,
      longitude: 73.8567,
      status: "Helped",
    ),
    HelperEmergencySignal(
      id: "SIG-887",
      victimName: "Sneha G.",
      distance: "1.5km",
      time: "3d ago",
      severity: "High",
      latitude: 18.5104,
      longitude: 73.8467,
      status: "Successful",
    ),
  ].obs;

  void toggleAvailability(bool status) {
    isOnline.value = status;
  }

  void acceptCase(HelperEmergencySignal signal) {
    activeSignal.value = signal;
    pendingResponsesCount.value = (pendingResponsesCount.value - 1).clamp(0, 100);
  }

  void completeHelp(bool success, String notes) {
    if (activeSignal.value != null) {
      final completedSignal = activeSignal.value!;
      helpHistory.insert(0, completedSignal); // In real app, update with success/notes
      activeSignal.value = null;
      if (success) {
        totalHelped.value++;
        successfulAssists.value++;
      } else {
        totalHelped.value++;
      }
    }
  }

  void declineCase() {
    activeSignal.value = null;
    pendingResponsesCount.value = (pendingResponsesCount.value - 1).clamp(0, 100);
  }
}

class HelperEmergencySignal {
  final String id;
  final String victimName;
  final String distance;
  final String time;
  final String severity;
  final double latitude;
  final double longitude;
  final String status; // 'Helped', 'Successful', 'Failed'
  final List<SupportInfo> responders;

  HelperEmergencySignal({
    required this.id,
    required this.victimName,
    required this.distance,
    required this.time,
    required this.severity,
    required this.latitude,
    required this.longitude,
    this.status = "Active",
    this.responders = const [],
  });
}

class SupportInfo {
  final String name;
  final String role; // 'Police', 'Helper'
  final String status; // 'on_way', 'reached'

  SupportInfo({
    required this.name,
    required this.role,
    required this.status,
  });
}
