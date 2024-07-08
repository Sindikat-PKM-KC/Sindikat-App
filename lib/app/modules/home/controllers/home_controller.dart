import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
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
    _speech.cancel();
    super.onClose();
  }

  void _initSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );
      if (available) {
        isListening.value = true;
        _startListening();
      } else {
        Flushbar(
          title: 'Permission Denied',
          titleColor: AppColors.white,
          message: 'Please allow permission to use this feature.',
          messageColor: AppColors.white,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primaryColor,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(Get.context!);
      }
    } catch (e) {
      Flushbar(
        title: 'Permission Denied',
        titleColor: AppColors.white,
        message: 'Please allow permission to use this feature.',
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }

  void _onSpeechStatus(String status) {
    if (status == 'notListening' && isListening.value) {
      _startListening();
    }
  }

  void _onSpeechError(dynamic error) {
    if (isListening.value) {
      _startListening();
    }
  }

  void _startListening() {
    if (isListening.value && !_speech.isListening) {
      _speech.listen(
        onResult: (val) => _onSpeechResult(val.recognizedWords),
        localeId: "en_US",

        // onSoundLevelChange: null,
      );
    }
  }

  void reInitSpeech() {
    _speech.cancel();
  }

  void _onSpeechResult(String recognizedWords) {
    if (recognizedWords.toLowerCase().contains(triggerPhrase)) {
      _speech.cancel();
      Get.offAllNamed(Routes.RECORD);
    }
  }

  void increment() => count.value++;
}
