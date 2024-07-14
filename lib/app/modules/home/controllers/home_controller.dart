import 'dart:async';
import 'dart:convert';

// import 'package:another_flushbar/flushbar.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/modules/settings/controllers/settings_controller.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tflite_audio/tflite_audio.dart';

class HomeController extends GetxController {
  // final stt.SpeechToText _speech = stt.SpeechToText();
  // final RxBool isListening = false.obs;
  // final String triggerPhrase = "cindy";
  // final count = 0.obs;

  var isPlaying = false.obs;
  double originalVolume = 0.5;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  var isModelRunning = false.obs;
  late StreamSubscription<Map<dynamic, dynamic>> _resultSubscription;

  final SettingsController settingsController = Get.put(SettingsController());

  @override
  void onInit() {
    super.onInit();
    // _initSpeech();
    // position = determinePosition() as Position?;
    TfliteAudio.loadModel(
      model: 'assets/soundclassifier_with_metadata.tflite',
      label: 'assets/labels.txt',
      inputType: 'rawAudio', // Add the required inputType parameter
      numThreads: 1,
      isAsset: true,
      outputRawScores: true,
    );
    listenToConnectivityChanges();
    _startListening();
  }

  @override
  void onClose() {
    // _speech.cancel();
    _connectivitySubscription.cancel();
    _resultSubscription.cancel();
    TfliteAudio.stopAudioRecognition();
    super.onClose();
  }

  void _startListening() {
    if (!isModelRunning.value) {
      isModelRunning.value = true;
      var resultStream = TfliteAudio.startAudioRecognition(
        sampleRate: 44100,
        bufferSize: 22016,
        audioLength: 44032,
        detectionThreshold: 0.95,
        numOfInferences: 5,
        method: 'setAudioRecognitionStream',
      );

      _resultSubscription = resultStream.listen((event) {
        String recognitionString = event["recognitionResult"].toString();
        List<dynamic> recognitionResult;

        try {
          recognitionResult = jsonDecode(recognitionString);
        } catch (e) {
          recognitionResult = [];
        }

        List<double> filteredResults = recognitionResult
            .where((value) => value is double && !value.isNaN)
            .toList()
            .cast<double>();

        if (filteredResults.isNotEmpty) {
          if (filteredResults[1] >= 0.95) {
            Map<String, dynamic> arguments = {
              'listHeartRate': settingsController.listHeartRate,
              // 'latitude': position?.latitude,
              // 'longitude': position?.longitude,
            };
            Get.delete<HomeController>();
            Get.offAllNamed(Routes.RECORD, arguments: arguments);
          }
        }
      });

      _resultSubscription.onDone(() {
        isModelRunning.value = false;
        if (isPlaying.value == false) {
          _startListening();
        }
      });
    }
  }

  void listenToConnectivityChanges() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none)) {
        Get.offAllNamed(Routes.NAVBAR);
      }
    });
  }

  // void _initSpeech() async {
  //   try {
  //     bool available = await _speech.initialize(
  //       onStatus: _onSpeechStatus,
  //       onError: _onSpeechError,
  //     );
  //     if (available) {
  //       isListening.value = true;
  //       _startListening();
  //     } else {
  //       _showFlushbar('Permission Denied',
  //           'Please allow permission to use this feature.');
  //     }
  //   } catch (e) {
  //     _showFlushbar(
  //         'Permission Denied', 'Please allow permission to use this feature.');
  //   }
  // }

  // void _onSpeechStatus(String status) {
  //   if (status == 'notListening' && isListening.value) {
  //     _startListening();
  //   }
  // }

  // void _onSpeechError(dynamic error) {
  //   if (isListening.value) {
  //     _startListening();
  //   }
  // }

  // void _startListening() {
  //   if (isListening.value && !_speech.isListening) {
  //     _speech.listen(
  //       onResult: (val) => _onSpeechResult(val.recognizedWords),
  //       localeId: "en_US",
  //     );
  //   }
  // }

  // void reInitSpeech() {
  //   _speech.cancel();
  // }

  // stopSpeech() {
  //   _speech.cancel();
  //   // _speech.stop();
  //   // isListening.value = false;
  // }

  // Future<void> _onSpeechResult(String recognizedWords) async {
  //   if (recognizedWords.toLowerCase().contains(triggerPhrase)) {
  //     _speech.cancel();
  //     try {
  //       Position position = await determinePosition();
  //       Map<String, dynamic> arguments = {
  //         'listHeartRate': settingsController.listHeartRate,
  //         'latitude': position.latitude,
  //         'longitude': position.longitude,
  //       };
  //       Get.offAllNamed(Routes.RECORD, arguments: arguments);
  //     } catch (e) {
  //       _showFlushbar('Error', e.toString());
  //     }
  //   }
  // }

  // void increment() => count.value++;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // void _showFlushbar(String title, String message) {
  //   Flushbar(
  //     title: title,
  //     titleColor: AppColors.white,
  //     message: message,
  //     messageColor: AppColors.white,
  //     duration: const Duration(seconds: 2),
  //     backgroundColor: AppColors.primaryColor,
  //     margin: const EdgeInsets.all(8),
  //     borderRadius: BorderRadius.circular(8),
  //     flushbarPosition: FlushbarPosition.TOP,
  //   ).show(Get.context!);
  // }
}
