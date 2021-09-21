import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/searchable_list_view.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/utils/updateable.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with Updateable {
  late SongLyricsProvider _songLyricsProvider;

  @override
  void initState() {
    super.initState();

    final songLyrics = context.read<DataProvider>().songLyrics;

    songLyrics.sort((first, second) => first.favoriteRank.compareTo(second.favoriteRank));

    _songLyricsProvider = SongLyricsProvider(songLyrics, onlyFavorite: true);
  }

  @override
  Widget build(BuildContext context) {
    final itemBuilder =
        (songLyric) => SongLyricRow(songLyric: songLyric, isReorderable: _songLyricsProvider.searchText.isEmpty);

    return ChangeNotifierProvider.value(
      value: _songLyricsProvider,
      builder: (_, __) => SearchableListView(
        key: PageStorageKey('favorites'),
        itemsProvider: _songLyricsProvider,
        itemBuilder: itemBuilder,
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        noItemsPlaceholder:
            'Nemáte vybrané žádné oblíbené písně.\nPíseň si můžete přidat do oblíbených v${unbreakableSpace}náhledu písně.',
        navigationBarTitle: 'Písně s hvězdičkou',
        onReorder: _songLyricsProvider.onReorder,
        onReorderDone: _songLyricsProvider.onReorderDone,
      ),
    );
  }

  @override
  List<Listenable> get listenables {
    final dataProvider = context.read<DataProvider>();

    return dataProvider.songLyrics.map((songLyric) => songLyric.isFavoriteNotifier).toList();
  }

  @override
  void update() {
    _songLyricsProvider.allSongLyrics.sort((first, second) => first.favoriteRank.compareTo(second.favoriteRank));

    super.update();
  }
}
