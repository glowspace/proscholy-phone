import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/song_lyrics_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<DataProvider, SongLyricsProvider>(
      create: (_) => SongLyricsProvider(),
      update: (_, dataProvider, songLyricsProvider) => songLyricsProvider!..update(dataProvider),
      builder: (_, __) => const SongLyricsListView(
        key: PageStorageKey('home_screen'),
        searchPlaceholder: 'Zadejte slovo nebo číslo',
      ),
    );
  }
}
