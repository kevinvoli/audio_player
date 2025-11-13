import 'package:audio_player/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService();
    print("ma music :  ${audioService.currentSong}");
    return StreamBuilder(
      stream: audioService.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;
        final processingState = playerState?.processingState;

        final isLoading =
            processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: audioService.player.hasPrevious
                  ? audioService.seekToPrevious
                  : null,
              icon: const Icon(Icons.skip_previous, size: 40),
            ),

            // Bouton Play/Pause avec synchronisation réelle
            IconButton(
              onPressed: isLoading
                  ? null
                  : () => audioService.togglePlayPause(),
              icon: Icon(
                playing ? Icons.pause_circle : Icons.play_circle,
                size: 60,
              ),
            ),

            IconButton(
              onPressed: audioService.player.hasNext
                  ? audioService.seekToNext
                  : null,
              icon: const Icon(Icons.skip_next, size: 40),
            ),
          ],
        );
      },
    );
  }
}
