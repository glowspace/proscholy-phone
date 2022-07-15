import 'package:flutter/material.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/routes/arguments/search.dart';

const double _navigationBarHeight = 64;

class CustomBottomNavigationBar extends StatelessWidget {
  final Playlist? playlist;
  final Songbook? songbook;

  const CustomBottomNavigationBar({Key? key, this.playlist, this.songbook}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'bottomNavigationBar',
      child: NavigationBar(
        selectedIndex: ModalRoute.of(context)?.settings.name == '/home' ? 0 : 2,
        height: _navigationBarHeight,
        onDestinationSelected: (index) => _onDestinationSelected(context, index),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Nástěnka',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Hledání',
          ),
          NavigationDestination(
            icon: Icon(Icons.playlist_play_rounded),
            label: 'Seznamy',
          ),
        ],
      ),
    );
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == 1) {
      Navigator.of(context)
          .pushNamed('/search', arguments: SearchScreenArguments(playlist: playlist, songbook: songbook));
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/playlists');
    } else {
      Navigator.of(context).popUntil((route) => route.settings.name == '/home');
    }
  }
}
