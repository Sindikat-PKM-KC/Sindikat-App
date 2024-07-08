import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

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

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    print('Emergency Contact: $emergencyContact');
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
        Get.offAllNamed(Routes.NAVBAR);
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
      Flushbar(
        title: 'Error',
        titleColor: AppColors.secondaryColor,
        message: errorMessage,
        messageColor: AppColors.secondaryColor,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.mainBackground,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }

  void increment() => count.value++;
}
