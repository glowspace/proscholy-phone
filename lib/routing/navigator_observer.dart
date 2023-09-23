import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock/wakelock.dart';

part 'navigator_observer.g.dart';

@Riverpod(keepAlive: true)
AppNavigator appNavigator(AppNavigatorRef ref) => AppNavigator();

class AppNavigator extends NavigatorObserver {
  bool _isSearchRouteInStack = false;

  bool get isSearchRouteInStack => _isSearchRouteInStack;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    log('pushed: $route from: $previousRoute', name: 'APP_NAVIGATOR');

    final name = route.settings.name;

    if (name == '/search') _isSearchRouteInStack = true;

    _handleWakeLock(name);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    final name = route.settings.name;

    if (name == '/search') _isSearchRouteInStack = false;

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
    if (routeName == '/song_lyric') {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
  }
}
