import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/utils/navigation_observer.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';

class NavigationProvider extends ChangeNotifier {
  final bool hasMenu;

  late final navigatorKey = GlobalKey<NavigatorState>();
  late final menuNavigatorKey = hasMenu ? GlobalKey<NavigatorState>() : null;

  late final navigatorObserver = CustomNavigatorObserver(onNavigationStackChanged: notifyListeners);
  late final menuNavigatorObserver =
      hasMenu ? CustomNavigatorObserver(onNavigationStackChanged: notifyListeners) : null;

  NavigationProvider({this.hasMenu = false});

  bool _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  bool get isSearch =>
      navigatorObserver.navigationStack.isNotEmpty && navigatorObserver.navigationStack.last == '/search';

  bool get isHomeMenu => menuNavigatorObserver == null
      ? false
      : menuNavigatorObserver!.navigationStack.isNotEmpty && menuNavigatorObserver!.navigationStack.last == '/';

  bool get songLyricCanPopIndividually {
    if (menuNavigatorObserver == null) return true;

    return menuNavigatorObserver!.navigationStack.last != '/playlist' &&
        menuNavigatorObserver!.navigationStack.last != '/songbook' &&
        menuNavigatorObserver!.navigationStack.last != '/song_lyric/translations';
  }

  void toggleFullscreen() {
    _isFullScreen = !_isFullScreen;

    notifyListeners();
  }

  Future<T?>? pushNamed<T>(String name, {Object? arguments}) async {
    if (menuNavigatorKey == null) return navigatorKey.currentState?.pushNamed<T>(name, arguments: arguments);

    switch (name) {
      case '/playlist':
        final dataProvider = navigatorKey.currentContext!.read<DataProvider>();
        final songLyrics = dataProvider.getPlaylistsSongLyrics(arguments as Playlist);

        return _pushSongLyricsWithMenu(name, arguments, songLyrics, onSongLyricsEmpty: () {
          navigatorKey.currentState
              ?.pushNamed('/search', arguments: SearchScreenArguments(shouldReturnSongLyric: true))
              .then((songLyric) {
            if (songLyric != null && songLyric is SongLyric) {
              dataProvider.addToPlaylist(songLyric, arguments);

              navigatorKey.currentState?.pushNamed('/song_lyric', arguments: SongLyricScreenArguments([songLyric], 0));
            }
          });
        });
      case '/song_lyric':
        return navigatorKey.currentState?.pushNamed<T>(name, arguments: arguments);
      case '/song_lyric/translations':
        return _pushSongLyricsWithMenu(name, arguments, []);
      case '/songbook':
        final songLyrics =
            navigatorKey.currentContext!.read<DataProvider>().getSongbooksSongLyrics(arguments as Songbook);

        return _pushSongLyricsWithMenu(name, arguments, songLyrics);
      case '/user':
      case '/updated_song_lyrics':
        return menuNavigatorKey!.currentState?.pushNamed<T>(name, arguments: arguments);
      default:
        if (navigatorObserver.navigationStack.last == name) {
          return navigatorKey.currentState?.pushReplacementNamed<T, void>(name, arguments: arguments);
        }

        return navigatorKey.currentState?.pushNamed<T>(name, arguments: arguments);
    }
  }

  void popToOrPushNamed(String name, {Object? arguments}) {
    if (navigatorObserver.navigationStack.contains(name)) {
      navigatorKey.currentState?.popUntil(ModalRoute.withName(name));
    } else if (menuNavigatorObserver?.navigationStack.contains(name) ?? false) {
      menuNavigatorKey?.currentState?.popUntil(ModalRoute.withName(name));
    } else {
      pushNamed(name, arguments: arguments);
    }
  }

  Future<T?>? _pushSongLyricsWithMenu<T>(String name, Object? arguments, List<SongLyric> songLyrics,
      {Function()? onSongLyricsEmpty}) async {
    final oldRoute = navigatorObserver.currentRoute;

    if (songLyrics.isNotEmpty) {
      navigatorKey.currentState?.pushNamed(
        '/song_lyric',
        arguments: SongLyricScreenArguments(songLyrics, 0),
      );
    } else {
      onSongLyricsEmpty?.call();
    }

    final result = await menuNavigatorKey!.currentState?.pushNamed<T>(name, arguments: arguments);

    navigatorKey.currentState?.popUntil((route) => oldRoute == route);

    return result;
  }

  static NavigationProvider of(BuildContext context) {
    return context.read<NavigationProvider>();
  }

  static NavigatorState navigatorOf(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();

    return navigationProvider.navigatorKey.currentState ?? Navigator.of(context);
  }
}
