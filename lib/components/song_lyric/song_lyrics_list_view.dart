import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/search_results_section_title.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/search.dart';
import 'package:zpevnik/providers/song_lyrics.dart';

class SongLyricsListView extends StatelessWidget {
  final List<SongLyric> songLyrics;

  const SongLyricsListView({super.key, required this.songLyrics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songLyrics.length,
      itemBuilder: (_, index) => SongLyricRow(songLyric: songLyrics[index]),
    );
  }
}

class SearchSongLyricsListView extends ConsumerWidget {
  const SearchSongLyricsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedSongLyricsResult = ref.watch(searchedSongLyricsProvider);

    final List<SongLyric> songLyrics = searchedSongLyricsResult.songLyrics ?? ref.watch(songLyricsProvider);
    final matchedById = searchedSongLyricsResult.matchedById;
    final matchedBySongbookNumber = searchedSongLyricsResult.matchedBySongbookNumber;

    // if any song lyric is matched by id or songbook number show title for remaining results section
    final hasMatchedResults =
        matchedById != null || (matchedBySongbookNumber != null && matchedBySongbookNumber.isNotEmpty);

    int itemCount = songLyrics.length;

    if (hasMatchedResults) itemCount += 1;

    if (matchedById != null) itemCount += 1;

    if (matchedBySongbookNumber != null && matchedBySongbookNumber.isNotEmpty) {
      itemCount += matchedBySongbookNumber.length + 1;
    }

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (_, index) {
        if (matchedById != null) {
          if (index == 0) return SongLyricRow(songLyric: matchedById);

          index -= 1;
        }

        if (matchedBySongbookNumber != null && matchedBySongbookNumber.isNotEmpty) {
          if (index == 0) {
            return SearchResultsSectionTitle(title: 'Číslo ${searchedSongLyricsResult.searchedNumber} ve zpěvnících');
          }

          index -= 1;

          if (index < matchedBySongbookNumber.length) return SongLyricRow(songLyric: matchedBySongbookNumber[index]);

          index -= matchedBySongbookNumber.length;
        }

        if (hasMatchedResults) {
          if (index == 0) return const SearchResultsSectionTitle(title: 'Ostatní výsledky');

          index -= 1;
        }

        return SongLyricRow(songLyric: songLyrics[index]);
      },
    );
  }
}
