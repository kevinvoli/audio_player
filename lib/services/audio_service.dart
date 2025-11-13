import 'package:audio_player/model/song.dart';
import 'package:audio_player/utils/session_helper.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer player = AudioPlayer();
  List<Song> musics = [];
  int currentIndex = 0;

  // Méthode itile

  void setMusics(List<Song> songs) {
    musics = songs;
    // _loadCurrentSong();
  }

  void addSongs(Song song) {
    musics.add(song);
    // if (musics.length == 1) _loadCurrentSong();
  }

  Song? get currentSong {
    if (musics.isEmpty) return null;
    return musics[currentIndex];
  }

  void setCurrentIndex(int index) {
    print("❌index selected: ${index}");
    if (index < 0 || index >= musics.length) return;
    print("❌index selected apres: ${index}");

    currentIndex = index;
    player.play();
  }

  // ------------------------
  // Lecture
  // ------------------------

  void togglePlayPause() async {
    if (player.playing) {
      print("❌ en pause 111: ${musics[currentIndex].path}");
      player.pause();
    } else {
      print("❌ en pause donc play: ${musics[currentIndex].path}");
      player.play();
    }
  }

  Future<void> seekToNext() async {
    if (player.hasNext) {
      await player.seekToNext();
      await player.play();
    } else {}
  }

  void seekToPrevious() async {
    if (player.hasPrevious) {
      await player.seekToPrevious();
      await player.play();
    } else {
      // si tu veux revenir au début
      await player.seek(Duration.zero, index: 0);
    }
  }

  void seekToIndex(int index) async {
    if (index != currentIndex) {
      await player.seek(Duration.zero, index: index);
      await player.play();
    } else {
      // si tu veux revenir au début
      await player.seek(Duration.zero, index: 0);
    }
  }

  Future<void> initialize() async {
    await initAudioSession(player);
    player.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < musics.length) {
        currentIndex = index;
      }
    });
  }

  // ------------------------
  // Chargement du morceau courant
  // ------------------------
}
