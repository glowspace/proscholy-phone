import 'package:flutter/material.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/screens/about.dart';
import 'package:zpevnik/screens/home.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/playlist.dart';
import 'package:zpevnik/screens/playlist/bible_verse.dart';
import 'package:zpevnik/screens/playlist/custom_text.dart';
import 'package:zpevnik/screens/playlists.dart';
import 'package:zpevnik/screens/search.dart';
import 'package:zpevnik/screens/song_lyric.dart';
import 'package:zpevnik/screens/songbook.dart';
import 'package:zpevnik/screens/songbooks.dart';
import 'package:zpevnik/screens/updated_song_lyrics.dart';
import 'package:zpevnik/screens/settings.dart';

extension AppNavigatorHelper on BuildContext {
  bool get isHome => ModalRoute.of(this)?.settings.name == '/';
  bool get isPlaylist => ModalRoute.of(this)?.settings.name == '/playlist';
  bool get isSearching => ModalRoute.of(this)?.settings.name == '/search';

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  void popUntil(String routeName) {
    Navigator.of(this).popUntil((route) => route.settings.name == routeName);
  }

  Future<T?> popAndPush<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.of(this).popAndPushNamed(routeName, arguments: arguments);
  }

  void maybePop<T>([T? result]) {
    Navigator.of(this).maybePop(result);
  }

  void replace(String routeName) {
    Navigator.of(this).pushReplacementNamed(routeName);
  }
}

final class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final (builder, fullScreenDialog) = switch (settings.name) {
      '/' => ((_) => const HomeScreen(), false),
      '/about' => ((_) => const AboutScreen(), false),
      'initial' => ((_) => const InitialScreen(), false),
      '/playlist' => ((_) => PlaylistScreen(playlist: settings.arguments as Playlist), false),
      '/playlist/bible_verse' => ((_) => BibleVerseScreen(bibleVerse: settings.arguments as BibleVerse), false),
      '/playlist/custom_text' => ((_) => CustomTextScreen(customText: settings.arguments as CustomText), false),
      '/playlists' => ((_) => const PlaylistsScreen(), false),
      '/search' => ((_) => const SearchScreen(), true),
      '/settings' => ((_) => const SettingsScreen(), false),
      '/songbook' => ((_) => SongbookScreen(songbook: settings.arguments as Songbook), false),
      '/songbooks' => ((_) => const SongbooksScreen(), false),
      '/song_lyric' => ((_) => SongLyricScreen(songLyrics: [settings.arguments as SongLyric], initialIndex: 0), false),
      '/updated_song_lyrics' => (
          (_) => UpdatedSongLyricsScreen(songLyrics: settings.arguments as List<SongLyric>),
          false,
        ),
      _ => throw 'Unknown route: ${settings.name}',
    };

    return MaterialPageRoute(
      settings: settings,
      builder: builder,
      fullscreenDialog: fullScreenDialog,
    );
  }
}
