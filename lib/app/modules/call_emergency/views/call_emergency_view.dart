import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import '../controllers/call_emergency_controller.dart';

class CallEmergencyView extends GetView<CallEmergencyController> {
  const CallEmergencyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CallEmergencyController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUi(),
      child: Scaffold(
        backgroundColor: AppColors.secondaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userName(),
                warningMessafe(),
                const SizedBox(height: 54),
                detectionMessage(),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 130.0,
                    color: AppColors.primaryColor,
                  ),
                ),
                commandMessage(),
                const SizedBox(height: 72),
                timerCall(controller),
              ],
            ),
          ),
        ),
        floatingActionButton: cancelCallButton(controller, context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Padding cancelCallButton(CallEmergencyController controller, BuildContext context) {
    return Padding(
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
                controller.interruptCountdown();
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
      );
  }

  GestureDetector timerCall(CallEmergencyController controller) {
    return GestureDetector(
                onTap: () {
                  controller.immediatelyDoAction();
                },
                child: Obx(() => Container(
                      width: double.infinity,
                      height: Get.height * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          controller.countdown.value.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
              );
  }

  Text commandMessage() {
    return const Text(
                "Kamu memiliki waktu 3 detik untuk membatalkan, tekan dan tahan tombol batalkan untuk melakukannya.",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              );
  }

  Text detectionMessage() {
    return const Text(
                "Suara Teriak Terdeteksi",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              );
  }

  Center warningMessafe() {
    return const Center(
                child: Text(
                  "Mode Siaga",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
  }

  Center userName() {
    return const Center(
                child: Text(
                  "SINDIKAT User",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
  }

  SystemUiOverlayStyle systemUi() {
    return const SystemUiOverlayStyle(
      statusBarColor: AppColors.secondaryColor,
      statusBarIconBrightness: Brightness.light,
    );
  }
}
