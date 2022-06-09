import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/components/song_lyrics_list_view.dart';

class SongbookScreen extends StatelessWidget {
  final Songbook songbook;
  final Color? navigationBarColor;
  final Color? navigationBarTextColor;

  const SongbookScreen({
    Key? key,
    required this.songbook,
    this.navigationBarColor,
    this.navigationBarTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<DataProvider, SongLyricsProvider>(
      create: (_) => SongLyricsProvider(),
      update: (_, dataProvider, songLyricsProvider) => songLyricsProvider!..update(dataProvider, songbook: songbook),
      // TODO: needs way to pass ongbook
      builder: (_, __) => SongLyricsListView(
        key: const PageStorageKey('songbook'),
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        songLyricsEmptyPlaceholder: 'Zpěvník neobsahuje žádnou píseň.',
        title: songbook.name,
        navigationBarColor: navigationBarColor,
        navigationBarTextColor: navigationBarTextColor,
      ),
    );
  }
}
