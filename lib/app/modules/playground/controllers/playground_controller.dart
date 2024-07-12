import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PlaygroundController extends GetxController {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  var isRecording = false.obs;
  String? _filePath;

  @override
  void onInit() {
    super.onInit();
    // _recorder = FlutterSoundRecorder();
    // _player = FlutterSoundPlayer();
    // _initializeRecorder();
    // _initializePlayer();
  }

  void _initializeRecorder() async {
    try {
      await _recorder!.openRecorder();
      print("Recorder opened");
    } catch (error) {
      print("Failed to open recorder: $error");
    }
  }

  void _initializePlayer() async {
    try {
      await _player!.openPlayer();
      print("Player opened");
    } catch (error) {
      print("Failed to open player: $error");
    }
  }

  @override
  void onClose() {
    // _recorder?.closeRecorder();
    // _player?.closePlayer();
    // _recorder = null;
    // _player = null;
    super.onClose();
  }

  Future<void> startRecording() async {
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
      print("startRecording");
      Future.delayed(const Duration(seconds: 7), () async {
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
      print("stopRecording");
      isRecording.value = false;
      update();
    } catch (e) {
      print('Error stopping recorder: $e');
    }
  }

  Future<void> sendFileToApi(File file) async {
    print('Sending file to API: ${file.path}');
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://sindikat-pkm.com/api/upload/'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyMzExOTUxLCJpYXQiOjE3MjA3NzU5NTEsImp0aSI6ImRkZDVhNDIyNDIyZDRiMzI5ZmViM2M3ZGRkODJkZDgxIiwidXNlcl9pZCI6MX0.6LwEnA-6yqvbpAyn8m2qtQf4kY2epRvw4RWRwTUvkRQ';
      var response = await request.send();
      if (response.statusCode < 300) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending file to API: $e');
    }
  }

  void onRecordButtonPressed() {
    if (isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }
}
