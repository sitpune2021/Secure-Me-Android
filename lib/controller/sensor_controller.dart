import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_me/controller/safety_controller.dart';
import 'package:secure_me/model/signal_model.dart';
import 'dart:math';
import 'dart:async';


class SensorController extends GetxController {
  final SafetyController _safetyController = Get.find<SafetyController>();
  
  // Real app: use sensors_plus library for accelerometer data
  // This is a simulation for Advanced SOS Triggering
  
  final RxDouble gForce = 1.0.obs;
  final RxBool fallDetected = false.obs;
  
  Timer? _sensorSimulationTimer;

  void startMonitoring() {
    _sensorSimulationTimer?.cancel();
    _sensorSimulationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _simulateSensorData();
    });
  }

  void _simulateSensorData() {
    // Regular data fluctuation
    gForce.value = 1.0 + (Random().nextDouble() * 0.2);
    
    // Random chance of simulating a fall (e.g., 0.5% chance per second for demo)
    if (Random().nextDouble() < 0.005 && !_safetyController.isSignalActive()) {
      _handleFallDetection();
    }
  }

  void _handleFallDetection() {
    fallDetected.value = true;
    gForce.value = 5.6; // High impact simulation
    
    Get.snackbar(
      "SMART SAFETY", 
      "Sudden impact detected! Triggering SOS in 5 seconds if no response...",
      duration: const Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () { 
          fallDetected.value = false;
          Get.back();
        }, 
        child: const Text("I'M OK")
      ),
      onTap: (_) {
         fallDetected.value = false;
      }
    );

    // Auto-trigger if not cancelled
    Future.delayed(const Duration(seconds: 5), () {
      if (fallDetected.value && !_safetyController.isSignalActive()) {
        _safetyController.activateEmergency(const LocationModel(latitude: 37.7749, longitude: -122.4194, address: "AUTO-DETECTED FALL"));
        fallDetected.value = false;
      }
    });
  }

  @override
  void onClose() {
    _sensorSimulationTimer?.cancel();
    super.onClose();
  }
}
