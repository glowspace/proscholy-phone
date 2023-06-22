import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/routing/router.dart';

const double _navigationBarHeight = 64;

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Hero(
      tag: 'bottomNavigationBar',
      transitionOnUserGestures: true,
      child: NavigationBar(
        backgroundColor: context.isHome ? theme.canvasColor : null,
        surfaceTintColor: context.isHome ? theme.canvasColor : null,
        selectedIndex: context.isHome ? 0 : (context.isSearching ? 1 : 2),
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
      context.push('/search');
    } else if (index == 2) {
      // TODO: should pop if already inside of playlists subtree
      context.push('/playlists');
    } else {
      context.popUntil('/');
    }
  }
}
