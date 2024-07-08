import 'package:get/get.dart';

import '../controllers/call_emergency_controller.dart';

class CallEmergencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallEmergencyController>(
      () => CallEmergencyController(),
    );
  }
}
