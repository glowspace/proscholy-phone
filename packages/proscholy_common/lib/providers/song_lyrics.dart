import 'dart:math';

import 'package:collection/collection.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/sort.dart';
import 'package:proscholy_common/providers/utils.dart';

part 'generated/song_lyrics.g.dart';

@riverpod
SongLyric? songLyric(SongLyricRef ref, int id) {
  if (id == 0) return null;

  return ref.read(appDependenciesProvider).store.box<SongLyric>().get(id);
}

@Riverpod(keepAlive: true)
List<SongLyric> songLyrics(SongLyricsRef ref) {
  final random = Random();
  final songLyrics = queryStore(ref, orderBy: SongLyric_.name)
      .where((songLyric) => songLyric.shouldAppearToUser || ref.read(svgProvider(songLyric.id)).isNotEmpty)
      .toList();

  return switch (ref.watch(sortProvider)) {
    SortType.random => songLyrics..sort((_, __) => random.nextDouble().compareTo(random.nextDouble())),
    SortType.alpha => songLyrics..sort((a, b) => a.name.compareTo(b.name)),
    SortType.numeric => songLyrics..sort((a, b) => compareNatural(a.displayId, b.displayId)),
  };
}

@riverpod
List<SongLyric> songsListSongLyrics(SongsListSongLyricsRef ref, SongsList songsList) {
  songsList.records.sort();

  return [
    for (final record in songsList.records)
      if (record.songLyric.target != null) record.songLyric.target!
  ];
}
