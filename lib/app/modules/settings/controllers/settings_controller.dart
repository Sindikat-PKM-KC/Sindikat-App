// import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sindikat_app/app/constans/colors.dart';
// import 'package:sindikat_app/app/constans/url.dart';
// import 'package:sindikat_app/app/modules/home/controllers/home_controller.dart';
import 'package:sindikat_app/app/modules/register/views/emergency_contact_view.dart';
import 'package:sindikat_app/app/modules/settings/views/devices_view.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

class SettingsController extends GetxController {
  final getStorage = GetStorage();

  var devicesList = <BluetoothDevice>[].obs;
  var bondedDevices = <BluetoothDevice>[].obs;
  var connectedDevice = Rxn<BluetoothDevice>();
  var deviceServices = <BluetoothService>[].obs;
  var heartRate = 0.obs;
  var listHeartRate = <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;
  var loadingDevice = Rxn<BluetoothDevice>();

  @override
  void onInit() {
    super.onInit();
    listBondedDevices();
  }

  @override
  void onClose() {
    if (connectedDevice.value != null) {
      disconnectDevice(connectedDevice.value!);
    }
    super.onClose();
  }

  void checkBluetoothStatus() async {
    // ignore: deprecated_member_use
    bool isOn = await FlutterBluePlus.isOn;
    if (!isOn) {
      Get.defaultDialog(
        title: 'Bluetooth Diperlukan',
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        // title: "",
        contentPadding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        backgroundColor: AppColors.mainBackground,
        content: Column(
          children: [
            const Icon(Icons.bluetooth_disabled,
                size: 60, color: AppColors.primaryColor),
            const SizedBox(height: 10),
            const Text(
              'Harap hidupkan bluetooth untuk menggunakan fitur ini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.offNamed(Routes.NAVBAR, arguments: 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      listBondedDevices();
    }
  }

  void startScan() {
    checkBluetoothStatus();
    devicesList.clear();
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!devicesList.contains(r.device)) {
          devicesList.add(r.device);
        }
      }
    }).onDone(() {
      FlutterBluePlus.stopScan();
    });
  }

  void listBondedDevices() async {
    try {
      var bonded = await FlutterBluePlus.bondedDevices;
      if (bonded.isEmpty) {
        return;
      }
      bondedDevices.assignAll(bonded);
    } catch (e) {
      Flushbar(
        title: 'Error',
        titleColor: AppColors.white,
        message: e.toString(),
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      isLoading(true);
      loadingDevice.value = device;
      await device.connect(autoConnect: false);
      connectedDevice.value = device;
      await discoverServices(device);
      if (hasHeartRateService()) {
        await subscribeToHeartRateNotifications(device);
        Flushbar(
          title: 'Success',
          titleColor: AppColors.white,
          message: 'Connected to device with heart rate service',
          messageColor: AppColors.white,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.green,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(Get.context!);
      } else {
        await device.disconnect();
        connectedDevice.value = null;
        Flushbar(
          title: 'Error',
          titleColor: AppColors.white,
          message: 'No heart rate service in this device',
          messageColor: AppColors.white,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primaryColor,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(Get.context!);
      }
    } catch (e) {
      Flushbar(
        title: 'Error',
        titleColor: AppColors.white,
        message: e.toString(),
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
      connectedDevice.value = null;
    } finally {
      loadingDevice.value = null;
      isLoading(false);
    }
  }

  Future<void> disconnectDevice(BluetoothDevice device) async {
    try {
      isLoading(true);
      loadingDevice.value = device;
      await device.disconnect();
      connectedDevice.value = null;
      Flushbar(
        title: 'Success',
        titleColor: AppColors.white,
        message: 'Disconnected from device',
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.green,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    } catch (e) {
      Flushbar(
        title: 'Error',
        titleColor: AppColors.white,
        message: e.toString(),
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    } finally {
      loadingDevice.value = null;
      isLoading(false);
    }
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      deviceServices.assignAll(services);
    } catch (e) {
      Flushbar(
        title: 'Error',
        titleColor: AppColors.white,
        message: e.toString(),
        messageColor: AppColors.white,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }

  bool hasHeartRateService() {
    for (var service in deviceServices) {
      if (service.uuid.toString() == "180d") {
        return true;
      }
    }
    return false;
  }

  Future<void> subscribeToHeartRateNotifications(BluetoothDevice device) async {
    for (var service in deviceServices) {
      if (service.uuid.toString() == "180d") {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == "2a37") {
            await characteristic.setNotifyValue(true);
            // ignore: deprecated_member_use
            characteristic.value.listen((value) {
              String currentDateTime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
              if (value.isNotEmpty) {
                int heartRate = extractHeartRate(value);
                this.heartRate.value = heartRate;
                listHeartRate.add(
                    {'timestamp': currentDateTime, 'heartrate': heartRate});
              } else {
                heartRate.value = 0;
                listHeartRate
                    .add({'timestamp': currentDateTime, 'heartrate': 0});
              }
            });
            return;
          }
        }
      }
    }
  }

  int extractHeartRate(List<int> value) {
    int flag = value[0];
    int format = flag & 0x01;
    if (format == 0) {
      // Heart Rate Value Format is UINT8
      return value[1];
    } else {
      // Heart Rate Value Format is UINT16
      return (value[1] & 0xff) | ((value[2] & 0xff) << 8);
    }
  }

  void emergencyContact() {
    Get.to(() => const EmergencyContactView(),
        arguments: 'Edit Kontak Darurat');
  }

  void connectedDevices() {
    listBondedDevices();
    Get.to(() => const DevicesView());
  }

  logout() async {
    isLoading(true);
    // var url = Uri.parse("${UrlApi.baseAPI}/logout/");
    // HomeController homeController = Get.find<HomeController>();
    // homeController.stopSpeech();
    getStorage.erase();
    // Future.delayed(const Duration(seconds: 1), () {
    isLoading(false);
    // homeController.stopSpeech();
    Get.deleteAll(force: true);
    Get.offAllNamed(Routes.LOGIN);
    // });

    // var token = 'Bearer ${loginController.getStorage.read("access_token")}';
    // var refresh = loginController.getStorage.read('refresh_token');
    // var inputLogout = json.encode({
    //   'refresh_token': refresh,
    // });
    // final response = await http.post(
    //   url,
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     'Authorization': token,
    //   },
    //   body: inputLogout,
    // );
    // if (response.statusCode < 300) {
    //   isLoading(false);
    //   SnackBarWidget.showSnackBar(
    //     'Logout Berhasil',
    //     'Anda telah berhasil keluar ke akun Anda',
    //     'Success',
    //   );
    //   Get.offAllNamed(Routes.LOGIN);
    // } else {
    //   isLoading(false);
    //   SnackBarWidget.showSnackBar(
    //     'Logout Gagal',
    //     'Terjadi kesalahan saat keluar dari akun Anda',
    //     'err',
    //   );
    // }
  }
}
