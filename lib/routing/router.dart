import 'package:flutter/material.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/screens/about.dart';
import 'package:zpevnik/screens/display.dart';
import 'package:zpevnik/screens/home.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/song_lyric/jpg.dart';
import 'package:zpevnik/screens/song_lyric/pdf.dart';
import 'package:zpevnik/screens/playlist.dart';
import 'package:zpevnik/screens/playlist/select_bible_verse.dart';
import 'package:zpevnik/screens/playlists.dart';
import 'package:zpevnik/screens/search.dart';
import 'package:zpevnik/screens/songbook.dart';
import 'package:zpevnik/screens/songbooks.dart';
import 'package:zpevnik/screens/start_presentation_screen.dart';
import 'package:zpevnik/screens/updated_song_lyrics.dart';
import 'package:zpevnik/screens/settings.dart';

final class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    final (builder, fullScreenDialog) = switch (uri.path) {
      'initial' => ((_) => const InitialScreen(), false),
      '/' => ((_) => const HomeScreen(), false),
      '/about' => ((_) => const AboutScreen(), false),
      '/display' => (
          (context) {
            final arguments = settings.arguments as DisplayScreenArguments;

            return DisplayScreen(
              items: arguments.items,
              initialIndex: arguments.initialIndex,
              playlist: arguments.playlist,
            );
          },
          false
        ),
      '/playlist' => ((_) => PlaylistScreen(playlist: settings.arguments as Playlist), false),
      '/playlist/bible_verse/select_verse' => (
          (_) => SelectBibleVerseScreen(bibleVerse: settings.arguments as BibleVerse?),
          true
        ),
      '/playlists' => ((_) => const PlaylistsScreen(), false),
      '/search' => ((_) => const SearchScreen(), true),
      '/settings' => ((_) => const SettingsScreen(), true),
      '/songbook' => ((_) => SongbookScreen(songbook: settings.arguments as Songbook), false),
      '/songbooks' => ((_) => const SongbooksScreen(), false),
      '/song_lyric' => (
          (context) {
            if (uri.queryParameters.containsKey('id')) {
              final id = int.parse(uri.queryParameters['id']!);
              final songLyric = context.providers.read(songLyricProvider(id));

              if (songLyric != null) return DisplayScreen(items: [songLyric]);
            }

            // should not get here
            throw UnimplementedError();
          },
          false
        ),
      '/song_lyric/jpg' => ((_) => JpgScreen(jpg: settings.arguments as External), true),
      '/song_lyric/pdf' => ((_) => PdfScreen(pdf: settings.arguments as External), true),
      '/song_lyric/present' => ((_) => StartPresentationScreen(songLyric: settings.arguments as SongLyric), true),
      '/updated_song_lyrics' => (
          (_) => UpdatedSongLyricsScreen(songLyrics: settings.arguments as List<SongLyric>),
          false,
        ),
      _ => throw 'Unknown route: ${settings.name}',
    };

    return CustomPageRoute(
      settings: settings,
      builder: builder,
      fullscreenDialog: fullScreenDialog,
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({required super.builder, super.settings, super.fullscreenDialog});

  // @override
  // Duration get transitionDuration => const Duration(seconds: 3);
}
