import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.secondaryColor, // Set the desired color
        statusBarIconBrightness:
            Brightness.light, // Set the icon color to light or dark
      ),
      child: Form(
        key: controller.registerFormKey,
        child: Scaffold(
          backgroundColor: AppColors.secondaryColor,
          body: SafeArea(
            child: SizedBox(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.07,
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
                      const Center(
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Center(
                        child: Text(
                          'Silahkan isi data diri anda',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Nama lengkap',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          controller: controller.fullnameController,
                          validator: (value) {
                            return controller.validateFullName(value!);
                          },
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                            hintText: 'Masukkan nama lengkap Anda',
                            hintStyle: const TextStyle(
                                color: AppColors.greyText,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                            filled: true,
                            fillColor: AppColors.white,
                            focusColor: AppColors.mainBackground,
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.white, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppColors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          controller: controller.emailController,
                          validator: (value) {
                            return controller.validateEmail(value!);
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                            hintText: 'Masukkan email Anda',
                            hintStyle: const TextStyle(
                                color: AppColors.greyText,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                            filled: true,
                            fillColor: AppColors.white,
                            focusColor: AppColors.mainBackground,
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.white, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppColors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Kata sandi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
                        validator: (value) {
                          return controller.validatePassword(value!);
                        },
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 24),
                          hintText: 'Masukkan kata sandi Anda',
                          hintStyle: const TextStyle(
                              color: AppColors.greyText,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          filled: true,
                          fillColor: AppColors.white,
                          focusColor: AppColors.mainBackground,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Konfirmasi kata sandi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: controller.confirmPasswordController,
                        validator: (value) {
                          return controller.validateConfirmPassword(value!);
                        },
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 24),
                          hintText: 'Masukkan konfirmasi kata sandi Anda',
                          hintStyle: const TextStyle(
                              color: AppColors.greyText,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          filled: true,
                          fillColor: AppColors.white,
                          focusColor: AppColors.mainBackground,
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: AppColors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              controller.register(
                                  controller.fullnameController.text,
                                  controller.emailController.text,
                                  controller.passwordController.text,
                                  controller.confirmPasswordController.text);

                              FocusScope.of(context).unfocus();
                            },
                            child: const Text("Daftar",
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Sudah punya akun? ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: AppColors.white,
                            ),
                            children: <InlineSpan>[
                              WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.offAllNamed(Routes.LOGIN);
                                  },
                                  child: const Text(
                                    'Masuk',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
