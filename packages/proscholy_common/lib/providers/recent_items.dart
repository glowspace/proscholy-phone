import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/bible_passage.dart';
import 'package:proscholy_common/providers/user_text.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/songbooks.dart';

part 'generated/recent_items.g.dart';

const _maxRecentItems = 5;
const _recentItemsKey = 'recent_items';
const _recentSongLyricsKey = 'recent_song_lyrics';

@riverpod
class RecentItems extends _$RecentItems {
  @override
  List<RecentItem> build() {
    final recentItems = <RecentItem>[];

    for (final recentItemString
        in ref.read(appDependenciesProvider).sharedPreferences.getStringList(_recentItemsKey) ?? <String>[]) {
      final recentItem = _watchRecentItem(ref, recentItemString);

      if (recentItem != null) recentItems.add(recentItem);
    }

    return recentItems;
  }

  void add(RecentItem recentItem) {
    final recentItems = [
      recentItem,
      for (final item in state)
        if (item.id != recentItem.id || item.recentItemType != recentItem.recentItemType) item,
    ];

    ref.read(appDependenciesProvider).sharedPreferences.setStringList(_recentItemsKey, [
      for (final item in recentItems.take(_maxRecentItems)) '${item.recentItemType.rawValue};${item.id}',
    ]);

    ref.invalidateSelf();
  }
}

// recent items are stored as 'TYPE;ID', watching them updates them when they change (e.g. renamed playlist) and removes
// the removed ones
RecentItem? _watchRecentItem(Ref ref, String recentItemString) {
  final [type, id] = [for (final part in recentItemString.split(';')) int.parse(part)];

  return switch (RecentItemType.fromRawValue(type)) {
    RecentItemType.biblePassage => ref.watch(biblePassageProvider(id)),
    RecentItemType.userText => ref.watch(userTextProvider(id)),
    RecentItemType.playlist => ref.watch(playlistProvider(id)),
    RecentItemType.songbook => ref.watch(songbookProvider(id)),
    RecentItemType.songLyric => ref.watch(songLyricProvider(id)),
  };
}

@riverpod
class RecentSongLyrics extends _$RecentSongLyrics {
  @override
  List<SongLyric> build() {
    final appDependencies = ref.read(appDependenciesProvider);
    final ids = (appDependencies.sharedPreferences.getStringList(_recentSongLyricsKey) ?? [])
        .map((id) => int.parse(id))
        .toList();

    return appDependencies.store.box<SongLyric>().getMany(ids).nonNulls.toList();
  }

  void add(SongLyric songLyric) {
    final newState = [songLyric, ...state.where((element) => element.id != songLyric.id)];

    state = newState.sublist(0, min(_maxRecentItems, newState.length));

    ref
        .read(appDependenciesProvider)
        .sharedPreferences
        .setStringList(_recentSongLyricsKey, state.map((songLyric) => '${songLyric.id}').toList());

    ref.read(recentItemsProvider.notifier).add(songLyric);
  }
}
