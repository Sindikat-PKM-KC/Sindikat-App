import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

class RecordController extends GetxController {
  //TODO: Implement RecordController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _startRecording();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _startRecording() {
    // Simulate a 5-second recording
    Future.delayed(const Duration(seconds: 4), () {
      // Show a loading animation
      _showLoadingAnimation();
      // Navigate to the navbar after 5 seconds
      // Get.offAllNamed(Routes.NAVBAR);
    });
  }

  void _showLoadingAnimation() {
    Get.dialog(
      Center(
        child: Container(
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

    // Wait for 5 seconds then navigate to the emergency call screen
    Future.delayed(const Duration(seconds: 5), () {
      Get.back(); // Close the loading dialog
      Get.offAllNamed(Routes.CALL_EMERGENCY);
    });
  }

  void increment() => count.value++;
}
