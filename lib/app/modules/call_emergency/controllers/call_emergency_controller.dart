import 'package:get/get.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:phone_state/phone_state.dart';

class CallEmergencyController extends GetxController {
  final countdown = 3.obs;
  var countdownInterrupted = false.obs;
  var phoneNumber = '082146560178';

  @override
  void onInit() {
    super.onInit();
    _makeInitialCall();
    _listenForCallEnd();
  }

  Future<void> _makeInitialCall() async {
    await makePhoneCall(phoneNumber);
  }

  void _listenForCallEnd() {
    PhoneState.stream.listen((event) {
      if (event.status == PhoneStateStatus.CALL_ENDED &&
          phoneNumber == event.number) {
        _startCountdown();
      }
    });
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

  Future<void> makePhoneCall(String phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (e) {
      print(e);
    }
  }
}
