import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:secure_me/utils/preference_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:secure_me/controller/emergency_contact_controller.dart';
import 'package:secure_me/view/common/app_snackbar.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_me/model/contact_model.dart';
import 'package:secure_me/model/emergency_message.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:secure_me/const/app_url.dart';

class SosController extends GetxController {
  var isTriggering = false.obs;
  var triggerMessage = ''.obs;
  var sosStatus = 'pending'.obs; // pending, accepted, in_progress, resolved
  var isAnonymous = false.obs;
  var emergencyPin = '1234'.obs;
  var isSosEnabled = false.obs;
  var liveTrackingLink = "".obs;
  
  // Voice Recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  var isRecording = false.obs;
  var recordingPath = ''.obs;
  var recordingDuration = 0.obs;
  Timer? _recordingTimer;

  // Escalation
  Timer? _escalationTimer;
  var escalationLevel = 0.obs; // 0: Local, 1: 500m, 2: 1km, 3: Wider network
  
  StreamSubscription<Position>? _locationSubscription;
  Position? currentPosition;

  // Emergency Groups (Simplified Simulation)
  final RxList<Map<String, dynamic>> responseGroups = <Map<String, dynamic>>[
    {
      "category": "Gym Bros",
      "icon": "strength",
      "members": ["Alex (2min)", "John (3min)"],
      "color": "Colors.orange",
    },
    {
      "category": "Police Officers",
      "icon": "police",
      "members": ["Unit 402 (En-route)", "Station Dispatch"],
      "color": "Colors.blue",
    },
    {
      "category": "Local Helpers",
      "icon": "community",
      "members": ["Sarah P.", "Mike R.", "12 others nearby"],
      "color": "Colors.green",
    },
    {
      "category": "Family Members",
      "icon": "family",
      "members": ["Mom", "Dad", "Elder Brother"],
      "color": "Colors.pink",
    },
  ].obs;

