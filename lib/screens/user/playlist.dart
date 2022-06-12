import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/components/song_lyrics/song_lyrics_list_view.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistScreen({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<DataProvider, SongLyricsProvider>(
      create: (_) => PlaylistSongLyricsProvider(playlist),
      update: (_, dataProvider, songLyricsProvider) => songLyricsProvider!..update(dataProvider, playlist: playlist),
      builder: (_, __) => SongLyricsListView(
        key: const PageStorageKey('Playlist'),
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        songLyricsEmptyPlaceholder: 'Playlist neobsahuje žádnou píseň.',
        title: playlist.name,
      ),
    );
  }
}
