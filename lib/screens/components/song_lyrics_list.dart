import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';

class SongLyricsListView extends StatelessWidget {
  final String _key = 'songLyricsListView';

  const SongLyricsListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scrollbar(
        child: Consumer<SongLyricsProvider>(
          builder: (context, provider, child) => ListView.builder(
            key: PageStorageKey(_key),
            itemBuilder: (context, index) => SongLyricRow(
              key: provider.songLyrics[index].key,
              songLyric: provider.songLyrics[index],
            ),
            itemCount: provider.songLyrics.length,
          ),
        ),
      );
}
