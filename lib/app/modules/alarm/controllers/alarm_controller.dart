import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:sindikat_app/app/routes/app_pages.dart';
import 'package:volume_controller/volume_controller.dart';

class AlarmController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = true.obs;
  double originalVolume = 0.5;

  @override
  void onInit() {
    super.onInit();
    _playSiren();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _playSiren() async {
    await setMaxVolume();
    await _audioPlayer.play(
      AssetSource('audios/siren-alarm.mp3'),
      volume: 1.0, // Set volume to maximum
    );
  }

  Future<void> setMaxVolume() async {
    originalVolume = await VolumeController().getVolume();
    VolumeController().maxVolume();
  }

  void stopAlarm() async {
    await _audioPlayer.stop();
    VolumeController().setVolume(originalVolume);
    isPlaying.value = false;
    Get.offAllNamed(Routes.NAVBAR);
  }
}
