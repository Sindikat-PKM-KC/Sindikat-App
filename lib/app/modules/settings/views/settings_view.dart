import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController(), permanent: true);
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title:
            const Text('Pengaturan', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pengaturan Kontak Darurat",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  controller.emergencyContact();
                  FocusScope.of(context).unfocus();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.contact_emergency, color: AppColors.white),
                    SizedBox(width: 16),
                    Text("Edit Kontak Darurat",
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Pengaturan Perangkat Tertaut",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  controller.connectedDevices();
                  FocusScope.of(context).unfocus();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.devices_other_rounded, color: AppColors.white),
                    SizedBox(width: 16),
                    Text("Perangkat Tertaut",
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          controller.logout();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text("Keluar",
                            style: TextStyle(
                                color: AppColors.mainBackground,
                                fontSize: 14,
                                fontWeight: FontWeight.bold))),
                  ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
