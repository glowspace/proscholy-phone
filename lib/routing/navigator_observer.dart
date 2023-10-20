import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/recent_items.dart';
import 'package:zpevnik/routing/arguments.dart';

part 'navigator_observer.g.dart';

@Riverpod(keepAlive: true)
AppNavigatorObserver appNavigatorObserver(AppNavigatorObserverRef ref) => AppNavigatorObserver();

class AppNavigatorObserver extends NavigatorObserver {
  bool _isPlaylistsRouteInStack = false;
  bool _isSearchRouteInStack = false;

  bool get isPlaylistsRouteInStack => _isPlaylistsRouteInStack;
  bool get isSearchRouteInStack => _isSearchRouteInStack;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    log('pushed: $route from: $previousRoute', name: 'APP_NAVIGATOR');

    final name = route.settings.name;

    _changeRouteStack(name, true);
    _handleWakeLock(name);

    // handle recent items with delay, so it is not visible to user during push
    Future.delayed(const Duration(milliseconds: 100), () => _handleRecentItems(route));
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    _changeRouteStack(route.settings.name, false);
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

  void _changeRouteStack(String? routeName, bool isPushing) {
    switch (routeName) {
      case '/search':
        _isSearchRouteInStack = isPushing;
        break;
      case '/playlists':
        _isPlaylistsRouteInStack = isPushing;
        break;
    }
  }

  // enable wakelock for `SongLyricScreen` disable for other screens
  void _handleWakeLock(String? routeName) {
    if (routeName == '/song_lyric') {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  void _handleRecentItems(Route route) {
    final context = route.navigator?.context;

    if (context == null) return;

    final recentItemsNotifier = ProviderScope.containerOf(context).read(recentItemsProvider.notifier);

    switch (route.settings.name) {
      case '/playlist/bible_verse':
        final bibleVerse = route.settings.arguments as BibleVerse?;

        if (bibleVerse != null) recentItemsNotifier.add(bibleVerse);

        break;
      case '/playlist/custom_text':
        final customText = route.settings.arguments as CustomText?;

        if (customText != null) recentItemsNotifier.add(customText);

        break;
      case '/playlist':
        final playlist = route.settings.arguments as Playlist?;

        if (playlist != null) recentItemsNotifier.add(playlist);

        break;
      case '/songbook':
        final songbook = route.settings.arguments as Songbook?;

        if (songbook != null) recentItemsNotifier.add(songbook);

        break;
      case '/song_lyric':
        final arguments = route.settings.arguments as SongLyricScreenArguments?;

        if (arguments != null) {
          ProviderScope.containerOf(context)
              .read(recentSongLyricsProvider.notifier)
              .add(arguments.songLyrics[arguments.initialIndex]);
        }

        break;
    }
  }
}
