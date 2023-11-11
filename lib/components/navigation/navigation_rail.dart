import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/navigation/utils.dart';
import 'package:zpevnik/components/split_view.dart';
import 'package:zpevnik/providers/menu_collapsed.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/hero_tags.dart';

// checked using widget inspector tools
const _navigationRailWidth = 80;

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // can't set `surfaceTintColor` for `NavigationRail`, so it is wrapped to match the app bar color
    return Hero(
      tag: HeroTags.navigationRail,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (context.isHome)
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(2, 0),
              ),
          ],
        ),
        child: Material(
          color: context.isHome ? theme.colorScheme.surface : theme.colorScheme.surface,
          elevation: 1,
          surfaceTintColor: context.isHome ? null : theme.colorScheme.surfaceTint,
          child: NavigationRail(
            backgroundColor: Colors.transparent,
            labelType: NavigationRailLabelType.all,
            groupAlignment: context.isHome ? 0 : -0.155,
            selectedIndex: context.isHome ? 0 : (context.isSearching ? 1 : 2),
            onDestinationSelected: (index) => onDestinationSelected(context, index),
            leading: context.isHome
                ? null
                : Column(children: [
                    Image.asset('assets/images/logos/logo.png'),
                    if (MediaQuery.sizeOf(context).width - _navigationRailWidth >
                            (kDefaultSplitViewChildMinWidth + kDefaultSplitViewDetailMinWidth) &&
                        (context.isPlaylist || context.isDisplay))
                      Highlightable(
                        onTap: context.providers.read(menuCollapsedProvider.notifier).toggle,
                        icon: Consumer(
                          builder: (_, ref, __) => Icon(
                            ref.watch(menuCollapsedProvider) ? Icons.menu : Icons.menu_open,
                          ),
                        ),
                      ),
                  ]),
            destinations: const [
              NavigationRailDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: Text('Nástěnka'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                label: Text('Hledání'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.playlist_play_rounded),
                label: Text('Seznamy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
