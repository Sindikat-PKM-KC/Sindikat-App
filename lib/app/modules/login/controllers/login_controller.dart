import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/constans/url.dart';
import 'package:sindikat_app/app/data/models/user_model.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform, Process;
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final User user = User();
  final loginFormKey = GlobalKey<FormState>();
  final getStorage = GetStorage();
  late TextEditingController emailController, passwordController;
  RxBool isLoading = false.obs;

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
        isLoading(true);
        var url = Uri.parse("${UrlApi.baseAPI}/auth/login/");
        var inputLogin = json.encode({
          'email': email,
          'password': password,
        });
        http
            .post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: inputLogin,
        )
            .then((res) {
          if (res.statusCode < 300) {
            var response = json.decode(res.body);
            getStorage.write("access_token", response['access']);
            getStorage.write("refresh_token", response['refresh']);
            var user = User.fromJson(response['user']);
            getStorage.write('user', user.toJson());
            emailController.clear();
            passwordController.clear();

            Get.offAllNamed(Routes.NAVBAR);
            _showFlushbar("Success", "Berhasil login", "success");
            isLoading(false);
          } else {
            _showFlushbar("Error", res.reasonPhrase.toString(), "err");
            isLoading(false);
          }
        }).catchError((err) {
          _showFlushbar("Error", err.toString(), "err");
          isLoading(false);
        });
      } else {
        Get.snackbar(
          'Permission Denied',
          'You need to grant permissions to proceed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    loginFormKey.currentState!.save();
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

  void _showFlushbar(String title, String message, String type) {
    Color bgColor = type == 'success'
        ? AppColors.secondaryColor
        : type == 'err'
            ? AppColors.red
            : AppColors.white;
    Flushbar(
      title: title,
      titleColor: AppColors.white,
      message: message,
      messageColor: AppColors.white,
      duration: const Duration(seconds: 2),
      backgroundColor: bgColor,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(Get.context!);
  }
}
