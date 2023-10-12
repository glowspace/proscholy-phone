import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
}
