import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/searchable_list_view.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/utils/selectable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Selectable {
  late SongLyricsProvider _songLyricsProvider;

  @override
  void initState() {
    super.initState();

    _songLyricsProvider = SongLyricsProvider(context.read<DataProvider>().songLyrics);
  }

  @override
  Widget build(BuildContext context) {
    final itemBuilder = (songLyric) => SongLyricRow(songLyric: songLyric);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _songLyricsProvider),
        ChangeNotifierProvider.value(value: selectionProvider),
      ],
      builder: (context, _) => SearchableListView(
        key: PageStorageKey('home_screen'),
        itemsProvider: _songLyricsProvider,
        itemBuilder: itemBuilder,
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        trailingActions: AnimatedBuilder(
          animation: selectionProvider,
          builder: (context, child) => buildSelectableActions(_songLyricsProvider.items),
        ),
      ),
    );
  }
}
