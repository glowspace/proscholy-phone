import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/searchable_list_view.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/utils/status_bar_wrapper.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/hex_color.dart';

class SongbookScreen extends StatefulWidget {
  final Songbook songbook;
  final Color? navigationBarColor;

  const SongbookScreen({Key? key, required this.songbook, this.navigationBarColor}) : super(key: key);

  @override
  _SongbookScreenState createState() => _SongbookScreenState();
}

class _SongbookScreenState extends State<SongbookScreen> {
  late final SongLyricsProvider _songLyricsProvider;

  @override
  void initState() {
    super.initState();

    _songLyricsProvider = SongLyricsProvider(context.read<DataProvider>().songbookSongLyrics(widget.songbook));
  }

  @override
  Widget build(BuildContext context) {
    final songbook = widget.songbook;
    final itemBuilder = (songLyric) => SongLyricRow(songLyric: songLyric, songbook: songbook);

    return ChangeNotifierProvider.value(
      value: _songLyricsProvider,
      builder: (_, __) => SearchableListView(
        key: PageStorageKey('songbook'),
        itemsProvider: _songLyricsProvider,
        itemBuilder: itemBuilder,
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        noItemsPlaceholder: 'Zpěvník neobsahuje žádnou píseň.',
        navigationBarTitle: songbook.name,
        navigationBarColor: widget.navigationBarColor,
      ),
    );
  }
}
