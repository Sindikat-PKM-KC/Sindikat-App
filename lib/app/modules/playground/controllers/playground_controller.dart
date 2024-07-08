import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volume_controller/volume_controller.dart';

class PlaygroundController extends GetxController {
  final count = 0.obs;
  var contactName = ''.obs;
  var contactPhone = ''.obs;
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  double originalVolume = 0.5;

  // // Get Heart Rate
  // var devicesList = <BluetoothDevice>[].obs;
  // var bondedDevices = <BluetoothDevice>[].obs;
  // var connectedDevice = Rxn<BluetoothDevice>();
  // var deviceServices = <BluetoothService>[].obs;
  // var heartRate = 0.obs;

  // // Record Audio
  // FlutterSoundRecorder? _recorder;
  // FlutterSoundPlayer? _player;
  // var isRecording = false.obs;
  // String? _filePath;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _recorder = FlutterSoundRecorder();
  //   _player = FlutterSoundPlayer();
  //   _recorder!.openRecorder().then((_) {
  //     print("Recorder opened");
  //   }).catchError((error) {
  //     print("Failed to open recorder: $error");
  //   });
  //   _player!.openPlayer().then((_) {
  //     print("Player opened");
  //   }).catchError((error) {
  //     print("Failed to open player: $error");
  //   });
  // }

  // @override
  // void onClose() {
  //   _recorder!.closeRecorder();
  //   _player!.closePlayer();
  //   super.onClose();
  // }

