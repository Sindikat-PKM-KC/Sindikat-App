import 'package:get/get.dart';

import '../modules/alarm/bindings/alarm_binding.dart';
import '../modules/alarm/views/alarm_view.dart';
import '../modules/call_emergency/bindings/call_emergency_binding.dart';
import '../modules/call_emergency/views/call_emergency_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/offline/bindings/offline_binding.dart';
import '../modules/offline/views/offline_view.dart';
import '../modules/playground/bindings/playground_binding.dart';
import '../modules/playground/views/playground_view.dart';
import '../modules/record/bindings/record_binding.dart';
import '../modules/record/views/record_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR,
      page: () => const NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PLAYGROUND,
      page: () => const PlaygroundView(),
      binding: PlaygroundBinding(),
    ),
    GetPage(
      name: _Paths.RECORD,
      page: () => const RecordView(),
      binding: RecordBinding(),
    ),
    GetPage(
      name: _Paths.CALL_EMERGENCY,
      page: () => const CallEmergencyView(),
      binding: CallEmergencyBinding(),
    ),
    GetPage(
      name: _Paths.ALARM,
      page: () => const AlarmView(),
      binding: AlarmBinding(),
    ),
    GetPage(
      name: _Paths.OFFLINE,
      page: () => const OfflineView(),
      binding: OfflineBinding(),
    ),
  ];
}
