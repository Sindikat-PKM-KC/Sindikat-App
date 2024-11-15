import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import '../controllers/record_controller.dart';

class RecordView extends GetView<RecordController> {
  const RecordView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecordController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: sytemUi(),
      child: Scaffold(
        backgroundColor: AppColors.secondaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                openerMessage(),
                warningText(),
                const SizedBox(height: 54),
                const Text(
                  "Pendeteksi Suara",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 130.0,
                    color: AppColors.primaryColor,
                  ),
                ),
                commandText(),
                const SizedBox(height: 72),
                animationWave(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox animationWave() {
    return SizedBox(
      width: double.infinity,
      child: Lottie.asset(
        'assets/lottie/listen_audio_1.json',
        fit: BoxFit.cover,
      ),
    );
  }

  Text commandText() {
    return const Text(
      "Suara akan direkam selama 4 detik. Jika suara terdeteksi sebagai potensi kriminal maka  panggilan akan diteruskan dan pesan akan dikirimkan ke kontak darurat. Alarm akan dibunyikan setelah panggilan diteruskan",
      style: TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Center warningText() {
    return const Center(
      child: Text(
        "Status Waspada Terdeteksi",
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Center openerMessage() {
    return const Center(
      child: Text(
        "SINDIKAT",
        style: TextStyle(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  SystemUiOverlayStyle sytemUi() {
    return const SystemUiOverlayStyle(
      statusBarColor: AppColors.secondaryColor, // Set the desired color
      statusBarIconBrightness:
          Brightness.light, // Set the icon color to light or dark
    );
  }
}
