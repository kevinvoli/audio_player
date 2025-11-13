import 'package:audio_player/pages/home_page.dart';
import 'package:audio_player/pages/play_list_page.dart';
import 'package:flutter/material.dart';

class NavBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavBarWidgetState();
}

class NavBarWidgetState extends State<NavBarWidget> {
  int currentPageIndex = 1;
  final List<Widget> _pages = [const HomePage(), PlayListPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: "home"),
          NavigationDestination(
            icon: Icon(Icons.list_sharp),
            label: "play list",
          ),
          // NavigationDestination(icon: Icon(Icons.add_to_queue), label: "add"),
        ],
      ),
    );
  }
}
