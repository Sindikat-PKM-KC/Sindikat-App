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
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    controller.makePhoneCall("+62 821-4656-0178");
                    FocusScope.of(context).unfocus();
                  },
                  child: const Text("Call phone",
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  controller.determinePosition().then((value) {
                    controller.openGoogleMaps(value.latitude, value.longitude);
                  });
                  FocusScope.of(context).unfocus();
                },
                child: const Text(
                  "Get Possition",
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8)),
            //     ),
            //     onPressed: () {
            //       controller.openContactPicker();
            //       FocusScope.of(context).unfocus();
            //     },
            //     child: const Text(
            //       "Get Contact",
            //       style: TextStyle(
            //           color: AppColors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: Obx(() => ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: AppColors.primaryColor,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8)),
            //         ),
            //         onPressed: () {
            //           controller.toggleSiren();
            //           FocusScope.of(context).unfocus();
            //         },
            //         child: Text(
            //           controller.isPlaying.value ? "Stop Alarm" : "Play Alarm",
            //           style: const TextStyle(
            //               color: AppColors.white,
            //               fontSize: 14,
            //               fontWeight: FontWeight.bold),
            //         ),
            //       )),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8)),
            //     ),
            //     onPressed: () {
            //       controller.startScan();
            //       // controller.printDevices();
            //       FocusScope.of(context).unfocus();
            //     },
            //     child: const Text(
            //       "Scan Devices",
            //       style: TextStyle(
            //           color: AppColors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8)),
            //     ),
            //     onPressed: () {
            //       // controller.startScan();
            //       controller.printDevices();
            //       FocusScope.of(context).unfocus();
            //     },
            //     child: const Text(
            //       "Get Devices",
            //       style: TextStyle(
            //           color: AppColors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8)),
            //     ),
            //     onPressed: () {
            //       // controller.startScan();
            //       controller.listBondedDevices();
            //       FocusScope.of(context).unfocus();
            //     },
            //     child: const Text(
            //       "Get Bonded Devices",
            //       style: TextStyle(
            //           color: AppColors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8)),
            //     ),
            //     onPressed: () {
            //       // controller.startScan();
            //       controller.connectToAmazfitGTR();
            //       FocusScope.of(context).unfocus();
            //     },
            //     child: const Text(
            //       "Connect with Watch",
            //       style: TextStyle(
            //           color: AppColors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8)),
            //     ),
            //     onPressed: () {
            //       // controller.startScan();
            //       controller.availableServices();
            //       FocusScope.of(context).unfocus();
            //     },
            //     child: const Text(
            //       "Watch Services",
            //       style: TextStyle(
            //           color: AppColors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: Obx(() => ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: AppColors.primaryColor,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8)),
            //         ),
            //         onPressed: () {
            //           controller.startRecording();
            //           FocusScope.of(context).unfocus();
            //         },
            //         child: Text(
            //           controller.isRecording.value
            //               ? "Recording..."
            //               : "Start Recording",
            //           style: const TextStyle(
            //               color: AppColors.white,
            //               fontSize: 14,
            //               fontWeight: FontWeight.bold),
            //         ),
            //       )),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8)),
            //     ),
            //     onPressed: () {
            //       // controller.startScan();
            //       // controller.availableServices();
            //       FocusScope.of(context).unfocus();
            //     },
            //     child: const Text(
            //       "Play Recorded",
            //       style: TextStyle(
            //           color: AppColors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
