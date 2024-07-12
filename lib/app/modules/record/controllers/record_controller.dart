import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;

class RecordController extends GetxController {
  final arguments = Get.arguments;
  FlutterSoundRecorder? _recorder;
  var isRecording = false.obs;
  String? _filePath;

  @override
  void onInit() {
    _recorder = FlutterSoundRecorder();
    _initializeRecorder();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _startRecording();
  }

  @override
  void onClose() {
    _recorder?.closeRecorder();
    _recorder = null;
    super.onClose();
  }

  void _initializeRecorder() async {
    try {
      await _recorder!.openRecorder();
    } catch (error) {
      print("Failed to open recorder: $error");
    }
  }

  Future<void> _startRecording() async {
    if (isRecording.value) return;

    Directory tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/audio.wav';

    try {
      await _recorder!.startRecorder(
        toFile: _filePath,
        codec: Codec.pcm16WAV,
      );
      isRecording.value = true;
      update();
      Future.delayed(const Duration(seconds: 4), () async {
        await stopRecording();
        await sendFileToApi(File(_filePath!));
      });
    } catch (e) {
      print('Error starting recorder: $e');
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      await _recorder!.stopRecorder();
      isRecording.value = false;
      update();
    } catch (e) {
      print('Error stopping recorder: $e');
    }
  }

  Future<void> sendFileToApi(File file) async {
    print('Sending file to API: ${file.path}');
    try {
      _showLoadingAnimation();
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://sindikat-pkm.com/api/upload/'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMzExOTUxLCJpYXQiOjE3MjA3NzU5NTEsImp0aSI6ImRkZDVhNDIyNDIyZDRiMzI5ZmViM2M3ZGRkODJkZDgxIiwidXNlcl9pZCI6MX0.6LwEnA-6yqvbpAyn8m2qtQf4kY2epRvw4RWRwTUvkRQ';
      var response = await request.send();
      if (response.statusCode < 300) {
        Get.offAllNamed(Routes.CALL_EMERGENCY);
      } else {
        print('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending file to API: $e');
    }
  }

  // void _startRecording() {
  //   // Simulate a 5-second recording
  //   Future.delayed(const Duration(seconds: 4), () {
  //     // Show a loading animation
  //     _showLoadingAnimation();
  //     // Navigate to the navbar after 5 seconds
  //     // Get.offAllNamed(Routes.NAVBAR);
  //   });
  // }

  void _showLoadingAnimation() {
    Get.dialog(
      Center(
        child: SizedBox(
          width: Get.width * 0.5,
          height: Get.width * 0.5,
          child: Lottie.asset(
            'assets/lottie/loading_audio.json', // Replace with your loading animation file
            fit: BoxFit.cover,
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // // Wait for 5 seconds then navigate to the emergency call screen
    // Future.delayed(const Duration(seconds: 5), () {
    //   Get.back(); // Close the loading dialog
    //   Get.offAllNamed(Routes.CALL_EMERGENCY);
    // });
  }
}
