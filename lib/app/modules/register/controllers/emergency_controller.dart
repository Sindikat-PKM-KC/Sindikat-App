import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/constans/url.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

import 'package:http/http.dart' as http;

class EmergencyController extends GetxController {
  var emergencyContact = Get.arguments;
  final contactFormKey = GlobalKey<FormState>();
  late TextEditingController penjaga1Controller,
      tlpPenjaga1Controller,
      penjaga2Controller,
      tlpPenjaga2Controller,
      penjaga3Controller,
      tlpPenjaga3Controller;

  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  RxBool isLoading = false.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    penjaga1Controller = TextEditingController();
    tlpPenjaga1Controller = TextEditingController();
    penjaga2Controller = TextEditingController();
    tlpPenjaga2Controller = TextEditingController();
    penjaga3Controller = TextEditingController();
    tlpPenjaga3Controller = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool validateName(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  bool validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return false;
    }
    if (value.length < 10) {
      return false;
    }
    return true;
  }

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      pickContact();
    } else {
      Flushbar(
        title: 'Permission Denied',
        titleColor: AppColors.secondaryColor,
        message: 'Please allow access to contacts to pick a contact.',
        messageColor: AppColors.secondaryColor,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.mainBackground,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }

  Future<Contact> pickContact() async {
    try {
      final Contact? contact = await _contactPicker.selectContact();
      if (contact != null) {
        return contact;
      } else {
        Flushbar(
          title: 'No Contact Selected',
          titleColor: AppColors.secondaryColor,
          message: 'No contact selected, please try again.',
          messageColor: AppColors.secondaryColor,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.mainBackground,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(Get.context!);
      }
    } catch (e) {
      Flushbar(
        title: 'Error',
        titleColor: AppColors.secondaryColor,
        message: 'Error while picking contact, please try again later.',
        messageColor: AppColors.secondaryColor,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.mainBackground,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
    // Return an empty Contact if no contact is selected
    return Contact(fullName: '', phoneNumbers: ['']);
  }

  void changeTextControllerValue() {
    penjaga1Controller.text = 'New Value';
  }

  void openContactPicker() {
    _requestPermission();
  }

  void saveContact() {
    bool isValid = true;
    String errorMessage = '';

    if (!validateName(penjaga1Controller.text)) {
      isValid = false;
      errorMessage = 'Penjaga 1 name is required.';
    } else if (!validatePhoneNumber(tlpPenjaga1Controller.text)) {
      isValid = false;
      errorMessage =
          'Penjaga 1 phone number is required and must be at least 10 characters.';
    } else if (!validateName(penjaga2Controller.text)) {
      isValid = false;
      errorMessage = 'Penjaga 2 name is required.';
    } else if (!validatePhoneNumber(tlpPenjaga2Controller.text)) {
      isValid = false;
      errorMessage =
          'Penjaga 2 phone number is required and must be at least 10 characters.';
    } else if (!validateName(penjaga3Controller.text)) {
      isValid = false;
      errorMessage = 'Penjaga 3 name is required.';
    } else if (!validatePhoneNumber(tlpPenjaga3Controller.text)) {
      isValid = false;
      errorMessage =
          'Penjaga 3 phone number is required and must be at least 10 characters.';
    }

    if (isValid) {
      if (emergencyContact == null) {
        addContact();
        // Get.offAllNamed(Routes.NAVBAR);
      } else {
        Flushbar(
          title: 'Success',
          titleColor: AppColors.secondaryColor,
          message: 'Contact saved successfully.',
          messageColor: AppColors.secondaryColor,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.mainBackground,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(Get.context!);
        Get.offNamed(Routes.NAVBAR, arguments: 1);
      }
    } else {
      _showFlushbar('Error', errorMessage, 'err');
    }
  }

  void increment() => count.value++;

  Future<void> addContact() async {
    isLoading.value = true;
    final token = GetStorage().read('access_token');
    var user = GetStorage().read('user');
    final userId = user['id'];
    var inputContact = [
      {
        'name': penjaga1Controller.text,
        'phone_number': tlpPenjaga1Controller.text
      },
      {
        'name': penjaga2Controller.text,
        'phone_number': tlpPenjaga2Controller.text
      },
      {
        'name': penjaga3Controller.text,
        'phone_number': tlpPenjaga3Controller.text
      }
    ];
    final response = await http.post(
      Uri.parse("${UrlApi.baseAPI}/emergency-contact/$userId/register/"),
      headers: {
        'Authorization': "Bearer $token",
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'data': inputContact,
      }),
    );

    isLoading.value = false;

    if (response.statusCode < 300) {
      _showFlushbar('Success', 'Contact saved successfully.', 'success');
      Get.offAllNamed(Routes.NAVBAR); // Navigate to home or appropriate page
    } else {
      _showFlushbar('Error', 'Failed to save contact.', 'err');
      print('Failed to save contact: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _showFlushbar(String title, String message, String type) {
    Color bgColor = type == 'success'
        ? AppColors.secondaryColor
        : type == 'err'
            ? AppColors.mainBackground
            : AppColors.white;
    Flushbar(
      title: title,
      titleColor: AppColors.secondaryColor,
      message: message,
      messageColor: AppColors.secondaryColor,
      duration: const Duration(seconds: 2),
      backgroundColor: bgColor,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(Get.context!);
  }
}
