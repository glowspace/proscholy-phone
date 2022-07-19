import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final List<String> navigationStack = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    navigationStack.add(route.settings.name!);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    navigationStack.removeLast();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    navigationStack.removeWhere((name) => name == route.settings.name);
  }
}
