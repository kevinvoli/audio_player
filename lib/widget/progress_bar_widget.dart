import 'package:flutter/material.dart';
import 'package:audio_player/services/audio_service.dart';
import 'dart:async';

class ProgressBar extends StatefulWidget {
  final audioService = AudioService();

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  Duration? loopStart;
  Duration? loopEnd;
  bool isLooping = false;
  late StreamSubscription<Duration> _positionSub;

  @override
  void initState() {
    super.initState();
    _positionSub = widget.audioService.player.positionStream.listen((position) {
      if (isLooping && loopStart != null && loopEnd != null) {
        if (position >= loopEnd!) {
          widget.audioService.player.seek(loopStart!);
        }
      }
    });
  }

  @override
  void dispose() {
    _positionSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: widget.audioService.player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = widget.audioService.player.duration ?? Duration.zero;

        return Column(
          children: [
            // --- BARRE PRINCIPALE ---
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    activeColor: Colors.purpleAccent,
                    inactiveColor: Colors.white24,
                    value: position.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble(),
                    onChanged: (v) => widget.audioService.player.seek(
                      Duration(seconds: v.toInt()),
                    ),
                  ),
                ),

                // --- INDICATEUR DE LOOP A ---
                if (loopStart != null)
                  Positioned(
                    left: _calcLoopMarker(loopStart!, duration, context),
                    child: Container(
                      width: 2,
                      height: 18,
                      color: Colors.greenAccent,
                    ),
                  ),

                // --- INDICATEUR DE LOOP B ---
                if (loopEnd != null)
                  Positioned(
                    left: _calcLoopMarker(loopEnd!, duration, context),
                    child: Container(
                      width: 2,
                      height: 18,
                      color: Colors.redAccent,
                    ),
                  ),
              ],
            ),

            // --- TEMPS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(position),
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  _formatTime(duration),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            // --- BOUTONS LOOP ---
            loopButton(position),
          ],
        );
      },
    );
  }

  double _calcLoopMarker(Duration mark, Duration total, BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40; // padding global
    final percent = mark.inMilliseconds / total.inMilliseconds;
    return width * percent;
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}';
  }

  Widget loopButton(Duration position) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => setState(() {
            loopStart = position;
            if (loopEnd != null && loopEnd!.inSeconds <= loopStart!.inSeconds) {
              loopEnd = null;
              isLooping = false;
            }
          }),
          icon: Icon(
            Icons.playlist_add_check_circle,
            color: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () => setState(() {
            loopEnd = position;
            if (loopStart != null &&
                loopEnd!.inSeconds > loopStart!.inSeconds) {
              isLooping = true;
            }
          }),

          icon: Icon(Icons.playlist_add_circle, color: Colors.redAccent),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () => setState(() {
            loopStart = null;
            loopEnd = null;
            isLooping = false;
          }),

          icon: Icon(Icons.restart_alt, color: Colors.grey),
        ),
      ],
    );
  }
}
