import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/recent_items.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/utils/extensions.dart';

part 'navigator_observer.g.dart';

@Riverpod(keepAlive: true)
AppNavigatorObserver appNavigatorObserver(AppNavigatorObserverRef ref) => AppNavigatorObserver();

class AppNavigatorObserver extends NavigatorObserver {
  final Set<String> _pathsInStack = {};

  bool isPathInStack(String name) => _pathsInStack.contains(name);

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    log('pushed: $route from: $previousRoute', name: 'APP_NAVIGATOR');

    final name = route.settings.name;

    if (name != null) _pathsInStack.add(name);
    _handleWakeLock(name);

    // handle recent items with delay, so it is not visible to user during push
    Future.delayed(const Duration(milliseconds: 100), () => _handleRecentItems(route, previousRoute));
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    _pathsInStack.remove(route.settings.name);
    _handleWakeLock(previousRoute?.settings.name);

    log('popped: $route to: $previousRoute', name: 'APP_NAVIGATOR');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    log('replaced: $oldRoute to: $newRoute', name: 'APP_NAVIGATOR');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    log('removed: $route to: $previousRoute', name: 'APP_NAVIGATOR');
  }

  // enable wakelock for `SongLyricScreen` disable for other screens
  void _handleWakeLock(String? routeName) {
    if (routeName == '/display') {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  void _handleRecentItems(Route route, Route? previousRoute) {
    final context = route.navigator?.context;

    if (context == null) return;

    final recentItemsNotifier = context.providers.read(recentItemsProvider.notifier);

    switch (route.settings.name) {
      case '/display':
        final arguments = route.settings.arguments as DisplayScreenArguments?;

        if (arguments != null) {
          if (previousRoute?.settings.name == '/search') {
            context.providers
                .read(recentSongLyricsProvider.notifier)
                .add(arguments.items[arguments.initialIndex] as SongLyric);
          } else {
            recentItemsNotifier.add(arguments.items[arguments.initialIndex]);
          }
        }

        break;
      case '/playlist':
        final playlist = route.settings.arguments as Playlist?;

        if (playlist != null) recentItemsNotifier.add(playlist);

        break;
      case '/songbook':
        final songbook = route.settings.arguments as Songbook?;

        if (songbook != null) recentItemsNotifier.add(songbook);

        break;
    }
  }
}
