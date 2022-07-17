import 'package:flutter/material.dart';

class NavigationProvider extends NavigatorObserver {
  Route? _playlistsScreenRoute;
  Route? _searchScreenRoute;
  Route? _translationsScreenRoute;

  Route? get playlistsScreenRoute => _playlistsScreenRoute;
  Route? get searchScreenRoute => _searchScreenRoute;
  Route? get translationsScreenRoute => _translationsScreenRoute;

  bool get hasPlaylistsScreenRoute => _playlistsScreenRoute != null;
  bool get hasSearchScreenRoute => _searchScreenRoute != null;
  bool get hasTranslationsScreenRoute => _translationsScreenRoute != null;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (route.settings.name == '/playlists') {
      _playlistsScreenRoute = route;
    } else if (route.settings.name == '/search') {
      _searchScreenRoute = route;
    } else if (route.settings.name == '/song_lyrics/translations') {
      _translationsScreenRoute = route;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    if (route == _playlistsScreenRoute) {
      _playlistsScreenRoute = null;
    } else if (route == _searchScreenRoute) {
      _searchScreenRoute = null;
    } else if (route == _translationsScreenRoute) {
      _translationsScreenRoute = null;
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    if (route == _playlistsScreenRoute) {
      _playlistsScreenRoute = null;
    } else if (route == _searchScreenRoute) {
      _searchScreenRoute = null;
    } else if (route == _translationsScreenRoute) {
      _translationsScreenRoute = null;
    }
  }
}
