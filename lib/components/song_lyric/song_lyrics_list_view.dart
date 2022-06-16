import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

typedef ListItemBuilder = Widget Function(BuildContext);

class SongLyricsListView extends StatelessWidget {
  const SongLyricsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songLyricsProvider = context.watch<SongLyricsProvider>();

    final List<ListItemBuilder> listItems = [];
    if (songLyricsProvider.recentSongLyrics.isNotEmpty) {
      listItems.add((context) => _buildHeader(context, "POSLEDNÍ PÍSNĚ"));

      listItems
          .addAll(songLyricsProvider.recentSongLyrics.map((songLyric) => (_) => SongLyricRow(songLyric: songLyric)));

      listItems.add((_) => const SizedBox(height: 2 * kDefaultPadding));
    }

    if (songLyricsProvider.matchedById != null) {
      listItems.add((_) => SongLyricRow(songLyric: songLyricsProvider.matchedById!));
      listItems.add((_) => const SizedBox(height: 2 * kDefaultPadding));
    }

    if (songLyricsProvider.songLyricsMatchedBySongbookNumber.isNotEmpty) {
      listItems.add((context) => _buildHeader(context, "ČÍSLO ${songLyricsProvider.searchText} VE ZPĚVNÍCÍCH"));

      listItems.addAll(songLyricsProvider.songLyricsMatchedBySongbookNumber
          .map((songLyric) => (_) => SongLyricRow(songLyric: songLyric)));

      listItems.add((_) => const SizedBox(height: 2 * kDefaultPadding));
    }

    if (listItems.isNotEmpty && songLyricsProvider.songLyrics.isNotEmpty) {
      if (songLyricsProvider.searchText.isEmpty) {
        listItems.add((context) => _buildHeader(context, "VŠECHNY PÍSNĚ"));
      } else {
        listItems.add((context) => _buildHeader(context, "OSTATNÍ VÝSLEDKY"));
      }
    }

    listItems.addAll(songLyricsProvider.songLyrics.map((songLyric) => (_) => SongLyricRow(songLyric: songLyric)));
    listItems.add((_) => const SizedBox(height: 2 * kDefaultPadding));

    return ListView.builder(
      key: Key('${songLyricsProvider.searchText}_${songLyricsProvider.selectedTags.length}'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: listItems.length,
      itemBuilder: (context, index) => listItems[index](context),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Text(title, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary));
  }
}
