import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:sindikat_app/app/constans/colors.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.secondaryColor, // Set the desired color
          statusBarIconBrightness:
              Brightness.light, // Set the icon color to light or dark
        ),
        child: Scaffold(
          backgroundColor: AppColors.secondaryColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: 10,
                ),
              ),
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    "assets/images/logo_white.png",
                  )),
              Expanded(
                flex: 1,
                child: Container(
                  width: 10,
                ),
              ),
              const Center(
                child: Text(
                  'powered by',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const Center(
                child: Text(
                  'SINDIKAT',
                  style: TextStyle(
                      fontSize: 30,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ));
  }
}
