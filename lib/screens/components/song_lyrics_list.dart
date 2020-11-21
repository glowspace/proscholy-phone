import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/filters/active_filters_row.dart';

class SongLyricsListView extends StatelessWidget {
  const SongLyricsListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<SongLyricsProvider>(
        builder: (context, provider, child) => Column(children: [
          ChangeNotifierProvider.value(
            value: provider.tagsProvider,
            child: ActiveFiltersRow(selectedTags: provider.tagsProvider.selectedTags),
          ),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemBuilder: (context, index) => SongLyricRow(
                  key: provider.songLyrics[index].key,
                  songLyric: provider.songLyrics[index],
                ),
                itemCount: provider.songLyrics.length,
              ),
            ),
          ),
        ]),
      );
}
