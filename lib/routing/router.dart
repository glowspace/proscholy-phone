import 'package:flutter/material.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/screens/about.dart';
import 'package:zpevnik/screens/home.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/song_lyric/jpg.dart';
import 'package:zpevnik/screens/song_lyric/pdf.dart';
import 'package:zpevnik/screens/playlist.dart';
import 'package:zpevnik/screens/playlist/bible_verse.dart';
import 'package:zpevnik/screens/playlist/custom_text.dart';
import 'package:zpevnik/screens/playlist/select_bible_verse.dart';
import 'package:zpevnik/screens/playlists.dart';
import 'package:zpevnik/screens/search.dart';
import 'package:zpevnik/screens/song_lyric.dart';
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
      '/playlist' => ((_) => PlaylistScreen(playlist: settings.arguments as Playlist), false),
      '/playlist/bible_verse' => ((_) => BibleVerseScreen(bibleVerse: settings.arguments as BibleVerse), false),
      '/playlist/bible_verse/select_verse' => (
          (_) => SelectBibleVerseScreen(bibleVerse: settings.arguments as BibleVerse?),
          true
        ),
      '/playlist/custom_text' => ((_) => CustomTextScreen(customText: settings.arguments as CustomText?), false),
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

              if (songLyric != null) return SongLyricScreen(songLyrics: [songLyric]);
            }

            final arguments = settings.arguments as SongLyricScreenArguments;

            return SongLyricScreen(songLyrics: arguments.songLyrics, initialIndex: arguments.initialIndex);
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

    return MaterialPageRoute(
      settings: settings,
      builder: builder,
      fullscreenDialog: fullScreenDialog,
    );
  }
}
