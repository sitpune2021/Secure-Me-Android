import 'package:get/get.dart';
import 'package:secure_me/model/signal_model.dart';
import 'dart:async';

class SafetyController extends GetxController {
  final Rx<SignalStatus> status = SignalStatus.pending.obs;
  final Rx<SignalStage> stage = SignalStage.stage1.obs;
  final RxList<String> responderIds = <String>[].obs;
  final Rx<LocationModel?> victimLocation = Rx<LocationModel?>(null);
  final RxString activeSignalId = "".obs;

  Timer? _stageTimer;

  void activateEmergency(LocationModel location) {
    status.value = SignalStatus.sent;
    stage.value = SignalStage.stage1;
    victimLocation.value = location;
    activeSignalId.value = 'sig_${DateTime.now().millisecondsSinceEpoch}';
    responderIds.clear();

    // Simulate Stage 2 after 15 seconds
    _stageTimer?.cancel();
    _stageTimer = Timer(const Duration(seconds: 15), () {
      stage.value = SignalStage.stage2;
    });

    _simulateResponders();
  }

  void cancelEmergency() {
    _stageTimer?.cancel();
    status.value = SignalStatus.pending;
    stage.value = SignalStage.stage1;
    responderIds.clear();
    victimLocation.value = null;
    activeSignalId.value = "";
  }

  void acceptEmergency(String helperId) {
    if (!responderIds.contains(helperId)) {
      responderIds.add(helperId);
    }
  }

  void _simulateResponders() {
    Future.delayed(const Duration(seconds: 5), () {
      if (status.value == SignalStatus.sent) {
        responderIds.assignAll(['helper1', 'helper2']);
      }
    });

    Future.delayed(const Duration(seconds: 10), () {
       if (status.value == SignalStatus.sent) {
        responderIds.assignAll(['helper1', 'helper2', 'helper3', 'police1']);
      }
    });
  }

  @override
  void onClose() {
    _stageTimer?.cancel();
    super.onClose();
  }
}
