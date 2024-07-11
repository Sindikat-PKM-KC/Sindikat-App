import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  late TextEditingController emailController, passwordController;

  final count = 0.obs;

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email tidak boleh kosong";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    if (loginFormKey.currentState!.validate()) {
      if (await _checkAndRequestPermissions()) {
        Get.offAllNamed(Routes.NAVBAR);
      } else {
        Get.snackbar(
          'Permission Denied',
          'You need to grant permissions to proceed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    // List of permissions to request
    List<Permission> permissions = [
      Permission.bluetooth,
      Permission.phone,
      Permission.contacts,
      Permission.microphone,
      Permission.location,
      // Permission.storage,
    ];

    // Request permissions
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // Check if all permissions are granted
    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      Get.snackbar(
        'Permission Denied',
        'You need to grant all permissions to proceed',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    return allGranted;
  }

  void increment() => count.value++;
}
