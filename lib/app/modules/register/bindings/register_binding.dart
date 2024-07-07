import 'package:get/get.dart';

import 'package:sindikat_app/app/modules/register/controllers/emergency_controller.dart';

import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmergencyController>(
      () => EmergencyController(),
    );
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
  }
}
