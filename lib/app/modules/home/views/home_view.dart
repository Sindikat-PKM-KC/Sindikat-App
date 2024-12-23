import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sindikat_app/app/constans/colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    controller.relisten();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUi(),
        child: Scaffold(
          backgroundColor: AppColors.secondaryColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        controller.user['name'] ?? "",
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    welcomingText(),
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
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5.0, right: 10.0),
                      child: Container(
                        height: 1.0,
                        width: 130.0,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    screamCommand(),
                    const SizedBox(height: 72),
                    audioAnimation(),
                    // const SizedBox(height: 32),
                    controller.settingsController.heartRate.value == 0
                        ? const SizedBox()
                        : heartRateMeasurement(controller),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Center welcomingText() {
    return const Center(
      child: Text(
        "Selamat datang di aplikasi SINDIKAT",
        style: TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  SystemUiOverlayStyle systemUi() {
    return const SystemUiOverlayStyle(
      statusBarColor: AppColors.secondaryColor, // Set the desired color
      statusBarIconBrightness:
          Brightness.light, // Set the icon color to light or dark
    );
  }

  Text screamCommand() {
    return const Text.rich(
      TextSpan(
        text: 'Teriak sekencang mungkin ke ',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.white,
        ),
        children: <InlineSpan>[
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Text(
              'untuk memulai',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox audioAnimation() {
    return SizedBox(
      width: double.infinity,
      child: Lottie.asset(
        'assets/lottie/listen_audio_2.json',
        fit: BoxFit.cover,
      ),
    );
  }

  Row heartRateMeasurement(HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: Get.width / 4 - 32),
        SizedBox(
          width: 72,
          height: 100,
          child: Lottie.asset(
            'assets/lottie/heart_rate.json',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Text.rich(
          TextSpan(
            text: '${controller.settingsController.heartRate.value} ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            children: const <InlineSpan>[
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: Text(
                  'bpm',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
