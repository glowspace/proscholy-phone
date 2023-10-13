import 'dart:math';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/app_dependencies.dart';

part 'recent_items.g.dart';

const _recentItemsKey = 'recent_items';
const _recentSongLyricsKey = 'recent_song_lyrics';

@riverpod
class RecentItems extends _$RecentItems {
  @override
  List<RecentItem> build() {
    final appDependencies = ref.read(appDependenciesProvider);

    final songLyricIds = <int>[];
    final playlistIds = <int>[];

    for (final recentItemString in appDependencies.sharedPreferences.getStringList(_recentItemsKey) ?? <String>[]) {
      final splitted = recentItemString.split(';');

      switch (RecentItemType.fromRawValue(int.parse(splitted[0]))) {
        case RecentItemType.playlist:
          playlistIds.add(int.parse(splitted[1]));
          break;
        case RecentItemType.songLyric:
          songLyricIds.add(int.parse(splitted[1]));
          break;
      }
    }

    final recentItems = appDependencies.store
        .box<SongLyric>()
        .getMany(songLyricIds, growableResult: true)
        .whereNotNull()
        .cast<RecentItem>()
        .toList();

    recentItems.addAll(appDependencies.store.box<Playlist>().getMany(playlistIds).whereNotNull());

    return recentItems;
  }

  void add(RecentItem recentItem) {
    final newState = [
      recentItem,
      ...state.where((element) => element.id != recentItem.id || element.recentItemType != recentItem.recentItemType)
    ];

    state = newState.sublist(0, min(3, newState.length));

    ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.sharedPreferences)).setStringList(
        _recentItemsKey, state.map((recentItem) => '${recentItem.recentItemType.rawValue};${recentItem.id}').toList());
  }
}

@riverpod
class RecentSongLyrics extends _$RecentSongLyrics {
  @override
  List<SongLyric> build() {
    final appDependencies = ref.read(appDependenciesProvider);
    final ids = (appDependencies.sharedPreferences.getStringList(_recentSongLyricsKey) ?? [])
        .map((id) => int.parse(id))
        .toList();

    return appDependencies.store.box<SongLyric>().getMany(ids).whereNotNull().toList();
  }

  void add(SongLyric songLyric) {
    final newState = [songLyric, ...state.where((element) => element.id != songLyric.id)];

    state = newState.sublist(0, min(5, newState.length));

    ref
        .read(appDependenciesProvider.select((appDependencies) => appDependencies.sharedPreferences))
        .setStringList(_recentSongLyricsKey, state.map((songLyric) => '${songLyric.id}').toList());

    ref.read(recentItemsProvider.notifier).add(songLyric);
  }
}
