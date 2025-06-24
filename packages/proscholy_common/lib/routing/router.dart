import 'package:flutter/material.dart';
import 'package:proscholy_common/models/bible_verse.dart';
import 'package:proscholy_common/models/custom_text.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/routing/arguments.dart';
import 'package:proscholy_common/routing/navigation_rail_wrapper.dart';
import 'package:proscholy_common/screens/about.dart';
import 'package:proscholy_common/screens/display.dart';
import 'package:proscholy_common/screens/home.dart';
import 'package:proscholy_common/screens/playlist/custom_text_edit.dart';
import 'package:proscholy_common/screens/song_lyric/jpg.dart';
import 'package:proscholy_common/screens/song_lyric/pdf.dart';
import 'package:proscholy_common/screens/playlist.dart';
import 'package:proscholy_common/screens/playlist/select_bible_verse.dart';
import 'package:proscholy_common/screens/playlists.dart';
import 'package:proscholy_common/screens/search.dart';
import 'package:proscholy_common/screens/songbook.dart';
import 'package:proscholy_common/screens/songbooks.dart';
import 'package:proscholy_common/screens/start_presentation_screen.dart';
import 'package:proscholy_common/screens/updated_song_lyrics.dart';
import 'package:proscholy_common/screens/settings.dart';
import 'package:proscholy_common/utils/extensions.dart';

final class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    final (builder, fullScreenDialog, showNavigationRail) = switch (uri.path) {
      '/' => ((_) => const HomeScreen(), false, true),
      '/about' => ((_) => const AboutScreen(), false, false),
      '/display' => (
          (_) {
            final arguments = settings.arguments as DisplayScreenArguments;

            return DisplayScreen(
              items: arguments.items,
              initialIndex: arguments.initialIndex,
              showSearchScreen: arguments.showSearchScreen,
              playlist: arguments.playlist,
              songbook: arguments.songbook,
            );
          },
          false,
          true
        ),
      '/display/present' => ((_) => const StartPresentationScreen(), true, false),
      '/playlist' => ((_) => PlaylistScreen(playlist: settings.arguments as Playlist), false, true),
      '/playlist/bible_verse/select_verse' => (
          (_) => SelectBibleVerseScreen(bibleVerse: settings.arguments as BibleVerse?),
          true,
          false
        ),
      '/playlist/custom_text/edit' => (
          (_) => CustomTextEditScreen(customText: settings.arguments as CustomText?),
          true,
          false
        ),
      '/playlists' => ((_) => const PlaylistsScreen(), false, true),
      '/search' => ((_) => const SearchScreen(), true, true),
      '/settings' => ((_) => const SettingsScreen(), true, false),
      '/songbook' => ((_) => SongbookScreen(songbook: settings.arguments as Songbook), false, true),
      '/songbooks' => ((_) => const SongbooksScreen(), false, true),
      '/song_lyric' => (
          (BuildContext context) {
            if (uri.queryParameters.containsKey('id')) {
              final id = int.parse(uri.queryParameters['id']!);
              final songLyric = context.providers.read(songLyricProvider(id));

              if (songLyric != null) return DisplayScreen(items: [songLyric]);
            }

            // should not get here
            throw UnimplementedError();
          },
          false,
          true
        ),
      '/song_lyric/jpg' => ((_) => JpgScreen(jpg: settings.arguments as External), true, false),
      '/song_lyric/pdf' => ((_) => PdfScreen(pdf: settings.arguments as External), true, false),
      '/updated_song_lyrics' => (
          (_) => UpdatedSongLyricsScreen(songLyrics: settings.arguments as List<SongLyric>),
          false,
          true
        ),
      String path when path.startsWith('/pisen/') => (
          (BuildContext context) {
            final id = int.parse(uri.pathSegments[1]);
            final songLyric = context.providers.read(songLyricProvider(id));

            if (songLyric != null) return DisplayScreen(items: [songLyric]);

            // should not get here
            throw UnimplementedError();
          },
          false,
          true
      ),

      _ => ((_) => const HomeScreen(), false, true),
    };

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => NavigationRailWrapper(builder: builder, showNavigationRail: showNavigationRail),
      fullscreenDialog: fullScreenDialog,
    );
  }
}
