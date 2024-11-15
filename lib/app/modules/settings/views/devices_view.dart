import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/modules/settings/controllers/settings_controller.dart';

class DevicesView extends GetView<SettingsController> {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    controller.checkBluetoothStatus(); // Check Bluetooth status on view load

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perangkat Tertaut',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: true,
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Stack(
        children: [
          bluetoothDevices(),
          Positioned(
            top: 170, // 120 + 50
            child: Container(
              height: Get.height - 170, // 120 + 50
              width: Get.width,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    deviceInfo(),
                    const SizedBox(height: 8),
                    addNewDevice(controller, context),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.greyText,
                          width: 1,
                        ),
                      ),
                      child: availableDevices(controller),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.secondaryColor,
    );
  }

  Column availableDevices(SettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 16,
            top: 16,
            bottom: 16,
            right: 16,
          ),
          child: Text(
            "Perangkat Tersimpan",
            style: TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            itemCount: min(controller.bondedDevices.length, 5),
            itemBuilder: (context, index) {
              final device = controller.bondedDevices[index];
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.greyText,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      deviceName(device),
                      buttonConnect(controller, device),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  SizedBox addNewDevice(SettingsController controller, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          print(controller.listHeartRate);
          FocusScope.of(context).unfocus();
        },
        child: const Text(
          "Sambungkan perangkat baru",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container deviceInfo() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.greyText,
          width: 1,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama Perangkat",
                  style: TextStyle(
                    color: AppColors.primaryBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Huawei Nova 5t",
                  style: TextStyle(
                    color: AppColors.primaryBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.greyText,
            ),
          ],
        ),
      ),
    );
  }

  Padding bluetoothDevices() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        alignment: Alignment.topCenter,
        child: SvgPicture.asset(
          "assets/images/devices.svg",
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row deviceName(BluetoothDevice device) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.bluetooth,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.4,
              child: Text(
                // ignore: deprecated_member_use
                device.name.toString(),
                style: const TextStyle(
                  color: AppColors.primaryBlack,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              // ignore: deprecated_member_use
              device.id.toString(),
              style: const TextStyle(
                color: AppColors.greyText,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  SizedBox buttonConnect(
      SettingsController controller, BluetoothDevice device) {
    return SizedBox(
      height: 25,
      child: Obx(() {
        return controller.loadingDevice.value == device
            ? const Row(
                children: [
                  SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.primaryColor,
                      )),
                  SizedBox(width: 25),
                ],
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  backgroundColor: controller.connectedDevice.value == device
                      ? AppColors.secondaryColor
                      : AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: controller.connectedDevice.value != null &&
                        controller.connectedDevice.value != device
                    ? null
                    : () async {
                        if (controller.connectedDevice.value == device) {
                          await controller.disconnectDevice(device);
                        } else {
                          await controller.connectToDevice(device);
                        }
                      },
                child: Text(
                  controller.connectedDevice.value == device
                      ? "Disconnect"
                      : "Connect",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
      }),
    );
  }
}
