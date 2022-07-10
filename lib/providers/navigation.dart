import 'package:flutter/material.dart';

class NavigationProvider extends NavigatorObserver {
  Route? _searchScreenRoute;
  Route? _translationsScreenRoute;

  Route? get searchScreenRoute => _searchScreenRoute;
  Route? get translationsScreenRoute => _translationsScreenRoute;

  bool get isPreviousSearchScreenRoute => _searchScreenRoute != null;
  bool get isPreviousTranslationsScreenRoute => _translationsScreenRoute != null;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    _searchScreenRoute = null;
    _translationsScreenRoute = null;

    if (previousRoute?.settings.name == '/search') {
      _searchScreenRoute = previousRoute;
    } else if (previousRoute?.settings.name == '/song_lyrics/translations') {
      _translationsScreenRoute = previousRoute;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    _searchScreenRoute = null;
    _translationsScreenRoute = null;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    _searchScreenRoute = null;
    _translationsScreenRoute = null;
  }
}
