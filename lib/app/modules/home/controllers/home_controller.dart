import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxBool isListening = false.obs;
  final String triggerPhrase = "cindy";
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // _initSpeech();
  }

  @override
  void onClose() {
    _speech.stop();
    super.onClose();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
    if (available) {
      isListening.value = true;
      _startListening();
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void _onSpeechStatus(String status) {
    print('onStatus: $status');
    if (status == 'notListening' && isListening.value) {
      _startListening();
    }
  }

  void _onSpeechError(dynamic error) {
    print('onError: $error');
    if (isListening.value) {
      Future.delayed(const Duration(seconds: 1),
          _startListening); // Retry listening after a delay
    }
  }

  void _startListening() {
    if (isListening.value && !_speech.isListening) {
      _speech.listen(
        onResult: (val) => _onSpeechResult(val.recognizedWords),
        localeId: "en_US",
      );
    }
  }

  void _onSpeechResult(String recognizedWords) {
    print("Recognized words: $recognizedWords");
    if (recognizedWords.toLowerCase().contains(triggerPhrase)) {
      print("Sindikat Called");
      Flushbar(
        title: "Sindikat Called",
        message: "Sindikat Called",
        duration: const Duration(seconds: 1),
      ).show(Get.context!);
    }
  }

  void increment() => count.value++;
}
