import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/routes/arguments/search.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/screens/about.dart';
import 'package:zpevnik/screens/home.dart';
import 'package:zpevnik/screens/initial.dart';
import 'package:zpevnik/screens/jpg.dart';
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
import 'package:zpevnik/screens/start_presentation_screen.dart';
import 'package:zpevnik/screens/updated_song_lyrics.dart';
import 'package:zpevnik/screens/user.dart';

// class MenuRouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(settings: settings, builder: (_) => const HomeMenu());
//       case '/playlist':
//         final playlist = settings.arguments as Playlist;

//         return MaterialPageRoute(settings: settings, builder: (_) => PlaylistScreen(playlist: playlist));
//       case '/song_lyric/translations':
//         final songLyric = settings.arguments as SongLyric;

//         return MaterialPageRoute(settings: settings, builder: (_) => TranslationsScreen(songLyric: songLyric));
//       case '/songbook':
//         final songbook = settings.arguments as Songbook;

//         return MaterialPageRoute(
//           settings: settings,
//           builder: (_) => SongbookScreen(songbook: songbook),
//           fullscreenDialog: true,
//         );
//       case '/updated_song_lyrics':
//         return MaterialPageRoute(settings: settings, builder: (_) => const UpdatedSongLyricsScreen());
//       case '/user':
//         return MaterialPageRoute(settings: settings, builder: (_) => const UserScreen(), fullscreenDialog: true);
//       default:
//         throw 'Unknown route: ${settings.name}';
//     }
//   }
// }

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(settings: settings, builder: (_) => const HomeScreen());
//       case '/about':
//         return MaterialPageRoute(settings: settings, builder: (_) => const AboutScreen());
//       case '/pdf':
//         final pdf = settings.arguments as External;

//         return MaterialPageRoute(settings: settings, builder: (_) => PdfScreen(pdf: pdf));
//       case '/jpg':
//         final jpg = settings.arguments as External;

//         return MaterialPageRoute(settings: settings, builder: (_) => JpgScreen(jpg: jpg));
//       case '/playlist':
//         final playlist = settings.arguments as Playlist;

//         return MaterialPageRoute(settings: settings, builder: (_) => PlaylistScreen(playlist: playlist));
//       // case '/playlist/custom_text':
//       //   return MaterialPageRoute(settings: settings, builder: (_) => const CustomTextScreen(), fullscreenDialog: true);
//       case '/playlists':
//         return MaterialPageRoute(settings: settings, builder: (_) => const PlaylistsScreen());
//       // case '/presentation':
//       //   return MaterialPageRoute(settings: settings, builder: (_) => const PresentationScreen(presentedLyrics: 'Test'));
//       case '/search':
//         final arguments = settings.arguments as SearchScreenArguments?;

//         return MaterialPageRoute(
//           settings: settings,
//           builder: (_) => ChangeNotifierProxyProvider<DataProvider, AllSongLyricsProvider>(
//             create: (context) {
//               final dataProvider = context.read<DataProvider>();

//               return AllSongLyricsProvider(
//                 dataProvider,
//                 songLyrics: dataProvider.songLyrics,
//                 initialTag: arguments?.initialTag,
//               );
//             },
//             update: (_, dataProvider, allSongLyricsProvider) =>
//                 allSongLyricsProvider!..update(dataProvider, songLyrics: dataProvider.songLyrics),
//             builder: (_, __) => const SearchScreen(),
//           ),
//           fullscreenDialog: true,
//         );
//       case '/song_lyric':
//         final arguments = settings.arguments as SongLyricScreenArguments;

//         if (arguments.isTablet) {
//           return CustomPageRouteBuilder(
//             settings: settings,
//             pageBuilder: (_, __, ___) => SongLyricScreen(
//               songLyrics: arguments.songLyrics,
//               initialIndex: arguments.index,
//               shouldShowBanner: arguments.shouldShowBanner,
//               playlist: arguments.playlist,
//             ),
//           );
//         }

//         return MaterialPageRoute(
//           settings: settings,
//           builder: (_) => SongLyricScreen(
//             songLyrics: arguments.songLyrics,
//             initialIndex: arguments.index,
//             shouldShowBanner: arguments.shouldShowBanner,
//           ),
//         );
//       case '/song_lyric/present':
//         final songLyricsParser = settings.arguments as SongLyricsParser;

//         return MaterialPageRoute(
//             settings: settings, builder: (_) => StartPresentationScreen(songLyricsParser: songLyricsParser));
//       case '/song_lyric/translations':
//         final songLyric = settings.arguments as SongLyric;

//         return MaterialPageRoute(settings: settings, builder: (_) => TranslationsScreen(songLyric: songLyric));
//       case '/songbook':
//         final songbook = settings.arguments as Songbook;

//         return MaterialPageRoute(settings: settings, builder: (_) => SongbookScreen(songbook: songbook));
//       case '/songbooks':
//         return MaterialPageRoute(settings: settings, builder: (_) => const SongbooksScreen());
//       case '/updated_song_lyrics':
//         return MaterialPageRoute(settings: settings, builder: (_) => const UpdatedSongLyricsScreen());
//       case '/user':
//         return MaterialPageRoute(settings: settings, builder: (_) => const UserScreen(), fullscreenDialog: true);
//       default:
//         throw 'Unknown route: ${settings.name}';
//     }
//   }
// }

// class CustomPageRouteBuilder extends PageRouteBuilder {
//   CustomPageRouteBuilder({required super.pageBuilder, super.settings})
//       : super(
//           transitionsBuilder: (_, animation, __, child) {
//             final opacityAnimation =
//                 animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)));

//             return FadeTransition(opacity: opacityAnimation, child: child);
//           },
//         );
// }

final appRouter = GoRouter(
  initialLocation: '/initial',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
    GoRoute(path: '/initial', builder: (_, __) => const InitialScreen()),
    GoRoute(path: '/playlist', builder: (_, state) => PlaylistScreen(playlist: state.extra as Playlist)),
    GoRoute(path: '/playlists', builder: (_, __) => const PlaylistsScreen()),
    GoRoute(
      path: '/search',
      pageBuilder: (_, __) => const MaterialPage(fullscreenDialog: true, child: SearchScreen()),
    ),
    GoRoute(path: '/songbook', builder: (_, state) => SongbookScreen(songbook: state.extra as Songbook)),
    GoRoute(path: '/songbooks', builder: (_, __) => const SongbooksScreen()),
    GoRoute(path: '/user', builder: (_, __) => const UserScreen()),
    GoRoute(path: '/updated_song_lyrics', builder: (_, __) => const UpdatedSongLyricsScreen()),
  ],
);
