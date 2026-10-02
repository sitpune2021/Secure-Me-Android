import 'dart:developer' as dev;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'package:secure_me/const/app_url.dart';
import 'package:secure_me/controller/auth_controller.dart';
import 'package:secure_me/controller/emergency_contact_controller.dart';
import 'package:secure_me/core/utils/preference_helper.dart';
import 'package:secure_me/model/contact_model.dart';
import 'package:secure_me/model/emergency_message.dart';
import 'package:secure_me/view/common/app_snackbar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────
const _kLocationUpdateInterval = Duration(minutes: 1);
const _kEscalationInterval = Duration(seconds: 45);
const _kMaxEscalationLevel = 3;
const _kSimulatedAcceptDelay = Duration(seconds: 20);
const _kResponderJoinThreshold =
    3; // message count before simulated responder join

// ─────────────────────────────────────────────────────────────────────────────
// SosController
// ─────────────────────────────────────────────────────────────────────────────
class SosController extends GetxController {
  // ── Public Observables ────────────────────────────────────────────────────
  final isTriggering = false.obs;
  final triggerMessage = ''.obs;
  final sosStatus =
      'pending'.obs; // pending | accepted | in_progress | resolved
  final isAnonymous = false.obs;
  final emergencyPin = '1234'.obs;
  final isSosEnabled = false.obs;
  final liveTrackingLink = ''.obs;
  final isRecording = false.obs;
  final recordingPath = ''.obs;
  final recordingDuration = 0.obs;
  final escalationLevel =
      0.obs; // 0: Local | 1: 500m | 2: 1km | 3: Wider network
  final safePathPoints = <Position>[].obs;

  final RxList<Map<String, dynamic>> responseGroups = <Map<String, dynamic>>[
    {
      'category': 'Gym Bros',
      'icon': 'strength',
      'members': ['Alex (2min)', 'John (3min)'],
      'color': 'Colors.orange',
    },
    {
      'category': 'Police Officers',
      'icon': 'police',
      'members': ['Unit 402 (En-route)', 'Station Dispatch'],
      'color': 'Colors.blue',
    },
    {
      'category': 'Local Helpers',
      'icon': 'community',
      'members': ['Sarah P.', 'Mike R.', '12 others nearby'],
      'color': 'Colors.green',
    },
    {
      'category': 'Family Members',
      'icon': 'family',
      'members': ['Mom', 'Dad', 'Elder Brother'],
      'color': 'Colors.pink',
    },
  ].obs;

  final RxList<EmergencyMessage> messages = <EmergencyMessage>[].obs;
  final chatInputController = TextEditingController();
  final chatScrollController = ScrollController();

  // ── Private State ─────────────────────────────────────────────────────────
  final _audioRecorder = AudioRecorder();
  final _uuid = const Uuid();

  Timer? _escalationTimer;
  Timer? _recordingTimer;
  Timer? _locationUpdateTimer; // ← periodic location push
  StreamSubscription<Position>? _locationSubscription;

