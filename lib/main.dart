import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// ignore: unused_import
import 'package:connectivity_plus/connectivity_plus.dart'; // Add this import
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:sindikat_app/app/modules/splash/bindings/splash_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure this is called first
  await GetStorage.init();

  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      initialBinding: SplashBinding(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
  FlutterNativeSplash.remove();
}
