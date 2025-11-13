import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

Future<void> initAudioSession(AudioPlayer player) async {
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.music());

  // Pause quand le casque est retiré
  session.becomingNoisyEventStream.listen((_) {
    player.pause();
  });

  // Gestion des erreurs du player
  player.playerStateStream.listen((state) {
    if (state.playing) {
      print("🎶 En lecture");
    } else if (state.processingState == ProcessingState.idle) {
      print("⚠️ Player idle, peut nécessiter rechargement");
    }
  });
}
