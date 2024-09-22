import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/constans/url.dart';
import 'package:sindikat_app/app/data/models/user_model.dart';
import 'package:sindikat_app/app/modules/register/views/emergency_contact_view.dart';

import 'package:http/http.dart' as http;


class RegisterController extends GetxController {
  final registerFormKey = GlobalKey<FormState>();
  late TextEditingController fullnameController,
      emailController,
      passwordController,
      confirmPasswordController;
  RxBool isLoading = false.obs;
  final User user = User();
  final getStorage = GetStorage();

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
      isLoading(true);
        var url = Uri.parse("${UrlApi.baseAPI}/api/auth/register/");
        var inputRegister = json.encode({
          'name': fullname,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        });
        http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: inputRegister,
        ).then((res) {
          if (res.statusCode < 300) {
            var response = json.decode(res.body);
            // print("response: $response");
            var user = User.fromJson(response);
            getStorage.write('user', user.toJson());
            fullnameController.clear();
            emailController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            Get.offAll(() => const EmergencyContactView());
            _showFlushbar("Success", "Berhasil daftar", "success");
            isLoading(false);
          } else {
            _showFlushbar("Error", res.reasonPhrase.toString(), "err");
            isLoading(false);
          }
        }).catchError((err) {
          _showFlushbar("Error", err.toString(), "err");
          isLoading(false);
        });
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

  void increment() => count.value++;
}
