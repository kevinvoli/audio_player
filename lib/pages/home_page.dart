import 'package:audio_player/widget/progress_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:audio_player/services/audio_service.dart';
import 'package:audio_player/widget/payer_controls.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final audioService = AudioService();
  StreamSubscription<int?>? _indexSubscription;
  bool isRotating = false;

  @override
  void initState() {
    super.initState();
    _indexSubscription = audioService.player.currentIndexStream.listen((i) {
      if (!mounted) return;
      if (i != null && i < audioService.musics.length) {
        setState(() => audioService.setCurrentIndex(i));
      }
    });
  }

  @override
  void dispose() {
    _indexSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = audioService.currentSong;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Lecture en cours 🎵"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Jaquette animée
              GestureDetector(
                onTap: () => setState(() => isRotating = !isRotating),
                child: AnimatedRotation(
                  turns: isRotating ? 1 : 0,
                  duration: const Duration(seconds: 10),
                  curve: Curves.linear,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: (song?.picture != null)
                        ? MemoryImage(song!.picture!.data)
                        : const AssetImage('assets/placeholder.jpg')
                              as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ✅ Titre + artiste
              Text(
                song?.title ?? 'Titre inconnu',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                song?.artist ?? 'Artiste inconnu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),

              // ✅ Barre de progression
              ProgressBar(),
              const SizedBox(height: 30),

              // ✅ Contrôles audio
              PlayerControls(),

              const SizedBox(height: 20),

              // ✅ Boutons supplémentaires
            ],
          ),
        ),
      ),
    );
  }

  
}
