import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/utils/navigation_observer.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';

class NavigationProvider extends ChangeNotifier {
  final bool hasMenu;

  late final navigatorKey = GlobalKey<NavigatorState>();
  late final menuNavigatorKey = hasMenu ? GlobalKey<NavigatorState>() : null;

  late final navigatorObserver = CustomNavigatorObserver(onNavigationStackChanged: notifyListeners);
  late final menuNavigatorObserver =
      hasMenu ? CustomNavigatorObserver(onNavigationStackChanged: notifyListeners) : null;

  NavigationProvider({this.hasMenu = false});

  static NavigationProvider of(BuildContext context) {
    return context.read<NavigationProvider>();
  }

  static NavigatorState navigatorOf(BuildContext context) {
    final navigationProvider = context.read<NavigationProvider>();

    return navigationProvider.navigatorKey.currentState ?? Navigator.of(context);
  }

  Future<T?>? pushNamed<T>(String name, {Object? arguments}) {
    switch (name) {
      case '/playlist':
        final songLyrics =
            navigatorKey.currentContext!.read<DataProvider>().getPlaylistsSongLyrics(arguments as Playlist);

        if (songLyrics.isNotEmpty) {
          navigatorKey.currentState?.pushNamed('/song_lyric', arguments: SongLyricScreenArguments(songLyrics, 0));
        }

        return _maybeMenuNavigator.currentState?.pushNamed(name, arguments: arguments);
      case '/songbook':
        final songLyrics =
            navigatorKey.currentContext!.read<DataProvider>().getSongbooksSongLyrics(arguments as Songbook);

        if (songLyrics.isNotEmpty) {
          navigatorKey.currentState?.pushNamed('/song_lyric', arguments: SongLyricScreenArguments(songLyrics, 0));
        }

        return _maybeMenuNavigator.currentState?.pushNamed(name, arguments: arguments);
      default:
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

  // TODO: temporary solution, just to test animation on real device
  Future<bool> willPop() async {
    if (menuNavigatorKey != null) navigatorKey.currentState?.maybePop();

    return true;
  }

  bool get isSearch =>
      navigatorObserver.navigationStack.isNotEmpty && navigatorObserver.navigationStack.last == '/search';

  GlobalKey<NavigatorState> get _maybeMenuNavigator => menuNavigatorKey ?? navigatorKey;
}
