import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/components/song_lyric/song_lyrics_section_title.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_row.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/providers/recent_items.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/providers/tags.dart';
import 'package:proscholy_common/routing/arguments.dart';

class SearchSongLyricsListView extends ConsumerWidget {
  const SearchSongLyricsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedSongLyricsResult = ref.watch(filteredSongLyricsProvider);

    final songLyrics = searchedSongLyricsResult.songLyrics!;
    final matchedById = searchedSongLyricsResult.matchedById;
    final matchedBySongbookNumber = searchedSongLyricsResult.matchedBySongbookNumber;

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

    final selectedTags = ref.read(selectedTagsProvider);
    final playlist = selectedTags.length != 1 || selectedTags.firstOrNull?.type != TagType.playlist
        ? null
        : ref.read(playlistProvider(kPlaylistTagIdOffset - selectedTags.first.id));

    return SafeArea(
      bottom: false,
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollUpdateNotification notification) {
          if (notification.dragDetails != null) FocusManager.instance.primaryFocus?.unfocus();

          return false;
        },
        child: ListView.builder(
          key: Key('${ref.read(searchTextProvider)}_${ref.read(selectedTagsProvider).length}'),
          padding: const EdgeInsets.only(top: kDefaultPadding / 3),
          primary: false,
          // TODO: right now this opens keyboard again after pop, see: https://github.com/flutter/flutter/issues/124778
          // using `NotificationListener` to do same functionality
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: itemCount,
          itemBuilder: (_, index) {
            if (showRecentSongLyrics) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                  child: SongLyricsSectionTitle(title: 'Poslední písně'),
                );
              }

              index -= 1;

              if (index < recentSongLyrics.length) {
                return SongLyricRow(
                  songLyric: recentSongLyrics[index],
                  displayScreenArguments: DisplayScreenArguments(
                    items: recentSongLyrics,
                    initialIndex: index,
                    showSearchScreen: true,
                    playlist: playlist,
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
                return Padding(
                  padding: const EdgeInsets.only(top: kDefaultPadding),
                  child: SongLyricsSectionTitle(
                    title: 'Číslo ${searchedSongLyricsResult.searchedNumber} ve zpěvnících',
                  ),
                );
              }

              index -= 1;

              if (index < matchedBySongbookNumber.length) {
                return SongLyricRow(
                  songLyric: matchedBySongbookNumber[index],
                  displayScreenArguments: DisplayScreenArguments(
                    items: matchedBySongbookNumber,
                    initialIndex: index,
                    showSearchScreen: true,
                    playlist: playlist,
                  ),
                );
              }

              index -= matchedBySongbookNumber.length;
            }

            if (showRecentSongLyrics) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                  child: SongLyricsSectionTitle(title: 'Všechny písně'),
                );
              }

              index -= 1;
            } else if (hasMatchedResults) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                  child: SongLyricsSectionTitle(title: 'Ostatní výsledky'),
                );
              }

              index -= 1;
            }

            return SongLyricRow(
              songLyric: songLyrics[index],
              displayScreenArguments: DisplayScreenArguments(
                items: songLyrics,
                initialIndex: index,
                showSearchScreen: true,
                playlist: playlist,
              ),
            );
          },
        ),
      ),
    );
  }
}
