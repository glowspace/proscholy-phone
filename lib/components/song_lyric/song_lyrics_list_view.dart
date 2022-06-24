import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

typedef ListItemBuilder = Widget Function(BuildContext);

class SongLyricsListView<T extends SongLyricsProvider> extends StatelessWidget {
  const SongLyricsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songLyricsProvider = context.watch<T>();

    Key? listViewKey;
    final List<ListItemBuilder> listItems = [];

    if (songLyricsProvider is AllSongLyricsProvider) {
      listViewKey = Key('${songLyricsProvider.searchText}_${songLyricsProvider.selectedTags.length}');

      if (songLyricsProvider.recentSongLyrics.isNotEmpty) {
        listItems.add((_) => const SizedBox(height: kDefaultPadding / 2));
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
        if (listItems.isEmpty) listItems.add((_) => const SizedBox(height: kDefaultPadding / 2));
        listItems.add((context) => _buildHeader(context, "ČÍSLO ${songLyricsProvider.searchText} VE ZPĚVNÍCÍCH"));

        listItems.addAll(songLyricsProvider.songLyricsMatchedBySongbookNumber
            .map((songLyric) => (_) => SongLyricRow(songLyric: songLyric)));

        listItems.add((_) => const SizedBox(height: 2 * kDefaultPadding));
      }

      if (listItems.isNotEmpty && songLyricsProvider.songLyrics.isNotEmpty) {
        if (listItems.isEmpty) listItems.add((_) => const SizedBox(height: kDefaultPadding / 2));
        if (songLyricsProvider.searchText.isEmpty) {
          listItems.add((context) => _buildHeader(context, "VŠECHNY PÍSNĚ"));
        } else {
          listItems.add((context) => _buildHeader(context, "OSTATNÍ VÝSLEDKY"));
        }
      }
    }

    if (songLyricsProvider is PlaylistSongLyricsProvider) {
      listViewKey = Key(songLyricsProvider.searchText);
    }

    listItems.addAll(songLyricsProvider.songLyrics.map(
      (songLyric) => (_) => SongLyricRow(
            key: Key('${songLyric.id}'),
            songLyric: songLyric,
            isReorderable: songLyricsProvider is Reorderable,
          ),
    ));

    if (songLyricsProvider is Reorderable) {
      return ReorderableListView.builder(
        key: listViewKey,
        padding: const EdgeInsets.only(top: kDefaultPadding, bottom: 2 * kDefaultPadding),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: listItems.length,
        itemBuilder: (context, index) => listItems[index](context),
        onReorder: songLyricsProvider.onReorder,
      );
    }

    return ListView.builder(
      key: listViewKey,
      padding: const EdgeInsets.only(top: kDefaultPadding, bottom: 2 * kDefaultPadding),
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
