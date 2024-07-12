import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import '../controllers/playground_controller.dart';

class PlaygroundView extends GetView<PlaygroundController> {
  const PlaygroundView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlaygroundController());
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title:
            const Text('Playground', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      controller.startRecording();
                      FocusScope.of(context).unfocus();
                    },
                    child: Text(
                      controller.isRecording.value
                          ? "Recording..."
                          : "Start Recording",
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