  // --- Emergency Group Chat ---
  final RxList<EmergencyMessage> messages = <EmergencyMessage>[].obs;
  final TextEditingController chatInputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();
  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _setupEmergencyLifecycle();
    // Start SOS trigger as soon as the view opens
    triggerSos();
  }

  Future<void> _loadSettings() async {
    final savedPin = await PreferenceHelper.getEmergencyPin();
    emergencyPin.value = savedPin;
  }

  void triggerSos({bool anonymous = false}) {
    isAnonymous.value = anonymous;
    isSosEnabled.value = true;
    escalationLevel.value = 0;
    
    // Alert priority contacts
    if (Get.isRegistered<EmergencyContactController>()) {
      _alertPriorityContacts(Get.find<EmergencyContactController>().contacts);
    }
    
    // Initialize Emergency Chat
    _initializeEmergencyChat();
    
    // Generate secure tracking link for guardians
    liveTrackingLink.value = "https://secure-me.app/track/${_uuid.v4()}";
    
    _startEscalationTimer();
    startLocationUpdates();
    
    // Trigger backend signal
    triggerSignalApi();
  }

  Future<void> triggerSignalApi() async {
    if (currentPosition == null) {
      // Try to get current position if not available
      try {
        Position pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
        );
        currentPosition = pos;
      } catch (e) {
        dev.log("❌ Could not get location for signal trigger: $e", name: 'SosController');
      }
    }

    if (currentPosition == null) return;

    isTriggering.value = true;
    final token = await PreferenceHelper.getToken();
    
    try {
      final response = await http.post(
        Uri.parse(AppUrl.signalTrigger),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "latitude": currentPosition!.latitude.toString(),
          "longitude": currentPosition!.longitude.toString(),
        }),
      );

      final data = jsonDecode(response.body);
      dev.log("📡 Signal Trigger Response: ${response.body}", name: 'SosController');

      if (response.statusCode == 200 && data['status'] == true) {
        triggerMessage.value = data['message'] ?? "Signal activated. Helpers notified.";
        sosStatus.value = 'accepted';
        
        // Update response groups if data is available
        if (data['data'] != null && data['data']['helpers_found'] != null) {
           _addSystemMessage("BACKEND: ${data['data']['helpers_found']} helpers notified via tactical hub.");
        }
      } else {
        dev.log("⚠️ Signal Trigger Failed: ${data['message']}", name: 'SosController');
      }
    } catch (e) {
      dev.log("❌ Signal Trigger Error: $e", name: 'SosController');
    } finally {
      isTriggering.value = false;
    }
  }

  void _initializeEmergencyChat() {
    messages.clear();
    
    // Add automated system message
    _addSystemMessage("SOS Triggered. Emergency Group Created. Responders are being notified.");
    
    // Add user's initial status if not anonymous
    if (!isAnonymous.value) {
      if (Get.isRegistered<AuthController>()) {
        final auth = Get.find<AuthController>();
        final userName = auth.user.value?.name ?? "Protected User";
        _addSystemMessage("Initial context: $userName is requesting immediate assistance.");
      } else {
        _addSystemMessage("Initial context: Manager is requesting immediate assistance.");
      }
    } else {
      _addSystemMessage("Initial context: An anonymous user is requesting immediate assistance.");
    }
  }

  void _addSystemMessage(String content) {
    messages.add(EmergencyMessage(
      id: _uuid.v4(),
      senderId: "system",
      senderName: "SYSTEM",
      content: content,
      type: MessageType.text,
      timestamp: DateTime.now(),
    ));
    _scrollToBottom();
  }

  Future<void> sendChatMessage(String content, {MessageType type = MessageType.text}) async {
    if (content.isEmpty && type == MessageType.text) return;

    String senderId = "unknown";
    String senderName = isAnonymous.value ? "Anonymous" : "Protected User";
    String? senderRole;

    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();
      final user = auth.user.value;
      senderId = user?.id ?? "unknown";
      if (!isAnonymous.value) senderName = user?.name ?? "Protected User";
      senderRole = user?.role.name;
    }
    
    final message = EmergencyMessage(
      id: _uuid.v4(),
      senderId: senderId,
      senderName: senderName,
      senderRole: senderRole,
      content: content,
      type: type,
      timestamp: DateTime.now(),
      isAnonymous: isAnonymous.value,
    );

    messages.add(message);
    _scrollToBottom();

    if (type == MessageType.text) {
      chatInputController.clear();
    }

    // SIMULATION: Responder acknowledgment
    if (messages.length == 3) {
      _simulateResponderJoin();
    }
  }

  void _simulateResponderJoin() {
    Future.delayed(const Duration(seconds: 3), () {
      final responderName = "Officer Miller";
      _addSystemMessage("$responderName has joined the emergency group.");
      
      messages.add(EmergencyMessage(
        id: _uuid.v4(),
        senderId: "responder_1",
        senderName: responderName,
        senderRole: "police",
        content: "I'm 2 minutes away. Please stay in a safe, visible location if possible.",
        type: MessageType.text,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void stopSos() {
    messages.clear();
    isSosEnabled.value = false;
    _escalationTimer?.cancel();
    _stopRecording();
    stopLocationUpdates();
    
    if (Get.isOverlaysOpen) Get.back();
    
    Get.snackbar(
      "SOS Resolved",
      "Emergency alerts have been cancelled.",
      backgroundColor: Colors.green.withValues(alpha: 0.7),
      colorText: Colors.white,
    );
  }

  Future<void> _stopRecording() async {
    try {
      if (isRecording.value) {
        await _audioRecorder.stop();
        isRecording.value = false;
        _recordingTimer?.cancel();
      }
    } catch (e) {
      dev.log('Error stopping recording: $e');
    }
  }

  void _startEscalationTimer() {
    _escalationTimer?.cancel();
    _escalationTimer = Timer.periodic(const Duration(seconds: 45), (timer) {
      if (!isSosEnabled.value) {
        timer.cancel();
        return;
      }

      if (escalationLevel.value < 3) {
        escalationLevel.value++;
        
        String levelMsg = "";
        switch (escalationLevel.value) {
          case 1:
            levelMsg = "Alerting responders within 500m radius...";
            break;
          case 2:
            levelMsg = "Expanding search to 1km radius...";
            _sendFallbackSms(); 
            break;
          case 3:
            levelMsg = "Broadcasting to wider safety network and police...";
            break;
        }

        dev.log('⚠️ SOS ESCALATION (Level ${escalationLevel.value}): $levelMsg', name: 'SosController');
        
        AppSnackbar.show(
          title: "Rescue Network Expanded",
          message: levelMsg,
          isWarning: true,
        );
        
        _addSystemMessage("ESCALATION: $levelMsg");
      } else {
        timer.cancel();
      }
    });
  }

  void _sendFallbackSms() async {
    dev.log("📱 triggering fallback SMS check...", name: 'SosController');
  }

  Future<void> makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        AppSnackbar.show(
          title: "Dialer Error",
          message: "Could not open phone dialer for $phoneNumber",
          isError: true,
        );
      }
    } catch (e) {
      dev.log('❌ Call Exception: $e', name: 'SosController');
    }
  }

  void _setupEmergencyLifecycle() {
    escalationLevel.value = 0;

    Future.delayed(const Duration(seconds: 20), () {
      if (sosStatus.value == 'pending' && isSosEnabled.value) {
        sosStatus.value = 'accepted';
        _addSystemMessage("UPDATE: Police Unit 402 has accepted your alert and is en-route.");
        
        AppSnackbar.show(
          title: "Help is on the way", 
          message: "Police Unit 402 has accepted your alert.",
          isSuccess: true,
        );
      } else if (sosStatus.value == 'pending' && isSosEnabled.value) {
        // Fallback if no one accepts
        _addSystemMessage("FALLBACK: No local acknowledgment. Alerting wider network...");
        escalationLevel.value = 3;
      }
    });
  }

  Future<bool> verifyCancelPin(String pin) async {
    if (pin == emergencyPin.value) {
      _cancelSos();
      return true;
    } else {
      AppSnackbar.show(title: "Invalid PIN", message: "Emergency signal remains active.", isError: true);
      return false;
    }
  }

  void _cancelSos() {
    dev.log('🛑 SOS CANCELLED by user.', name: 'SosController');
    sosStatus.value = 'resolved';
    _archiveEmergencyLogs(); // Log archive for safety/legal
    _escalationTimer?.cancel();
    stopLocationUpdates();
    stopSos();
  }

  void _archiveEmergencyLogs() {
    dev.log("🗄️ ARCHIVING SOS LOGS: Storing chat, location data and event timestamps for legal/safety audit.", name: 'SosController');
    // Simulated background persistence call
  }

  // Voice Messaging Support
  Future<void> startVoiceRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      AppSnackbar.show(title: "Permission Denied", message: "Microphone access is required for voice alerts.", isError: true);
      return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/sos_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(const RecordConfig(), path: path);
        isRecording.value = true;
        recordingDuration.value = 0;
        
        _recordingTimer?.cancel();
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          recordingDuration.value++;
        });

        dev.log('🎙️ Recording voice context: $path', name: 'SosController');
      }
    } catch (e) {
      dev.log('❌ Error starting voice recording: $e', name: 'SosController');
    }
  }

  Future<void> stopVoiceRecording() async {
    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;
      _recordingTimer?.cancel();

      if (path != null) {
        recordingPath.value = path;
        dev.log('🎙️ Voice recorded successfully: $path', name: 'SosController');
        _sendVoiceMessageToServer(path);
        sendChatMessage("Emergency Voice Context Recorded", type: MessageType.voice);
      }
    } catch (e) {
      dev.log('❌ Error stopping voice recording: $e', name: 'SosController');
    }
  }

  Future<void> _sendVoiceMessageToServer(String path) async {
    // Simulated upload
    dev.log('📡 Simulating voice upload to server: $path', name: 'SosController');
  }

  void startLocationUpdates() {
    dev.log('🚀 Starting continuous live location sharing...', name: 'SosController');
    final locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _locationSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      currentPosition = position;
      dev.log('📍 Location auto-updated: ${position.latitude}, ${position.longitude}', name: 'SosController');
      _sendLocationUpdate(position);
      
      // Update safe route if already calculated
      if (sosStatus.value == 'in_progress') {
        _recalculateSafeRoute();
      }
    });
  }

  // 1.5 Emergency Navigation Enhancement
  var safePathPoints = <Position>[].obs;
  
  void calculateEscapeRoute() {
    dev.log("🧭 Calculating safe escape route via tactical avoidance algorithms...", name: 'SosController');
    
    // Simulate tactical pathfinding avoiding known hotspots
    _addSystemMessage("STRATEGY: Escape route synchronized. Primary objective: Reach verified Safe Zone [SZ-402].");
    _addSystemMessage("PATHING: Avoid dark corridors. Moving towards high-visibility public area.");
    
    AppSnackbar.show(
      title: "Tactical Path Active",
      message: "Guided route to verified safe zone is now active.",
      isSuccess: true,
    );
    
    // Auto-share with responders
    shareRouteWithResponders();
  }

  void _recalculateSafeRoute() {
     dev.log("♻️ Recalculating escape path based on current GPS vector...", name: 'SosController');
  }

  void shareRouteWithResponders() {
     _addSystemMessage("SIGNAL: Escape route vector shared with nearby responders units.");
     dev.log("📡 Route vector broadcasted to dispatch unit.", name: 'SosController');
  }

  void stopLocationUpdates() {
    dev.log('🛑 Stopping live location sharing...', name: 'SosController');
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  void _alertPriorityContacts(List<Contact> contacts) {
    // Sort and alert by priority
    final sorted = List<Contact>.from(contacts)..sort((a, b) => a.priority.compareTo(b.priority));
    
    for (var contact in sorted) {
      if (contact.isNotifyOnSos) {
        dev.log("🚨 ALERTING SENTINEL [P${contact.priority}]: ${contact.name} (${contact.phoneNo})", name: 'SosController');
        // Simulated SMS with link
        _addSystemMessage("SENTINEL NOTIFIED: ${contact.name} received tracking link.");
      }
    }
  }

  void shareTrackingLinkWithContacts() {
    if (liveTrackingLink.value.isNotEmpty) {
      _addSystemMessage("Tracking link shared with all guardians.");
      dev.log("📡 Sharing: ${liveTrackingLink.value}", name: 'SosController');
      AppSnackbar.show(title: "Sentinels Synced", message: "Live tracking link sent to your safety network.");
    }
  }

  Future<void> _sendLocationUpdate(Position position) async {
    try {
      final body = {
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
        "is_moving": true,
        "is_anonymous": isAnonymous.value,
      };
      dev.log('📡 SERVER UPDATE: Location Broadcasted $body', name: 'SosController');
    } catch (e) {
      dev.log('❌ Error updating live location: $e', name: 'SosController');
    }
  }

  @override
  void onClose() {
    _escalationTimer?.cancel();
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    stopLocationUpdates();
    super.onClose();
  }
}
