import 'dart:async';

import 'package:audio_player/services/audio_service.dart';
import 'package:audio_player/widget/payer_controls.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final  audioService = AudioService();
   StreamSubscription<int?>? _indexSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("🔊 Nombre de musiques reçues : ${audioService.musics.length}");
  _indexSubscription = audioService.player.currentIndexStream.listen((i) {
      if (!mounted) return; // sécurité : ne rien faire si la page est détruite
      if (i != null && i < audioService.musics.length) {
        setState(() => audioService.setCurrentIndex(i));
      }
    });
  }

   @override
  void dispose() {
    // Annuler le listener pour éviter les erreurs de setState après destruction
    _indexSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 
     final song = audioService.currentSong;

    return Scaffold(
      appBar: AppBar(title: const Text("lecture en cours")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (song?.picture != null && song != null)
                ? Image.memory(song.picture!.data, height: 200)
                : const SizedBox(height: 20),
            Text(
              song?.title ?? 'Titre inconnu',
              style: TextStyle(fontSize: 22),
            ),
            Text(song?.artist ?? '', style: TextStyle(color: Colors.blueGrey)),
            const SizedBox(height: 20),
            PlayerControls(),
          ],
        ),
      ),
    );
  }
}
