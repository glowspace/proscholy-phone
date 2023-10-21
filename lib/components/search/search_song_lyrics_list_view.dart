import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/song_lyric/song_lyrics_section_title.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_row.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/recent_items.dart';
import 'package:zpevnik/providers/search.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/routing/arguments.dart';

class SearchSongLyricsListView extends ConsumerWidget {
  const SearchSongLyricsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedSongLyricsResult = ref.watch(searchedSongLyricsProvider);

    final songLyrics = filterSongLyrics(searchedSongLyricsResult.songLyrics ?? ref.watch(songLyricsProvider), ref);
    final matchedById = searchedSongLyricsResult.matchedById == null
        ? null
        : filterSongLyrics([searchedSongLyricsResult.matchedById!], ref).firstOrNull;
    final matchedBySongbookNumber = filterSongLyrics(searchedSongLyricsResult.matchedBySongbookNumber, ref);

    final recentSongLyrics = ref.watch(recentSongLyricsProvider);

    // if any song lyric is matched by id or songbook number show title for remaining results section
    final hasMatchedResults = matchedById != null || (matchedBySongbookNumber.isNotEmpty);
    final showRecentSongLyrics =
        ref.read(searchTextProvider).isEmpty && ref.read(selectedTagsProvider).isEmpty && recentSongLyrics.isNotEmpty;

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

          if (index < recentSongLyrics.length) {
            return SongLyricRow(
              songLyric: recentSongLyrics[index],
              displayScreenArguments: DisplayScreenArguments(
                items: recentSongLyrics,
                initialIndex: index,
              ),
            );
          }

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

          if (index < matchedBySongbookNumber.length) {
            return SongLyricRow(
              songLyric: matchedBySongbookNumber[index],
              displayScreenArguments: DisplayScreenArguments(
                items: matchedBySongbookNumber,
                initialIndex: index,
              ),
            );
          }

          index -= matchedBySongbookNumber.length;
        }

        if (showRecentSongLyrics) {
          if (index == 0) return const SongLyricsSectionTitle(title: 'Všechny písně');

          index -= 1;
        } else if (hasMatchedResults) {
          if (index == 0) return const SongLyricsSectionTitle(title: 'Ostatní výsledky');

          index -= 1;
        }

        return SongLyricRow(
          songLyric: songLyrics[index],
          displayScreenArguments: DisplayScreenArguments(
            items: songLyrics,
            initialIndex: index,
          ),
        );
      },
    );
  }

  List<SongLyric> filterSongLyrics(List<SongLyric> songLyrics, WidgetRef ref) {
    final filteredSongLyrics = <SongLyric>[...songLyrics];

    for (int i = filteredSongLyrics.length - 1; i >= 0; i--) {
      final songLyric = filteredSongLyrics[i];

      for (final tagType in supportedTagTypes) {
        final selectedTags = ref.watch(selectedTagsByTypeProvider(tagType));

        if (selectedTags.isEmpty) continue;

        final shouldRemove = switch (tagType) {
          TagType.language => selectedTags.none((tag) => tag.name == songLyric.langDescription),
          TagType.playlist => selectedTags.none((tag) => songLyric.playlistRecords
              .map((playlistRecord) => playlistRecord.playlist.target!)
              .any((playlist) => tag.name == playlist.name)),
          TagType.songbook => selectedTags.none((tag) => songLyric.songbookRecords
              .map((songbookRecord) => songbookRecord.songbook.target!)
              .any((songbook) => tag.name == songbook.name)),
          _ => songLyric.tags.none((tag) => selectedTags.contains(tag))
        };

        if (shouldRemove) {
          filteredSongLyrics.removeAt(i);
          break;
        }
      }
    }

    return filteredSongLyrics;
  }
}
