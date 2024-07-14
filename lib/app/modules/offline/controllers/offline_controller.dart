import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
// import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:tflite_audio/tflite_audio.dart';
import 'package:volume_controller/volume_controller.dart';

class OfflineController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  double originalVolume = 0.5;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  var isModelRunning = false.obs;
  late StreamSubscription<Map<dynamic, dynamic>> _resultSubscription;

  @override
  void onInit() {
    super.onInit();
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
            // playSiren();
            _showFlushbar(
                "Dalam Bahaya", "Anda dalam keadaan darurat", "success");
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

  void playSiren() async {
    await setMaxVolume();
    await _audioPlayer.play(
      AssetSource('audios/siren-alarm.mp3'),
      volume: 1.0, // Set volume to maximum
    );
    isPlaying.value = true;
  }

  Future<void> setMaxVolume() async {
    VolumeController().maxVolume();
  }

  Future<void> getOriginalVolume() async {
    originalVolume = await VolumeController().getVolume();
  }

  void stopAlarm() async {
    await _audioPlayer.stop();
    VolumeController().setVolume(originalVolume);
    isPlaying.value = false;
    _startListening();
  }

  void toggleAlarm() {
    if (isPlaying.value) {
      stopAlarm();
    } else {
      playSiren();
      isPlaying.value = true;
    }
  }

  void listenToConnectivityChanges() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none)) {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  void _showFlushbar(String title, String message, String type) {
    Color bgColor = type == 'success'
        ? AppColors.green
        : type == 'err'
            ? AppColors.red
            : AppColors.white;
    Flushbar(
      title: title,
      titleColor: AppColors.white,
      message: message,
      messageColor: AppColors.white,
      duration: const Duration(seconds: 2),
      backgroundColor: bgColor,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(Get.context!);
  }
}
