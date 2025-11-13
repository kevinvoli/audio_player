import 'package:audio_player/services/audio_service.dart';

void togglePlayerPause() {
  final audioService = AudioService();
  if (audioService.player.playing) {

    audioService.player.pause();
  } else {

    audioService.player.play();

  }
}
