import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/constans/url.dart';
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
    } catch (e) {
      Flushbar(
        title: 'Error',
        titleColor: AppColors.white,
        message: e.toString(),
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
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
      Flushbar(
        title: 'Error',
        titleColor: AppColors.white,
        message: e.toString(),
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      await _recorder!.stopRecorder();
      isRecording.value = false;
      update();
    } catch (e) {
      Flushbar(
        title: 'Error',
        titleColor: AppColors.white,
        message: e.toString(),
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }

  Future<void> sendFileToApi(File file) async {
    _showLoadingAnimation();
    Get.offAllNamed(Routes.CALL_EMERGENCY);
    // try {
    //   final token = GetStorage().read('access_token');
    //   var url = Uri.parse('${UrlApi.baseAPI}/audios/upload/');
    //   var request = http.MultipartRequest('POST', url);
    //   request.files.add(await http.MultipartFile.fromPath('file', file.path));
    //   request.fields['location'] = arguments['location'];
    //   request.headers['Authorization'] = 'Bearer $token';
    //   var response = await request.send();
    //   if (response.statusCode < 300) {
    //   } else {
    //     await Flushbar(
    //       title: 'Error',
    //       titleColor: AppColors.white,
    //       message: response.reasonPhrase,
    //       messageColor: AppColors.white,
    //       duration: const Duration(seconds: 2),
    //       backgroundColor: AppColors.primaryColor,
    //       margin: const EdgeInsets.all(8),
    //       borderRadius: BorderRadius.circular(8),
    //       flushbarPosition: FlushbarPosition.TOP,
    //     ).show(Get.context!);
    //     await Get.offAllNamed(Routes.NAVBAR);
    //   }
    // } catch (e) {
    //   await Flushbar(
    //     title: 'Error',
    //     titleColor: AppColors.white,
    //     message: e.toString(),
    //     messageColor: AppColors.white,
    //     duration: const Duration(seconds: 2),
    //     backgroundColor: AppColors.primaryColor,
    //     margin: const EdgeInsets.all(8),
    //     borderRadius: BorderRadius.circular(8),
    //     flushbarPosition: FlushbarPosition.TOP,
    //   ).show(Get.context!);
    //   await Get.offAllNamed(Routes.NAVBAR);
    // }
  }

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
  }
}
