import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/modules/register/views/emergency_contact_view.dart';
import 'package:sindikat_app/app/modules/settings/views/devices_view.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

class SettingsController extends GetxController {
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
      print('Error retrieving bonded devices: $e');
    }
  }

  void printBondedDevices() {
    if (bondedDevices.isEmpty) {
      return;
    }
    for (var device in bondedDevices) {
      print(device.platformName);
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
        print('Connected to device with heart rate service');
      } else {
        await device.disconnect();
        connectedDevice.value = null;
        print('No heart rate service in this device');
      }
    } catch (e) {
      print('Failed to connect to device: $e');
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
      print('Disconnected from device');
    } catch (e) {
      print('Failed to disconnect from device: $e');
    } finally {
      loadingDevice.value = null;
      isLoading(false);
    }
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      deviceServices.assignAll(services);
      print('Discovered services: ${services.length}');
    } catch (e) {
      print('Failed to discover services: $e');
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
                listHeartRate
                    .add({'timestamp': currentDateTime, 'heartrate': 0});
              }
            });
            print('Subscribed to heart rate notifications');
            return;
          }
        }
      }
    }
    print('Heart Rate Measurement Characteristic not found');
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
}
