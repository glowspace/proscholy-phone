import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/screens/about.dart';
import 'package:zpevnik/screens/home.dart';
import 'package:zpevnik/screens/menu/home.dart';
import 'package:zpevnik/screens/pdf.dart';
import 'package:zpevnik/screens/playlist.dart';
// import 'package:zpevnik/screens/playlist/custom_text.dart';
import 'package:zpevnik/screens/playlists.dart';
import 'package:zpevnik/screens/search.dart';
import 'package:zpevnik/screens/song_lyric.dart';
import 'package:zpevnik/screens/song_lyric/translations.dart';
import 'package:zpevnik/screens/songbook.dart';
import 'package:zpevnik/screens/songbooks.dart';
import 'package:zpevnik/screens/updated_song_lyrics.dart';
import 'package:zpevnik/screens/user.dart';

class MenuRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(settings: settings, builder: (_) => const HomeMenu());
      case '/playlist':
        final playlist = settings.arguments as Playlist;

        return MaterialPageRoute(settings: settings, builder: (_) => PlaylistScreen(playlist: playlist));
      case '/song_lyric/translations':
        final songLyric = settings.arguments as SongLyric;

        return MaterialPageRoute(settings: settings, builder: (_) => TranslationsScreen(songLyric: songLyric));
      case '/songbook':
        final songbook = settings.arguments as Songbook;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SongbookScreen(songbook: songbook),
          fullscreenDialog: true,
        );
      case '/updated_song_lyrics':
        return MaterialPageRoute(settings: settings, builder: (_) => const UpdatedSongLyricsScreen());
      case '/user':
        return MaterialPageRoute(settings: settings, builder: (_) => const UserScreen(), fullscreenDialog: true);
      default:
        throw 'Unknown route: ${settings.name}';
    }
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(settings: settings, builder: (_) => const HomeScreen());
      case '/about':
        return MaterialPageRoute(settings: settings, builder: (_) => const AboutScreen());
      case '/pdf':
        final pdf = settings.arguments as External;

        return MaterialPageRoute(settings: settings, builder: (_) => PdfScreen(pdf: pdf));
      case '/playlist':
        final playlist = settings.arguments as Playlist;

        return MaterialPageRoute(settings: settings, builder: (_) => PlaylistScreen(playlist: playlist));
      // case '/playlist/custom_text':
      //   return MaterialPageRoute(settings: settings, builder: (_) => const CustomTextScreen(), fullscreenDialog: true);
      case '/playlists':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProxyProvider<DataProvider, PlaylistsProvider>(
            create: (context) => PlaylistsProvider(),
            update: (context, dataProvider, playlistsProvider) => playlistsProvider!..update(dataProvider.playlists),
            builder: (_, __) => const PlaylistsScreen(),
          ),
        );
      case '/search':
        final arguments = settings.arguments as SearchScreenArguments?;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProxyProvider<DataProvider, AllSongLyricsProvider>(
            create: (context) {
              final dataProvider = context.read<DataProvider>();

              return AllSongLyricsProvider(
                dataProvider,
                songLyrics: dataProvider.songLyrics,
                initialTag: arguments?.initialTag,
              );
            },
            update: (_, dataProvider, allSongLyricsProvider) =>
                allSongLyricsProvider!..update(dataProvider, songLyrics: dataProvider.songLyrics),
            builder: (_, __) => const SearchScreen(),
          ),
          fullscreenDialog: true,
        );
      case '/song_lyric':
        final arguments = settings.arguments as SongLyricScreenArguments;

        if (arguments.isTablet) {
          return CustomPageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => SongLyricScreen(
              songLyrics: arguments.songLyrics,
              initialIndex: arguments.index,
              playlist: arguments.playlist,
            ),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SongLyricScreen(songLyrics: arguments.songLyrics, initialIndex: arguments.index),
        );
      case '/song_lyric/translations':
        final songLyric = settings.arguments as SongLyric;

        return MaterialPageRoute(settings: settings, builder: (_) => TranslationsScreen(songLyric: songLyric));
      case '/songbook':
        final songbook = settings.arguments as Songbook;

        return MaterialPageRoute(settings: settings, builder: (_) => SongbookScreen(songbook: songbook));
      case '/songbooks':
        return MaterialPageRoute(settings: settings, builder: (_) => const SongbooksScreen());
      case '/updated_song_lyrics':
        return MaterialPageRoute(settings: settings, builder: (_) => const UpdatedSongLyricsScreen());
      case '/user':
        return MaterialPageRoute(settings: settings, builder: (_) => const UserScreen(), fullscreenDialog: true);
      default:
        throw 'Unknown route: ${settings.name}';
    }
  }
}

class CustomPageRouteBuilder extends PageRouteBuilder {
  CustomPageRouteBuilder({required super.pageBuilder, super.settings})
      : super(
          transitionsBuilder: (_, animation, __, child) {
            final opacityAnimation =
                animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)));

            return FadeTransition(opacity: opacityAnimation, child: child);
          },
        );
}
