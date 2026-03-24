import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class VoiceController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  var isListening = false.obs;
  var speechText = "".obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => dev.log('Speech Status: $status', name: "VoiceController"),
      onError: (error) => dev.log('Speech Error: $error', name: "VoiceController"),
    );
    if (!available) {
      dev.log("Speech mapping error: initialized but not available", name: "VoiceController");
    }
  }

  Future<void> startListening() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) return;

    if (!isListening.value) {
      isListening.value = true;
      _speech.listen(
        onResult: (result) {
          speechText.value = result.recognizedWords;
          if (result.finalResult) {
            isListening.value = false;
            _handleCommand(speechText.value);
          }
        },
      );
    }
  }

  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  void _handleCommand(String text) {
    dev.log("🎤 Voice Command Received: $text", name: "VoiceController");
    
    if (text.toLowerCase().contains("help") || text.toLowerCase().contains("sos")) {
      // Trigger SOS via another controller if necessary or navigate
      Get.snackbar("Voice Command", "SOS Trigger recognized from voice!", 
        backgroundColor: Get.theme.colorScheme.error, 
        colorText: Get.theme.colorScheme.onError
      );
    }
    
    // Logic to update address or unknowns via voice can go here
  }
}
