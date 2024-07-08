import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';

import '../controllers/alarm_controller.dart';

class AlarmView extends GetView<AlarmController> {
  const AlarmView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AlarmController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.secondaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.secondaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "ALARM BAHAYA DIAKTIFKAN",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "Mode Darurat",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 54),
                const SizedBox(height: 72),
                Stack(
                  children: [
                    Positioned(
                      top: 100,
                      left: Get.width * 0.5 - Get.width * 0.2 * 0.5,
                      child: Center(
                        child: Container(
                          height: Get.width * 0.4,
                          width: Get.width * 0.15,
                          color: AppColors.white,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.warning_rounded,
                        color: AppColors.primaryColor,
                        size: Get.height * 0.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onLongPress: () {
                  controller.stopAlarm();
                },
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                child: const Text("Batalkan",
                    style: TextStyle(
                        color: AppColors.mainBackground,
                        fontSize: 14,
                        fontWeight: FontWeight.bold))),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
