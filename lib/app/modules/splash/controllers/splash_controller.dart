import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnectivityAndNavigate();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void checkConnectivityAndNavigate() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult[0] == ConnectivityResult.none) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(Routes.OFFLINE);
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(Routes.LOGIN);
      });
    }
  }
}
