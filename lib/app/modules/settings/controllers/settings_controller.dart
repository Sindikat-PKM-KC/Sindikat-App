import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/modules/register/views/emergency_contact_view.dart';
import 'package:sindikat_app/app/modules/settings/views/devices_view.dart';

class SettingsController extends GetxController {
  var devicesList = <BluetoothDevice>[].obs;
  var bondedDevices = <BluetoothDevice>[].obs;
  var connectedDevice = Rxn<BluetoothDevice>();
  var deviceServices = <BluetoothService>[].obs;
  var heartRate = 0.obs;

  @override
  void onInit() {
    super.onInit();
    listBondedDevices();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void startScan() {
    devicesList.clear();
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        // print('${r.device} found! rssi: ${r.rssi}');
        if (!devicesList.contains(r.device)) {
          devicesList.add(r.device);
        }
      }
    }).onDone(() {
      FlutterBluePlus.stopScan();
    });
  }

  void listBondedDevices() async {
    var bonded = await FlutterBluePlus.bondedDevices;
    bondedDevices.assignAll(bonded);
  }

  void printBondedDevices() {
    for (var device in bondedDevices) {
      print(device.platformName);
    }
  }

  void connectToAmazfitGTR() async {
    var bondedDevices = await FlutterBluePlus.bondedDevices;
    BluetoothDevice? amazfitGTR;

    for (var device in bondedDevices) {
      if (device.platformName == "Amazfit GTR") {
        amazfitGTR = device;
        break;
      }
    }

    if (amazfitGTR != null) {
      try {
        await amazfitGTR.connect(autoConnect: false);
        print('Connected to Amazfit GTR');
        connectedDevice.value = amazfitGTR;
        await discoverServices(amazfitGTR);
      } catch (e) {
        print('Failed to connect to Amazfit GTR: $e');
      }
    } else {
      print('Amazfit GTR not found among bonded devices');
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

  void availableServices() async {
    for (var service in deviceServices) {
      if (service.uuid.toString() == "180d") {
        print('Heart Rate Service found');
        print(service.uuid.toString());
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == "2a37") {
            print('Heart Rate Measurement Characteristic found');
            await subscribeToHeartRateNotifications(characteristic);
          }
        }
      }
    }
  }

  Future<void> subscribeToHeartRateNotifications(
      BluetoothCharacteristic characteristic) async {
    try {
      await characteristic.setNotifyValue(true);
      characteristic.value.listen((value) {
        if (value.isNotEmpty) {
          int heartRate = extractHeartRate(value);
          print('Heart Rate Notification: $heartRate');
        } else {
          print('Received empty notification');
        }
      });
    } catch (e) {
      print('Failed to subscribe to heart rate notifications: $e');
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
}