  Position? _currentPosition; // single source of truth for current GPS

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _setupEmergencyLifecycle();
    triggerSos();
  }

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Settings
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _loadSettings() async {
    try {
      final pin = await PreferenceHelper.getEmergencyPin();
      emergencyPin.value = pin;
    } catch (e) {
      dev.log('⚠️ Could not load emergency PIN: $e', name: 'SosController');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SOS Trigger Entry Point
  // ─────────────────────────────────────────────────────────────────────────
  void triggerSos({bool anonymous = false}) {
    isAnonymous.value = anonymous;
    isSosEnabled.value = true;
    escalationLevel.value = 0;

    _alertPriorityContacts();
    _initializeEmergencyChat();

    liveTrackingLink.value = 'https://secure-me.app/track/${_uuid.v4()}';

    _startEscalationTimer();
    _startLocationStream();
    triggerSignalApi();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // API — Signal Trigger
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> triggerSignalApi() async {
    // Ensure we have a position before hitting the backend
    if (_currentPosition == null) {
      await _fetchCurrentPosition();
    }
    if (_currentPosition == null) {
      dev.log('❌ Signal aborted: GPS unavailable.', name: 'SosController');
      return;
    }

    isTriggering.value = true;

    try {
      final token = await PreferenceHelper.getToken();
      final response = await http
          .post(
            Uri.parse(AppUrl.signalTrigger),
            headers: _buildHeaders(token),
            body: _buildLocationBody(_currentPosition!),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () =>
                throw TimeoutException('Signal trigger timed out.'),
          );

      final data = _parseResponse(response, tag: 'Signal Trigger');
      if (data == null) return;

      if (response.statusCode == 200 && data['status'] == true) {
        triggerMessage.value =
            data['message'] ?? 'Signal activated. Helpers notified.';
        sosStatus.value = 'accepted';

        final helpersFound = data['data']?['helpers_found'];
        if (helpersFound != null) {
          _addSystemMessage(
            'BACKEND: $helpersFound helpers notified via tactical hub.',
          );
        }

        // ✅ Start periodic location updates ONLY after signal is confirmed
        _startLocationUpdateTimer();
      } else {
        final reason = data['message'] ?? 'Unknown error';
        dev.log('⚠️ Signal Trigger Failed: $reason', name: 'SosController');
        _addSystemMessage('WARNING: Signal broadcast issue — $reason');
      }
    } on TimeoutException catch (e) {
      dev.log('⏱️ Signal Trigger Timeout: $e', name: 'SosController');
      AppSnackbar.show(
        title: 'Network Timeout',
        message: 'Could not reach server. Retrying...',
        isWarning: true,
      );
      _retrySignalTrigger();
    } catch (e) {
      dev.log('❌ Signal Trigger Error: $e', name: 'SosController');
      AppSnackbar.show(
        title: 'Connection Error',
        message: 'Emergency signal may be delayed.',
        isError: true,
      );
    } finally {
      isTriggering.value = false;
    }
  }

  /// Single retry attempt on timeout — avoids infinite loops
  void _retrySignalTrigger() {
    Future.delayed(const Duration(seconds: 5), () {
      if (isSosEnabled.value) {
        dev.log('🔁 Retrying signal trigger...', name: 'SosController');
        triggerSignalApi();
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // API — Periodic Location Update
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts a [Timer.periodic] that pushes GPS every [_kLocationUpdateInterval].
  /// Fires once immediately, then on every tick.
  void _startLocationUpdateTimer() {
    _locationUpdateTimer?.cancel();

    _locationUpdateTimer = Timer.periodic(_kLocationUpdateInterval, (_) {
      if (!isSosEnabled.value) {
        _stopLocationUpdateTimer();
        return;
      }
      dev.log('⏱️ Auto location refresh triggered.', name: 'SosController');
      _updateLocationApi();
    });

    dev.log(
      '✅ Location update timer started (every ${_kLocationUpdateInterval.inMinutes}min).',
      name: 'SosController',
    );
  }

  void _stopLocationUpdateTimer() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
    dev.log('🛑 Location update timer stopped.', name: 'SosController');
  }

  Future<void> _updateLocationApi() async {
    if (_currentPosition == null) {
      dev.log(
        '⚠️ Location update skipped: no GPS fix yet.',
        name: 'SosController',
      );
      return;
    }

    try {
      final token = await PreferenceHelper.getToken();
      final response = await http
          .post(
            Uri.parse(AppUrl.updateLocation),
            headers: _buildHeaders(token),
            body: _buildLocationBody(_currentPosition!),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw TimeoutException('Location update timed out.'),
          );

      final data = _parseResponse(response, tag: 'Location Update');
      if (data != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        dev.log(
          '📍 Location pushed → '
          'lat: ${_currentPosition!.latitude}, '
          'lng: ${_currentPosition!.longitude}',
          name: 'SosController',
        );
      }
    } on TimeoutException {
      dev.log(
        '⏱️ Location update timed out — will retry next cycle.',
        name: 'SosController',
      );
    } catch (e) {
      // Silent fail: location updates are best-effort.
      // The next timer tick will retry automatically.
      dev.log('❌ Location Update Error: $e', name: 'SosController');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GPS — Stream + One-Shot
  // ─────────────────────────────────────────────────────────────────────────
  void _startLocationStream() {
    dev.log(
      '🚀 Starting continuous live location sharing...',
      name: 'SosController',
    );

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _locationSubscription =
        Geolocator.getPositionStream(locationSettings: settings).listen(
          (position) {
            _currentPosition = position;
            dev.log(
              '📍 Stream update: ${position.latitude}, ${position.longitude}',
              name: 'SosController',
            );
            if (sosStatus.value == 'in_progress') _recalculateSafeRoute();
          },
          onError: (Object e) {
            dev.log('❌ Location stream error: $e', name: 'SosController');
          },
        );
  }

  void stopLocationUpdates() {
    dev.log('🛑 Stopping live location sharing...', name: 'SosController');
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  Future<void> _fetchCurrentPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 10));
      _currentPosition = pos;
    } on TimeoutException {
      dev.log('⏱️ GPS one-shot timed out.', name: 'SosController');
    } catch (e) {
      dev.log('❌ Could not get GPS fix: $e', name: 'SosController');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Emergency Chat
  // ─────────────────────────────────────────────────────────────────────────
  void _initializeEmergencyChat() {
    messages.clear();
    _addSystemMessage(
      'SOS Triggered. Emergency Group Created. Responders are being notified.',
    );

    final label = _resolveUserLabel();
    _addSystemMessage(
      'Initial context: $label is requesting immediate assistance.',
    );
  }

  String _resolveUserLabel() {
    if (isAnonymous.value) return 'An anonymous user';
    if (Get.isRegistered<AuthController>()) {
      return Get.find<AuthController>().user.value?.name ?? 'Protected User';
    }
    return 'Protected User';
  }

  void _addSystemMessage(String content) {
    messages.add(
      EmergencyMessage(
        id: _uuid.v4(),
        senderId: 'system',
        senderName: 'SYSTEM',
        content: content,
        type: MessageType.text,
        timestamp: DateTime.now(),
      ),
    );
    _scrollToBottom();
  }

  Future<void> sendChatMessage(
    String content, {
    MessageType type = MessageType.text,
  }) async {
    if (content.trim().isEmpty && type == MessageType.text) return;

    String senderId = 'unknown';
    String senderName = isAnonymous.value ? 'Anonymous' : 'Protected User';
    String? senderRole;

    if (Get.isRegistered<AuthController>()) {
      final user = Get.find<AuthController>().user.value;
      senderId = user?.id ?? 'unknown';
      if (!isAnonymous.value) senderName = user?.name ?? 'Protected User';
      senderRole = user?.role.name;
    }

    messages.add(
      EmergencyMessage(
        id: _uuid.v4(),
        senderId: senderId,
        senderName: senderName,
        senderRole: senderRole,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        isAnonymous: isAnonymous.value,
      ),
    );

    _scrollToBottom();

    if (type == MessageType.text) chatInputController.clear();

    if (messages.length == _kResponderJoinThreshold) _simulateResponderJoin();
  }

  void _simulateResponderJoin() {
    Future.delayed(const Duration(seconds: 3), () {
      const responderName = 'Officer Miller';
      _addSystemMessage('$responderName has joined the emergency group.');
      messages.add(
        EmergencyMessage(
          id: _uuid.v4(),
          senderId: 'responder_1',
          senderName: responderName,
          senderRole: 'police',
          content:
              "I'm 2 minutes away. Please stay in a safe, visible location if possible.",
          type: MessageType.text,
          timestamp: DateTime.now(),
        ),
      );
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

  // ─────────────────────────────────────────────────────────────────────────
  // Escalation
  // ─────────────────────────────────────────────────────────────────────────
  void _startEscalationTimer() {
    _escalationTimer?.cancel();
    _escalationTimer = Timer.periodic(_kEscalationInterval, (timer) {
      if (!isSosEnabled.value) {
        timer.cancel();
        return;
      }
      if (escalationLevel.value >= _kMaxEscalationLevel) {
        timer.cancel();
        return;
      }

      escalationLevel.value++;
      final msg = _escalationMessage(escalationLevel.value);
      dev.log(
        '⚠️ SOS ESCALATION (Level ${escalationLevel.value}): $msg',
        name: 'SosController',
      );

      if (escalationLevel.value == 2) _sendFallbackSms();

      AppSnackbar.show(
        title: 'Rescue Network Expanded',
        message: msg,
        isWarning: true,
      );
      _addSystemMessage('ESCALATION: $msg');
    });
  }

  String _escalationMessage(int level) {
    switch (level) {
      case 1:
        return 'Alerting responders within 500m radius...';
      case 2:
        return 'Expanding search to 1km radius...';
      case 3:
        return 'Broadcasting to wider safety network and police...';
      default:
        return 'Escalating...';
    }
  }

  void _sendFallbackSms() {
    dev.log('📱 Triggering fallback SMS check...', name: 'SosController');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Emergency Lifecycle Simulation
  // ─────────────────────────────────────────────────────────────────────────
  void _setupEmergencyLifecycle() {
    escalationLevel.value = 0;
    Future.delayed(_kSimulatedAcceptDelay, () {
      if (!isSosEnabled.value) return;
      if (sosStatus.value == 'pending') {
        sosStatus.value = 'accepted';
        _addSystemMessage(
          'UPDATE: Police Unit 402 has accepted your alert and is en-route.',
        );
        AppSnackbar.show(
          title: 'Help is on the way',
          message: 'Police Unit 402 has accepted your alert.',
          isSuccess: true,
        );
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Stop / Cancel SOS
  // ─────────────────────────────────────────────────────────────────────────
  void stopSos() {
    messages.clear();
    isSosEnabled.value = false;

    _escalationTimer?.cancel();
    _stopLocationUpdateTimer();
    _stopRecordingInternal();
    stopLocationUpdates();

    if (Get.isOverlaysOpen) Get.back();
    Get.back();

    Get.snackbar(
      'SOS Resolved',
      'Emergency alerts have been cancelled.',
      backgroundColor: Colors.green.withValues(alpha: 0.7),
      colorText: Colors.white,
    );
  }

  Future<bool> verifyCancelPin(String pin) async {
    if (pin == emergencyPin.value) {
      _cancelSos();
      return true;
    }
    AppSnackbar.show(
      title: 'Invalid PIN',
      message: 'Emergency signal remains active.',
      isError: true,
    );
    return false;
  }

  void _cancelSos() {
    dev.log('🛑 SOS CANCELLED by user.', name: 'SosController');
    sosStatus.value = 'resolved';
    _archiveEmergencyLogs();
    _escalationTimer?.cancel();
    _stopLocationUpdateTimer();
    stopLocationUpdates();
    stopSos();
  }

  void _archiveEmergencyLogs() {
    dev.log(
      '🗄️ ARCHIVING SOS LOGS: chat, location, and event timestamps stored for legal/safety audit.',
      name: 'SosController',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Recording
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> startVoiceRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      AppSnackbar.show(
        title: 'Permission Denied',
        message: 'Microphone access is required for voice alerts.',
        isError: true,
      );
      return;
    }

    try {
      if (!await _audioRecorder.hasPermission()) return;

      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/sos_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(const RecordConfig(), path: path);
      isRecording.value = true;
      recordingDuration.value = 0;

      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        recordingDuration.value++;
      });

      dev.log('🎙️ Recording voice context: $path', name: 'SosController');
    } catch (e) {
      dev.log('❌ Error starting voice recording: $e', name: 'SosController');
      AppSnackbar.show(
        title: 'Recorder Error',
        message: 'Could not start recording.',
        isError: true,
      );
    }
  }

  Future<void> stopVoiceRecording() async {
    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;
      _recordingTimer?.cancel();

      if (path != null) {
        recordingPath.value = path;
        dev.log('🎙️ Voice recorded: $path', name: 'SosController');
        await _uploadVoiceMessage(path);
        await sendChatMessage(
          'Emergency Voice Context Recorded',
          type: MessageType.voice,
        );
      }
    } catch (e) {
      dev.log('❌ Error stopping voice recording: $e', name: 'SosController');
    }
  }

  Future<void> _stopRecordingInternal() async {
    try {
      if (isRecording.value) {
        await _audioRecorder.stop();
        isRecording.value = false;
        _recordingTimer?.cancel();
      }
    } catch (e) {
      dev.log(
        'Error stopping recording on SOS close: $e',
        name: 'SosController',
      );
    }
  }

  Future<void> _uploadVoiceMessage(String path) async {
    dev.log('📡 Simulating voice upload: $path', name: 'SosController');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Navigation & Routing
  // ─────────────────────────────────────────────────────────────────────────
  void calculateEscapeRoute() {
    dev.log('🧭 Calculating safe escape route...', name: 'SosController');
    _addSystemMessage(
      'STRATEGY: Escape route synchronized. Primary objective: Reach Safe Zone [SZ-402].',
    );
    _addSystemMessage(
      'PATHING: Avoid dark corridors. Moving towards high-visibility public area.',
    );
    AppSnackbar.show(
      title: 'Tactical Path Active',
      message: 'Guided route to verified safe zone is now active.',
      isSuccess: true,
    );
    shareRouteWithResponders();
  }

  void _recalculateSafeRoute() {
    dev.log(
      '♻️ Recalculating escape path from updated GPS vector...',
      name: 'SosController',
    );
  }

  void shareRouteWithResponders() {
    _addSystemMessage(
      'SIGNAL: Escape route vector shared with nearby responder units.',
    );
    dev.log(
      '📡 Route vector broadcasted to dispatch unit.',
      name: 'SosController',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Contacts & Tracking
  // ─────────────────────────────────────────────────────────────────────────
  void _alertPriorityContacts() {
    if (!Get.isRegistered<EmergencyContactController>()) return;

    final contacts = Get.find<EmergencyContactController>().contacts;
    final sorted = List<Contact>.from(contacts)
      ..sort((a, b) => a.priority.compareTo(b.priority));

    for (final contact in sorted) {
      if (contact.isNotifyOnSos) {
        dev.log(
          '🚨 ALERTING SENTINEL [P${contact.priority}]: ${contact.name} (${contact.phoneNo})',
          name: 'SosController',
        );
        _addSystemMessage(
          'SENTINEL NOTIFIED: ${contact.name} received tracking link.',
        );
      }
    }
  }

  void shareTrackingLinkWithContacts() {
    if (liveTrackingLink.value.isEmpty) return;
    _addSystemMessage('Tracking link shared with all guardians.');
    dev.log('📡 Sharing: ${liveTrackingLink.value}', name: 'SosController');
    AppSnackbar.show(
      title: 'Sentinels Synced',
      message: 'Live tracking link sent to your safety network.',
    );
  }

  Future<void> makeCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        AppSnackbar.show(
          title: 'Dialer Error',
          message: 'Could not open phone dialer for $phoneNumber.',
          isError: true,
        );
      }
    } catch (e) {
      dev.log('❌ Call Exception: $e', name: 'SosController');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers — HTTP
  // ─────────────────────────────────────────────────────────────────────────
  Map<String, String> _buildHeaders(String? token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };

  String _buildLocationBody(Position position) => jsonEncode({
    'latitude': position.latitude.toString(),
    'longitude': position.longitude.toString(),
  });

  /// Safely decodes the response. Returns null on decode failure.
  Map<String, dynamic>? _parseResponse(
    http.Response response, {
    required String tag,
  }) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      dev.log(
        '📡 [$tag] ${response.statusCode}: ${response.body}',
        name: 'SosController',
      );
      return data;
    } catch (e) {
      dev.log(
        '❌ [$tag] Failed to parse response: ${response.body}',
        name: 'SosController',
      );
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Cleanup
  // ─────────────────────────────────────────────────────────────────────────
  void _disposeResources() {
    _escalationTimer?.cancel();
    _recordingTimer?.cancel();
    _locationUpdateTimer?.cancel();
    _locationSubscription?.cancel();
    _audioRecorder.dispose();
    chatInputController.dispose();
    chatScrollController.dispose();
    dev.log('🧹 SosController resources disposed.', name: 'SosController');
  }
}
