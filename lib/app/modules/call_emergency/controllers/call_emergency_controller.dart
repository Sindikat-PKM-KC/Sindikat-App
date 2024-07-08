import 'package:get/get.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

class CallEmergencyController extends GetxController {
  final countdown = 3.obs;
  var countdownInterrupted = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    if (countdown.value > 0 && !countdownInterrupted.value) {
      Future.delayed(const Duration(seconds: 1), () {
        countdown.value--;
        _startCountdown();
      });
    } else if (!countdownInterrupted.value) {
      _navigateToAlarm();
    }
  }

  void interruptCountdown() {
    countdownInterrupted.value = true;
    _navigateToNavbar();
  }

  void immediatelyDoAction() {
    countdownInterrupted.value = true;
    _navigateToAlarm();
  }

  void _navigateToAlarm() {
    Get.offAllNamed(Routes.ALARM);
  }

  void _navigateToNavbar() {
    Get.offAllNamed(Routes.NAVBAR);
  }
}
