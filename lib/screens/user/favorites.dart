import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/components/song_lyrics_list_view.dart';

const _noFavoriteSongLyricsPlaceholder =
    'Nemáte vybrané žádné oblíbené písně.\nPíseň si můžete přidat do oblíbených v${unbreakableSpace}náhledu písně.';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<DataProvider, SongLyricsProvider>(
      create: (_) => FavoriteSongLyricsProvider(),
      update: (_, dataProvider, songLyricsProvider) => songLyricsProvider!..update(dataProvider),
      builder: (_, __) => const SongLyricsListView(
        key: PageStorageKey('favorites'),
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        songLyricsEmptyPlaceholder: _noFavoriteSongLyricsPlaceholder,
        title: 'Písně s hvězdičkou',
      ),
    );
  }
}
