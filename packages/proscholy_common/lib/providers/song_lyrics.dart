import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/settings.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/sort.dart';
import 'package:proscholy_common/providers/utils.dart';

part 'generated/song_lyrics.g.dart';

// TODO: remove this after some time, that all users have at least 3.1.0 version
void migrateSongLyricSettings(Store store) {
  final query = store
      .box<SongLyric>()
      .query(SongLyric_.transposition
          .notEquals(0)
          .or(SongLyric_.accidentals.notNull().and(SongLyric_.accidentals.notEquals(0)))
          .or(SongLyric_.showChords.notNull()))
      .build();

  final songLyricsWithSettings = query.find();

  query.close();

  int id = 1;

  final songLyricsSettings = <SongLyricSettingsModel>[];

  for (final songLyric in songLyricsWithSettings) {
    final songLyricSettings = SongLyricSettingsModel(
      id: id++,
      showChords: songLyric.showChords ?? true,
      showMusicalNotes: true,
      accidentals: songLyric.accidentals ?? 1,
      transposition: songLyric.transposition ?? 0,
      songLyric: ToOne(target: songLyric),
    );

    songLyricsSettings.add(songLyricSettings);
  }

  store.box<SongLyricSettingsModel>().putMany(songLyricsSettings);
}

@riverpod
SongLyric? songLyric(SongLyricRef ref, int id) {
  if (id == 0) return null;

  return ref.read(appDependenciesProvider).store.box<SongLyric>().get(id);
}

@Riverpod(keepAlive: true)
List<SongLyric> songLyrics(SongLyricsRef ref) {
  final random = Random();
  final songLyrics =
      queryStore(ref, orderBy: SongLyric_.name).where((songLyric) => songLyric.shouldAppearToUser).toList();

  return switch (ref.watch(sortProvider)) {
    SortType.random => songLyrics..sort((_, __) => random.nextDouble().compareTo(random.nextDouble())),
    SortType.alpha => songLyrics..sort((a, b) => a.name.compareTo(b.name)),
    SortType.numeric => songLyrics..sort((a, b) => a.id.compareTo(b.id)),
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
