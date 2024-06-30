import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/playground_controller.dart';

class PlaygroundView extends GetView<PlaygroundController> {
  const PlaygroundView({Key? key}) : super(key: key);
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
                    controller.makePhoneCall("+6282146560178");
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
          ],
        ),
      ),
    );
  }
}
