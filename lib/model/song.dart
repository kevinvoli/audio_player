import 'dart:typed_data';

import 'package:metadata_god/metadata_god.dart';

class Song {
  final String? title;
  final String? artist;
  final String? album;
  final String? genre;
  final int? year;
  final String? albumArtist;
  final int? trackNumber;
  final int? trackTotal;
  final int? discNumber;
  final int? discTotal;
  final int? durationMs;
  final String? fileSize;
  final Picture? picture;

  final String path;

  Song({
    required this.path,
    this.title,
    this.artist,
    this.album,
    this.genre,
    this.year,
    this.albumArtist,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.durationMs,
    this.fileSize,
    this.picture,
  });

  /// 🔄 Convertit un objet [Metadata] de metadata_god en [Song]
  factory Song.fromMetadata(Metadata meta ,{required String path}) {
    return Song(
      path: path,
      title: meta.title,
      artist: meta.artist,
      album: meta.album,
      genre: meta.genre,
      year: meta.year,
      albumArtist: meta.albumArtist,
      trackNumber: meta.trackNumber,
      trackTotal: meta.trackTotal,
      discNumber: meta.discNumber,
      discTotal: meta.discTotal,
      durationMs: meta.duration?.inMilliseconds,
      fileSize: meta.fileSize?.toString(),
      picture: meta.picture,
    );
  }

  @override
  String toString() {
    return 'Song(title: $title, artist: $artist, album: $album, durationMs: $durationMs)';
  }
}

/// Classe représentant la jaquette (cover)
class PictureData {
  final Uint8List? bytes;
  final String? mimeType;

  PictureData({this.bytes, this.mimeType});
}
