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
import 'package:zpevnik/screens/content.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/pdf.dart';
import 'package:zpevnik/screens/playlist.dart';
import 'package:zpevnik/screens/playlist/custom_text.dart';
import 'package:zpevnik/screens/playlists.dart';
import 'package:zpevnik/screens/search.dart';
import 'package:zpevnik/screens/song_lyric.dart';
import 'package:zpevnik/screens/song_lyric/translations.dart';
import 'package:zpevnik/screens/songbook.dart';
import 'package:zpevnik/screens/updated_song_lyrics.dart';
import 'package:zpevnik/screens/user.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(settings: settings, builder: (_) => const InitialScreen());
      case '/about':
        return MaterialPageRoute(settings: settings, builder: (_) => const AboutScreen());
      case '/home':
        return MaterialPageRoute(settings: settings, builder: (_) => const ContentScreen());
      case '/pdf':
        final pdf = settings.arguments as External;

        return MaterialPageRoute(settings: settings, builder: (_) => PdfScreen(pdf: pdf));
      case '/playlist':
        final playlist = settings.arguments as Playlist;

        return MaterialPageRoute(settings: settings, builder: (_) => PlaylistScreen(playlist: playlist));
      case '/playlist/custom_text':
        return MaterialPageRoute(settings: settings, builder: (_) => const CustomTextScreen(), fullscreenDialog: true);
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
          builder: (_) => ChangeNotifierProvider(
            create: (context) => AllSongLyricsProvider(context.read<DataProvider>(), initialTag: arguments?.initialTag),
            builder: (_, __) => const SearchScreen(),
          ),
          fullscreenDialog: true,
        );
      case '/song_lyric':
        final arguments = settings.arguments as SongLyricScreenArguments;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SongLyricScreen(songLyrics: arguments.songLyrics, initialIndex: arguments.index),
        );
      case '/song_lyrics/translations':
        final songLyric = settings.arguments as SongLyric;

        return MaterialPageRoute(settings: settings, builder: (_) => TranslationsScreen(songLyric: songLyric));
      case '/songbook':
        final songbook = settings.arguments as Songbook;

        return MaterialPageRoute(settings: settings, builder: (_) => SongbookScreen(songbook: songbook));
      case '/updated_song_lyrics':
        return MaterialPageRoute(settings: settings, builder: (_) => const UpdatedSongLyricsScreen());
      case '/user':
        return MaterialPageRoute(settings: settings, builder: (_) => const UserScreen(), fullscreenDialog: true);
      default:
        throw 'Unknown route: ${settings.name}';
    }
  }
}
