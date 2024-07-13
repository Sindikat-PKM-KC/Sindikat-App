import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:volume_controller/volume_controller.dart';

class OfflineController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = true.obs;
  double originalVolume = 0.5;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    listenToConnectivityChanges();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  void playSiren() async {
    await setMaxVolume();
    await _audioPlayer.play(
      AssetSource('audios/siren-alarm.mp3'),
      volume: 1.0, // Set volume to maximum
    );
  }

  Future<void> setMaxVolume() async {
    originalVolume = await VolumeController().getVolume();
    VolumeController().maxVolume();
  }

  void stopAlarm() async {
    await _audioPlayer.stop();
    VolumeController().setVolume(originalVolume);
    isPlaying.value = false;
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
}
