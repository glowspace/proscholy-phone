import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/platform/components/dialog.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/searchable_list_view.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/utils/selectable.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> with Selectable {
  late SongLyricsProvider _songLyricsProvider;
  @override
  void initState() {
    super.initState();

    _songLyricsProvider = SongLyricsProvider(context.read<DataProvider>().playlistSongLyrics(widget.playlist));
  }

  @override
  Widget build(BuildContext context) {
    final itemBuilder = (songLyric) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.15,
          child: SongLyricRow(songLyric: songLyric, isReorderable: _songLyricsProvider.searchText.isEmpty),
          secondaryActions: [
            IconSlideAction(
              caption: 'Odebrat',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => _removeSongLyric(context, songLyric),
            )
          ],
        );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _songLyricsProvider),
        ChangeNotifierProvider.value(value: selectionProvider),
      ],
      builder: (_, __) => SearchableListView(
        key: PageStorageKey('Playlist'),
        itemsProvider: _songLyricsProvider,
        itemBuilder: itemBuilder,
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        noItemsPlaceholder: 'Playlist neobsahuje žádnou píseň.',
        navigationBarTitle: widget.playlist.name,
        onReorder: _songLyricsProvider.onReorder,
        onReorderDone: (Key key) => _songLyricsProvider.onReorderDone(key, playlist: widget.playlist),
        trailingActions: AnimatedBuilder(
          animation: selectionProvider,
          builder: (context, child) => buildSelectableActions(_songLyricsProvider.items, playlist: widget.playlist),
        ),
      ),
    );
  }

  void _removeSongLyric(BuildContext context, SongLyric songLyric) {
    showPlatformDialog<bool>(
      context,
      (context) => ConfirmDialog(
        title: 'Opravdu chcete píseň odebraz z playlistu?',
        confirmText: 'Odebrat',
      ),
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        widget.playlist.removeSongLyrics([songLyric]);
        setState(() =>
            _songLyricsProvider = SongLyricsProvider(context.read<DataProvider>().playlistSongLyrics(widget.playlist)));
      }
    });
  }
}
