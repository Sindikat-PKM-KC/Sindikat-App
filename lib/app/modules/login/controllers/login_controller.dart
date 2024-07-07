import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

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

  login(String email, String password) {
    if (loginFormKey.currentState!.validate()) {
      Get.offAllNamed(Routes.NAVBAR);
    }
  }

  void increment() => count.value++;
}
