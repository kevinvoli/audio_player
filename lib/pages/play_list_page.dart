import 'package:audio_player/services/audio_service.dart';
import 'package:audio_player/services/file_service.dart';
import 'package:audio_player/widget/payer_controls.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:metadata_god/metadata_god.dart';

class PlayListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayListPageState();
}

class PlayListPageState extends State<PlayListPage> {
  final audioService = AudioService();
  Metadata? metadata;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadSongs() async {
    await FileService.pickMultipleFiles(context);
    setState(() {}); // pour rafraîchir la liste
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final musics = audioService.musics;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _loadSongs, icon: Icon(Icons.queue_music)),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          (musics.isEmpty
              ? "Artiste unconue"
              : musics[audioService.currentIndex].artist.toString()),
        ),
      ),

      body: musics.isEmpty
          ? const Center(child: Text("Aucune musique trouvée"))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlayerControls(),
                  Expanded(
                    child: ListView.separated(
                      itemCount: musics.length,
                      itemBuilder: (BuildContext context, index) {
                        return tile(index);
                      },
                      separatorBuilder: (BuildContext context, index) {
                        return const Divider();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  StreamBuilder<PlayerState> tile(int index) {
    final song = audioService.musics[index];
    final player = audioService.player;

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, playerStateSnapshot) {
        final playing = player.playing;

        return StreamBuilder<int?>(
          stream: player.currentIndexStream,
          builder: (context, indexSnapshot) {
            final currentIndex =
                indexSnapshot.data ?? audioService.currentIndex;
            final isCurrent = currentIndex == index;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: (song.picture != null)
                  ? Image.memory(song.picture!.data, fit: BoxFit.cover)
                  : const Icon(Icons.music_note, size: 60),

              // ✅ icône dynamique selon l’état actuel
              trailing: Icon(
                isCurrent
                    ? (playing ? Icons.pause_circle : Icons.play_circle)
                    : Icons.play_arrow_rounded,
                size: 40,
              ),

              title: Text(song.title ?? "Sans titre"),
              subtitle: Text(song.artist ?? ""),
              onTap: () => audioService.seekToIndex(index),
            );
          },
        );
      },
    );
  }

 
}
