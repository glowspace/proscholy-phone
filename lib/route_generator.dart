import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/content.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/search.dart';
import 'package:zpevnik/screens/song_lyric.dart';

import 'models/song_lyric.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CustomPageRoute(builder: (_) => const InitialScreen());
      case '/home':
        return CustomPageRoute(builder: (_) => const ContentScreen());
      case '/search':
        return CustomPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => SongLyricsProvider(context.read<DataProvider>()),
            builder: (_, __) => const SearchScreen(),
          ),
          fullscreenDialog: true,
        );
      case '/song_lyric':
        final songLyric = settings.arguments as SongLyric;

        return CustomPageRoute(builder: (_) => SongLyricScreen(songLyric: songLyric));
      default:
        throw 'Unknown route: ${settings.name}';
    }
  }
}

class CustomPageRoute extends MaterialPageRoute {
  // @override
  // Duration get transitionDuration => const Duration(milliseconds: 5000);

  CustomPageRoute({required WidgetBuilder builder, bool fullscreenDialog = false})
      : super(builder: builder, fullscreenDialog: fullscreenDialog);
}
