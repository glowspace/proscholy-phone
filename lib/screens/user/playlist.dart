import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/searchable_list_view.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late SongLyricsProvider _songLyricsProvider;
  @override
  void initState() {
    super.initState();

    _songLyricsProvider = SongLyricsProvider(context.read<DataProvider>().playlistSongLyrics(widget.playlist));
  }

  @override
  Widget build(BuildContext context) {
    final itemBuilder =
        (songLyric) => SongLyricRow(songLyric: songLyric, isReorderable: _songLyricsProvider.searchText.isEmpty);

    return ChangeNotifierProvider.value(
      value: _songLyricsProvider,
      builder: (_, __) => SearchableListView(
        key: PageStorageKey('Playlist'),
        itemsProvider: _songLyricsProvider,
        itemBuilder: itemBuilder,
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        noItemsPlaceholder: 'Playlist neobsahuje žádnou píseň.',
        navigationBarTitle: widget.playlist.name,
        onReorder: _songLyricsProvider.onReorder,
        onReorderDone: (Key key) => _songLyricsProvider.onReorderDone(key, playlist: widget.playlist),
      ),
    );
  }
}
