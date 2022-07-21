import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final Function? onNavigationStackChanged;

  final List<String> navigationStack;

  CustomNavigatorObserver({this.onNavigationStackChanged}) : navigationStack = [];

  Route? _currentRoute;

  Route? get currentRoute => _currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    _currentRoute = route;

    final name = route.settings.name;

    if (name != null) {
      navigationStack.add(name);

      if (name == '/song_lyric') {
        Wakelock.enable();
      } else {
        Wakelock.disable();
      }

      if (navigationStack.length != 1) onNavigationStackChanged?.call();
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    _currentRoute = previousRoute;

    if (previousRoute?.settings.name == '/song_lyric') {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }

    if (route.settings.name != null) {
      navigationStack.removeLast();
      onNavigationStackChanged?.call();
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    _currentRoute = previousRoute;

    navigationStack.removeWhere((name) => name == route.settings.name);
    onNavigationStackChanged?.call();
  }
}
