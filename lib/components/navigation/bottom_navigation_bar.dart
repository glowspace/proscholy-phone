import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/navigation/utils.dart';
import 'package:zpevnik/routing/router.dart';

const double _navigationBarHeight = 64;

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Hero(
      tag: 'bottomNavigationBar',
      transitionOnUserGestures: true,
      child: NavigationBar(
        backgroundColor: context.isHome ? theme.canvasColor : null,
        surfaceTintColor: context.isHome ? theme.canvasColor : null,
        selectedIndex: context.isHome ? 0 : (context.isSearching ? 1 : 2),
        height: _navigationBarHeight,
        onDestinationSelected: (index) => onDestinationSelected(context, ref, index),
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
