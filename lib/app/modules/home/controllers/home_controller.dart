import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sindikat_app/app/constans/colors.dart';

import 'package:sindikat_app/app/modules/settings/controllers/settings_controller.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

import 'package:tflite_audio/tflite_audio.dart';

class HomeController extends GetxController {
  final getStorage = GetStorage();
  var user = {}.obs;
  var isPlaying = false.obs;
  double originalVolume = 0.5;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  var isModelRunning = false.obs;
  late StreamSubscription<Map<dynamic, dynamic>> _resultSubscription;

  final SettingsController settingsController = Get.put(SettingsController());

  @override
  void onInit() {
    super.onInit();
    user.value = getStorage.read('user');
    TfliteAudio.loadModel(
      model: 'assets/soundclassifier_with_metadata.tflite',
      label: 'assets/labels.txt',
      inputType: 'rawAudio',
      numThreads: 1,
      isAsset: true,
      outputRawScores: true,
    );
    listenToConnectivityChanges();
    _startListening();
  }

  @override
  void onClose() {
    _resultSubscription.cancel();
    TfliteAudio.stopAudioRecognition();
    _connectivitySubscription.cancel();
    super.onClose();
  }

  void _startListening() {
    if (!isModelRunning.value) {
      isModelRunning.value = true;
      var resultStream = TfliteAudio.startAudioRecognition(
        sampleRate: 44100,
        bufferSize: 22016,
        audioLength: 44032,
        detectionThreshold: 0.85,
        numOfInferences: 5,
        method: 'setAudioRecognitionStream',
      );

      _resultSubscription = resultStream.listen((event) async {
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
          if (filteredResults[1] >= 0.85) {
            Position position;
            try {
              position = await determinePosition();
            } catch (e) {
              return;
            }

            var googleMapLink =
                "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

            Map<String, dynamic> arguments = {
              'listHeartRate': settingsController.listHeartRate,
              'location': googleMapLink,
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

  void relisten() {
    isModelRunning.value = false;
    _startListening();
  }

  void listenToConnectivityChanges() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.any((result) => result == ConnectivityResult.none)) {
        _stopListening();
      } else {
        if (!isModelRunning.value) {
          _startListening();
        }
      }
    });
  }

  void _showFlushbar(String title, String message, String type) {
    Color bgColor = type == 'success'
        ? AppColors.secondaryColor
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

  void _stopListening() {
    _showFlushbar('Offline', 'You are offline', 'err');
    if (isModelRunning.value) {
      print('stop listening 2');
      _resultSubscription.cancel();
      TfliteAudio.stopAudioRecognition();
      isModelRunning.value = false;
      _showFlushbar('Offline', 'You are offline', 'err');
      // // Get.delete(force: true);
      // Future.delayed(const Duration(seconds: 2), () {
      Get.delete<HomeController>();
      Get.delete<SettingsController>();
      Get.offAllNamed(Routes.OFFLINE, arguments: "home");
      // });
    }
  }

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
}
