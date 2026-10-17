import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/models/bible_verse.dart';
import 'package:proscholy_common/models/custom_text.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/songbooks.dart';
import 'package:proscholy_common/providers/tags.dart';
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
  // uri of opened file is used as initial route too, but files are handled by `ExternalActionsService`
  static List<Route<dynamic>> generateInitialRoutes(String initialRoute) {
    final uri = Uri.tryParse(initialRoute);
    final isLink = uri != null && (!uri.hasScheme || uri.isScheme('http') || uri.isScheme('https'));

    return [
      generateRoute(const RouteSettings(name: '/')),
      if (initialRoute != '/' && isLink) generateRoute(RouteSettings(name: initialRoute)),
    ];
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    final (builder, fullScreenDialog, showNavigationRail) = switch (uri.path) {
      '/' || '/hledani' => () {
        // cleanup query parameters
        if (uri.queryParameters.containsKey('text') ||
            uri.queryParameters.containsKey('stitky') ||
            uri.queryParameters.containsKey('zpevniky')) {
          settings = RouteSettings(name: '/search');
        } else {
          settings = RouteSettings(name: '/');
        }

        return (
          (BuildContext context) {
            if (uri.queryParameters.containsKey('text') ||
                uri.queryParameters.containsKey('stitky') ||
                uri.queryParameters.containsKey('zpevniky')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (uri.queryParameters['stitky'] != null) {
                  context.providers
                      .read(selectedTagsProvider.notifier)
                      .push(
                        initialTags: uri.queryParameters['stitky']!
                            .split(',')
                            .map((id) => context.providers.read(tagProvider(int.parse(id))))
                            .toList()
                            .cast(),
                      );
                }
                if (uri.queryParameters['zpevniky'] != null) {
                  context.providers
                      .read(selectedTagsProvider.notifier)
                      .push(
                        initialTags: uri.queryParameters['zpevniky']!
                            .split(',')
                            .map(
                              (id) => context.providers
                                  .read(tagsProvider(TagType.songbook))
                                  .firstWhere((tag) => tag.id == kSongbookTagIdOffset - int.parse(id)),
                            )
                            .toList()
                            .cast(),
                      );
                }
              });

              return ProviderScope(
                overrides: [
                  searchTextProvider.overrideWith(
                    () => SearchText(initialText: uri.queryParameters['text']?.replaceAll('_', ' ')),
                  ),
                  searchedSongLyricsProvider.overrideWith(() => SearchedSongLyrics()),
                ],
                child: const SearchScreen(),
              );
            }

            return const HomeScreen();
          },
          uri.queryParameters.containsKey('text') ||
              uri.queryParameters.containsKey('stitky') ||
              uri.queryParameters.containsKey('zpevniky'),
          true,
        );
      }(),
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
        true,
      ),
      '/display/present' => ((_) => const StartPresentationScreen(), true, false),
      '/playlist' => ((_) => PlaylistScreen(playlist: settings.arguments as Playlist), false, true),
      '/playlist/bible_verse/select_verse' => (
        (_) => SelectBibleVerseScreen(bibleVerse: settings.arguments as BibleVerse?),
        true,
        false,
      ),
      '/playlist/custom_text/edit' => (
        (_) => CustomTextEditScreen(customText: settings.arguments as CustomText?),
        true,
        false,
      ),
      '/playlists' => ((_) => const PlaylistsScreen(), false, true),
      '/search' => ((_) => const SearchScreen(), true, true),
      '/settings' => ((_) => const SettingsScreen(), true, false),
      '/songbook' => ((_) => SongbookScreen(songbook: settings.arguments as Songbook), false, true),
      '/songbooks' => ((_) => const SongbooksScreen(), false, true),
      '/song_lyric' => (
        (BuildContext context) {
          final id = int.tryParse(uri.queryParameters['id'] ?? '');
          final songLyric = id == null ? null : context.providers.read(songLyricProvider(id));

          if (songLyric != null) return DisplayScreen(items: [songLyric]);

          // song lyric might not be downloaded yet or link is invalid
          return const HomeScreen();
        },
        false,
        true,
      ),
      '/song_lyric/jpg' => ((_) => JpgScreen(jpg: settings.arguments as External), true, false),
      '/song_lyric/pdf' => ((_) => PdfScreen(pdf: settings.arguments as External), true, false),
      '/updated_song_lyrics' => (
        (_) => UpdatedSongLyricsScreen(songLyrics: settings.arguments as List<SongLyric>),
        false,
        true,
      ),
      '/zpevniky' => ((_) => const SongbooksScreen(), false, true),
      String path when path.startsWith('/pisen/') => (
        (BuildContext context) {
          final id = int.tryParse(uri.pathSegments[1]);
          final songLyric = id == null ? null : context.providers.read(songLyricProvider(id));

          if (songLyric != null) return DisplayScreen(items: [songLyric]);

          // song lyric might not be downloaded yet or link is invalid
          return const HomeScreen();
        },
        false,
        true,
      ),
      String path when path.startsWith('/zpevnik/') => (
        (BuildContext context) {
          final id = int.tryParse(uri.pathSegments[1]);
          final songbook = id == null ? null : context.providers.read(songbookProvider(id));

          if (songbook != null) return SongbookScreen(songbook: songbook);

          // link might be invalid
          return const HomeScreen();
        },
        false,
        true,
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
