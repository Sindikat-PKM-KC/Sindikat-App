import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/modules/register/views/emergency_contact_view.dart';

class RegisterController extends GetxController {
  final registerFormKey = GlobalKey<FormState>();
  late TextEditingController fullnameController,
      emailController,
      passwordController,
      confirmPasswordController;

  final count = 0.obs;
  @override
  void onInit() {
    fullnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.onInit();
  }

  String? validateFullName(String value) {
    if (value.isEmpty) {
      return "Nama Lengkap tidak boleh kosong";
    }
    return null;
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

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return "Konfirmasi password tidak boleh kosong";
    }
    return null;
  }

  register(
      String fullname, String email, String password, String confirmPassword) {
    if (registerFormKey.currentState!.validate()) {
      Get.offAll(() => const EmergencyContactView());
    }
  }

  void increment() => count.value++;
}
