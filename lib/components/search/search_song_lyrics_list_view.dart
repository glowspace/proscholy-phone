import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_section_title.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/providers/search.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/tags.dart';

class SearchSongLyricsListView extends ConsumerWidget {
  const SearchSongLyricsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedSongLyricsResult = ref.watch(searchedSongLyricsProvider);

    final songLyrics =
        ref.watch(filteredSongLyricsProvider(searchedSongLyricsResult.songLyrics ?? ref.watch(songLyricsProvider)));
    final matchedById = searchedSongLyricsResult.matchedById == null
        ? null
        : ref.watch(filteredSongLyricsProvider([searchedSongLyricsResult.matchedById!])).firstOrNull;
    final matchedBySongbookNumber =
        ref.watch(filteredSongLyricsProvider(searchedSongLyricsResult.matchedBySongbookNumber));

    final recentSongLyrics = ref.watch(recentSongLyricsProvider);

    // if any song lyric is matched by id or songbook number show title for remaining results section
    final hasMatchedResults = matchedById != null || (matchedBySongbookNumber.isNotEmpty);
    final showRecentSongLyrics = ref.read(searchTextProvider).isEmpty && recentSongLyrics.isNotEmpty;

    int itemCount = songLyrics.length;

    if (hasMatchedResults && itemCount > 0) itemCount += 1;

    if (matchedById != null) itemCount += 1;

    if (matchedBySongbookNumber.isNotEmpty) itemCount += matchedBySongbookNumber.length + 1;

    if (showRecentSongLyrics) itemCount += recentSongLyrics.length + 2;

    return ListView.builder(
      key: Key('${ref.read(searchTextProvider)}_${ref.read(selectedTagsProvider).length}'),
      primary: false,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: itemCount,
      itemBuilder: (_, index) {
        if (showRecentSongLyrics) {
          if (index == 0) return const SongLyricsSectionTitle(title: 'Poslední písně');

          index -= 1;

          if (index < recentSongLyrics.length) return SongLyricRow(songLyric: recentSongLyrics[index]);

          index -= recentSongLyrics.length;
        }

        if (matchedById != null) {
          if (index == 0) return SongLyricRow(songLyric: matchedById);

          index -= 1;
        }

        if (matchedBySongbookNumber.isNotEmpty) {
          if (index == 0) {
            return SongLyricsSectionTitle(title: 'Číslo ${searchedSongLyricsResult.searchedNumber} ve zpěvnících');
          }

          index -= 1;

          if (index < matchedBySongbookNumber.length) return SongLyricRow(songLyric: matchedBySongbookNumber[index]);

          index -= matchedBySongbookNumber.length;
        }

        if (showRecentSongLyrics) {
          if (index == 0) return const SongLyricsSectionTitle(title: 'Všechny písně');

          index -= 1;
        } else if (hasMatchedResults) {
          if (index == 0) return const SongLyricsSectionTitle(title: 'Ostatní výsledky');

          index -= 1;
        }

        return SongLyricRow(songLyric: songLyrics[index]);
      },
    );
  }
}
