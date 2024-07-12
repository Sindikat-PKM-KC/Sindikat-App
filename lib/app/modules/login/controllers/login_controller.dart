import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform, Process;

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
    // List of common permissions
    List<Permission> permissions = [
      Permission.bluetooth,
      Permission.phone,
      Permission.contacts,
      Permission.microphone,
      Permission.location,
    ];

    // Add storage permissions based on Android version
    if (Platform.isAndroid) {
      if (await _isAtLeastAndroidR()) {
        // Android 11 (R) and above
        permissions.add(Permission.manageExternalStorage);
      } else {
        // Below Android 11
        permissions.add(Permission.storage);
      }
    }

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

// Helper method to check Android version
  Future<bool> _isAtLeastAndroidR() async {
    final version = await _getAndroidVersion();
    return version >= 30; // Android R (API level 30) corresponds to version 11
  }

// Method to get the Android version
  Future<int> _getAndroidVersion() async {
    return Platform.isAndroid
        ? int.parse((await _getSystemProperty('ro.build.version.sdk')) ?? '0')
        : 0;
  }

// Method to get system property
  Future<String?> _getSystemProperty(String key) async {
    try {
      final result = await Process.run('getprop', [key]);
      return result.stdout.toString().trim();
    } catch (e) {
      return null;
    }
  }

  void increment() => count.value++;
}
