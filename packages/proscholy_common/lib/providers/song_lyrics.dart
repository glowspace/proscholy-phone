import 'dart:math';

import 'package:collection/collection.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/sort.dart';

part 'generated/song_lyrics.g.dart';

@riverpod
SongLyric? songLyric(Ref ref, int id) {
  if (id == 0) return null;

  return ref.read(appDependenciesProvider).store.box<SongLyric>().get(id);
}

// loading all song lyrics with their lyrics and externals would block the app, so they are loaded in another isolate
@Riverpod(keepAlive: true)
Future<List<SongLyric>> songLyrics(Ref ref) {
  final store = ref.read(appDependenciesProvider).store;
  final subscription = store.box<SongLyric>().query().watch().listen((_) => ref.invalidateSelf());

  ref.onDispose(subscription.cancel);

  final songLyricIdsWithSvg = {for (final fileName in ref.watch(svgsProvider).keys) int.parse(fileName.split('.')[0])};

  return store.runAsync(_loadSongLyrics, (ref.watch(sortProvider), songLyricIdsWithSvg));
}

List<SongLyric> _loadSongLyrics(Store store, (SortType, Set<int>) parameters) {
  final (sortType, songLyricIdsWithSvg) = parameters;
  final query = (store.box<SongLyric>().query()..order(SongLyric_.name)).build();
  final songLyrics = query
      .find()
      .where((songLyric) => songLyric.shouldAppearToUser || songLyricIdsWithSvg.contains(songLyric.id))
      .toList();

  query.close();

  return switch (sortType) {
    SortType.random => songLyrics..shuffle(Random()),
    SortType.alpha => songLyrics..sort((a, b) => a.name.compareTo(b.name)),
    SortType.numeric => songLyrics..sort((a, b) => compareNatural(a.displayId, b.displayId)),
  };
}

@riverpod
List<SongLyric> songsListSongLyrics(Ref ref, SongsList songsList) {
  songsList.records.sort();

  return [
    for (final record in songsList.records)
      if (record.songLyric.target != null) record.songLyric.target!,
  ];
}
