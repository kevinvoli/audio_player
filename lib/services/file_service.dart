import 'dart:io';
import 'package:audio_player/utils/permission.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:flutter/material.dart';

import '../model/song.dart';
import 'audio_service.dart';

class FileService {
  static Future<void> pickMultipleFiles(BuildContext context) async {
    final audioService = AudioService();
    if (!await requestStoragePermission(context)) return;

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return;

    final directory = Directory(selectedDirectory);
    final audioFiles = directory
        .listSync()
        .whereType<File>()
        .where(
          (f) =>
              f.path.endsWith('.mp3') ||
              f.path.endsWith('.wav') ||
              f.path.endsWith('.m4a'),
        )
        .toList();

    if (audioFiles.isEmpty) {
      print("aucun fichier audio trouvé");
      return;
    }

    audioService.musics.clear();

    // Charger toutes les métadonnées avant de créer la playlist
    for (final file in audioFiles) {
      final meta = await MetadataGod.readMetadata(file: file.path);
      print("le chemin du fichier:${file}");
      final song = Song.fromMetadata(meta, path: file.path);
      audioService.addSongs(song);
    }

    // Stopper le player avant de charger la playlist
    await audioService.player.stop();

    final playlist = audioService.musics
        .map((song) => AudioSource.uri(Uri.file(song.path)))
        .toList();

    await audioService.player.setAudioSources(playlist);
    debugPrint("✅ ${playlist.length} fichiers audio chargés !");
  }
}