  Future<void> recordRequestPermissions() async {
    await [
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  // Future<bool> checkPermissions() async {
  //   var micStatus = await Permission.microphone.status;
  //   var storageStatus = await Permission.storage.status;
  //   return micStatus.isGranted && storageStatus.isGranted;
  // }

  // Future<void> startRecording() async {
  //   if (isRecording.value) return;

  //   await recordRequestPermissions();

  //   bool hasPermissions = await checkPermissions();
  //   if (!hasPermissions) {
  //     print('Permissions not granted');
  //     return;
  //   }

  //   Directory tempDir = await getTemporaryDirectory();
  //   _filePath = '${tempDir.path}/audio.wav';

  //   try {
  //     await _recorder!.startRecorder(
  //       toFile: _filePath,
  //       codec: Codec.pcm16WAV,
  //     );
  //     isRecording.value = true;
  //     update();
  //     print("startRecording");
  //     Future.delayed(const Duration(seconds: 7), () async {
  //       await stopRecording();
  //       playSound(File(_filePath!));
  //     });
  //   } catch (e) {
  //     print('Error starting recorder: $e');
  //   }
  // }

  // Future<void> stopRecording() async {
  //   if (!isRecording.value) return;

  //   try {
  //     await _recorder!.stopRecorder();
  //     print("stopRecording");
  //     isRecording.value = false;
  //     update();
  //   } catch (e) {
  //     print('Error stopping recorder: $e');
  //   }
  // }

  // Future<void> playSound(File file) async {
  //   print('Playing sound: ${file.path}');
  //   try {
  //     if (_player == null) {
  //       print('Player is null, creating new instance');
  //       _player = FlutterSoundPlayer();
  //       await _player!.openPlayer();
  //     }

  //     await _player!.startPlayer(
  //       fromURI: file.path,
  //       codec: Codec.pcm16WAV,
  //       whenFinished: () async {
  //         await _player!.stopPlayer();
  //         print('Player stopped');
  //       },
  //     );
  //   } catch (e) {
  //     print('Error playing sound: $e');
  //     await _player?.stopPlayer();
  //   }
  // }

  // void onRecordButtonPressed() {
  //   if (isRecording.value) {
  //     stopRecording();
  //   } else {
  //     startRecording();
  //   }
  // }

  // // Additional methods and functionalities...

  // void startScan() {
  //   devicesList.clear();
  //   FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

  //   FlutterBluePlus.scanResults.listen((results) {
  //     for (ScanResult r in results) {
  //       // print('${r.device} found! rssi: ${r.rssi}');
  //       if (!devicesList.contains(r.device)) {
  //         devicesList.add(r.device);
  //       }
  //     }
  //   }).onDone(() {
  //     FlutterBluePlus.stopScan();
  //   });
  // }

  // void printDevices() {
  //   print('Devices found:');
  //   for (var device in devicesList) {
  //     print(device);
  //     // print('Name: ${device.name}, ID: ${device.id}');
  //   }
  // }

  // void listBondedDevices() async {
  //   var bonded = await FlutterBluePlus.bondedDevices;
  //   bondedDevices.assignAll(bonded);
  //   for (var device in bonded) {
  //     print(device);
  //   }
  // }

  // void increment() => count.value++;

  Future<void> makePhoneCall(String phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (e) {
      print(e);
    }
  }

  // void connectToAmazfitGTR() async {
  //   var bondedDevices = await FlutterBluePlus.bondedDevices;
  //   BluetoothDevice? amazfitGTR;

  //   for (var device in bondedDevices) {
  //     if (device.name == "Amazfit GTR") {
  //       amazfitGTR = device;
  //       break;
  //     }
  //   }

  //   if (amazfitGTR != null) {
  //     try {
  //       await amazfitGTR.connect(autoConnect: false);
  //       print('Connected to Amazfit GTR');
  //       connectedDevice.value = amazfitGTR;
  //       await discoverServices(amazfitGTR);
  //     } catch (e) {
  //       print('Failed to connect to Amazfit GTR: $e');
  //     }
  //   } else {
  //     print('Amazfit GTR not found among bonded devices');
  //   }
  // }

  // Future<void> discoverServices(BluetoothDevice device) async {
  //   try {
  //     List<BluetoothService> services = await device.discoverServices();
  //     deviceServices.assignAll(services);
  //     print('Discovered services: ${services.length}');
  //   } catch (e) {
  //     print('Failed to discover services: $e');
  //   }
  // }

  // void availableServices() async {
  //   for (var service in deviceServices) {
  //     if (service.uuid.toString() == "180d") {
  //       print('Heart Rate Service found');
  //       print(service.uuid.toString());
  //       for (var characteristic in service.characteristics) {
  //         if (characteristic.uuid.toString() == "2a37") {
  //           print('Heart Rate Measurement Characteristic found');
  //           await subscribeToHeartRateNotifications(characteristic);
  //         }
  //       }
  //     }
  //   }
  // }

  // Future<void> subscribeToHeartRateNotifications(
  //     BluetoothCharacteristic characteristic) async {
  //   try {
  //     await characteristic.setNotifyValue(true);
  //     characteristic.value.listen((value) {
  //       if (value.isNotEmpty) {
  //         int heartRate = extractHeartRate(value);
  //         print('Heart Rate Notification: $heartRate');
  //       } else {
  //         print('Received empty notification');
  //       }
  //     });
  //   } catch (e) {
  //     print('Failed to subscribe to heart rate notifications: $e');
  //   }
  // }

  // int extractHeartRate(List<int> value) {
  //   int flag = value[0];
  //   int format = flag & 0x01;
  //   if (format == 0) {
  //     // Heart Rate Value Format is UINT8
  //     return value[1];
  //   } else {
  //     // Heart Rate Value Format is UINT16
  //     return (value[1] & 0xff) | ((value[2] & 0xff) << 8);
  //   }
  // }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var value = await Geolocator.getCurrentPosition();
    // _openGoogleMaps(value.latitude, value.longitude);
    return value;
  }

  Future<void> openGoogleMaps(double lat, double lng) async {
    final googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    try {
      await launchUrl(Uri.parse(googleMapsUrl));
    } catch (e) {
      print(e);
    }
  }

  // Future<void> _requestPermission() async {
  //   PermissionStatus status = await Permission.contacts.request();
  //   if (status.isGranted) {
  //     pickContact();
  //   } else {
  //     print('Contact permission denied');
  //   }
  // }

  // Future<void> pickContact() async {
  //   try {
  //     final Contact? contact = await _contactPicker.selectContact();
  //     contactName.value = contact?.fullName ?? 'No Name';
  //     contactPhone.value = contact?.phoneNumbers?.first ?? 'No Phone Number';
  //     print('Contact Name: ${contactName.value}');
  //     print('Contact Phone: ${contactPhone.value}');
  //     Flushbar(
  //       title: 'Contact',
  //       titleColor: AppColors.secondaryColor,
  //       message: 'Name: ${contactName.value}\nPhone: ${contactPhone.value}',
  //       messageColor: AppColors.secondaryColor,
  //       duration: Duration(seconds: 2),
  //       backgroundColor: AppColors.mainBackground,
  //       margin: EdgeInsets.all(8),
  //       borderRadius: BorderRadius.circular(8),
  //       flushbarPosition: FlushbarPosition.TOP,
  //     ).show(Get.context!);
  //   } catch (e) {
  //     print('Failed to pick contact: $e');
  //   }
  // }

  // void openContactPicker() {
  //   _requestPermission();
  // }

  // // var originalVolume = await VolumeController().getVolume();
  // void toggleSiren() async {
  //   if (isPlaying.value) {
  //     await _audioPlayer.stop();
  //     VolumeController().setVolume(originalVolume);
  //   } else {
  //     await setMaxVolume();
  //     await _audioPlayer.play(
  //       AssetSource('audios/siren-alarm.mp3'),
  //       volume: 1.0, // Set volume to maximum
  //     );
  //   }
  //   isPlaying.value = !isPlaying.value;
  // }

  // Future<void> setMaxVolume() async {
  //   originalVolume = await VolumeController().getVolume();
  //   VolumeController().maxVolume();
  // }
}
