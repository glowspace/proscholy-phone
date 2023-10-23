import 'package:flutter/material.dart';
import 'package:zpevnik/components/navigation/utils.dart';
import 'package:zpevnik/utils/extensions.dart';

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
        backgroundColor: context.isHome ? theme.colorScheme.surface : null,
        surfaceTintColor: context.isHome ? theme.colorScheme.surface : null,
        selectedIndex: context.isHome ? 0 : (context.isSearching ? 1 : 2),
        height: _navigationBarHeight,
        onDestinationSelected: (index) => onDestinationSelected(context, index),
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
}
