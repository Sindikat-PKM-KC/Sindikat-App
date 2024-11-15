import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/modules/register/controllers/emergency_controller.dart';

class EmergencyContactView extends GetView {
  const EmergencyContactView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmergencyController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor, // Set the desired color
        statusBarIconBrightness:
            Brightness.light, // Set the icon color to light or dark
      ),
      child: Form(
        key: controller.contactFormKey,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Header(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jika anda berteriak, Aplikasi akan menghubungi Penjaga 1 terlebih dahulu. Jika tidak ada respons, sindikat akan mengirimkan pesan kepada penjaga 2 dan 3',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        addContact1(controller),
                        const SizedBox(height: 8),
                        addContact2(controller),
                        const SizedBox(height: 8),
                        addContact3(controller),
                        const SizedBox(height: 32),
                        buttonSimpan(controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buttonSimpan(EmergencyController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            controller.saveContact();
          },
          child: const Text("Simpan",
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold))),
    );
  }

  GestureDetector addContact3(EmergencyController controller) {
    return GestureDetector(
      onTap: () {
        controller.pickContact().then((value) {
          controller.penjaga3Controller.text = value.fullName!;
          controller.tlpPenjaga3Controller.text = value.phoneNumbers![0];
        });
      },
      child: Container(
        height: 100,
        width: Get.width - 32,
        decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.greyText),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            kontakPenjaga3(controller),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: AppColors.primaryColor,
                ),
                child: const Center(
                  child: Icon(
                    Icons.contact_page_sharp,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector addContact2(EmergencyController controller) {
    return GestureDetector(
      onTap: () {
        controller.pickContact().then((value) {
          controller.penjaga2Controller.text = value.fullName!;
          controller.tlpPenjaga2Controller.text = value.phoneNumbers![0];
        });
      },
      child: Container(
        height: 100,
        width: Get.width - 32,
        decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.greyText),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            kontakPenjaga2(controller),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: AppColors.primaryColor,
                ),
                child: const Center(
                  child: Icon(
                    Icons.contact_page_sharp,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector addContact1(EmergencyController controller) {
    return GestureDetector(
      onTap: () {
        controller.pickContact().then((value) {
          controller.penjaga1Controller.text = value.fullName!;
          controller.tlpPenjaga1Controller.text = value.phoneNumbers![0];
        });
      },
      child: Container(
        height: 100,
        width: Get.width - 32,
        decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.greyText),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            kontakPenjaga1(controller),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: AppColors.primaryColor,
                ),
                child: const Center(
                  child: Icon(
                    Icons.contact_page_sharp,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column kontakPenjaga3(EmergencyController controller) {
    return Column(
      children: [
        SizedBox(
          width: Get.width * 0.6,
          child: TextFormField(
            controller: controller.penjaga3Controller,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              hintText: 'Penjaga 3',
              hintStyle: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(
          width: Get.width * 0.6,
          child: TextFormField(
            controller: controller.tlpPenjaga3Controller,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            keyboardType: TextInputType.number,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              hintText: 'Nomor Telepon',
              hintStyle: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column kontakPenjaga2(EmergencyController controller) {
    return Column(
      children: [
        SizedBox(
          width: Get.width * 0.6,
          child: TextFormField(
            controller: controller.penjaga2Controller,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              hintText: 'Penjaga 2',
              hintStyle: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(
          width: Get.width * 0.6,
          child: TextFormField(
            controller: controller.tlpPenjaga2Controller,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            keyboardType: TextInputType.number,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              hintText: 'Nomor Telepon',
              hintStyle: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column kontakPenjaga1(EmergencyController controller) {
    return Column(
      children: [
        SizedBox(
          width: Get.width * 0.6,
          child: TextFormField(
            // validator: (value) {},
            controller: controller.penjaga1Controller,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              hintText: 'Penjaga 1',
              hintStyle: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(
          width: Get.width * 0.6,
          child: TextFormField(
            controller: controller.tlpPenjaga1Controller,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            keyboardType: TextInputType.number,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              hintText: 'Nomor Telepon',
              hintStyle: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stack Header() {
    return Stack(
      children: [
        Container(
          height: Get.height * 0.25,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Center(
                  child: SizedBox(
                      width: 75,
                      height: 75,
                      child: Image.asset(
                        "assets/images/logo_white.png",
                      )),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Pilih Siapa yang Dapat Dihubungi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
