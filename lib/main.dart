import 'package:audio_player/services/audio_service.dart';
import 'package:audio_player/widget/nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MetadataGod.initialize();
  final audioService = AudioService();
  audioService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'v-lecteur',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),

      home: NavBarWidget(),
    );
  }
}
