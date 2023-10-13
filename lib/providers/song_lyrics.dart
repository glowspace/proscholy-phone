import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/settings.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/utils.dart';

part 'song_lyrics.g.dart';

// TODO: remove this after some time, that all users have at least 3.1.0 version
void migrateSongLyricSettingsModel(Store store) {
  final query = store
      .box<SongLyric>()
      .query(SongLyric_.transposition
          .notEquals(0)
          .or(SongLyric_.accidentals.notNull())
          .or(SongLyric_.showChords.notNull()))
      .build();
  final songLyricsWithSettings = query.find();

  query.close();

  int id = () {
    final queryBuilder = store.box<SongLyricSettingsModel>().query()
      ..order(SongLyricSettingsModel_.id, flags: Order.descending);
    final query = queryBuilder.build();
    final lastId = query.findFirst()?.id ?? 0;

    query.close();

    return lastId + 1;
  }();

  final songLyricsSettings = <SongLyricSettingsModel>[];

  for (int i = 0; i < songLyricsWithSettings.length; i++) {
    final songLyric = songLyricsWithSettings[i];
    final songLyricSettings = SongLyricSettingsModel(
        id: id++,
        showChords: songLyric.showChords ?? true,
        showMusicalNotes: true,
        accidentals: songLyric.accidentals ?? 1,
        transposition: songLyric.transposition ?? 0);

    songLyricsSettings.add(songLyricSettings);
    songLyricsWithSettings[i] = songLyric.copyWith(
      transposition: 0,
      accidentals: null,
      showChords: null,
      settings: ToOne(target: songLyricSettings),
    );
  }

  store.box<SongLyric>().putMany(songLyricsWithSettings);
  store.box<SongLyricSettingsModel>().putMany(songLyricsSettings);
}

@Riverpod(keepAlive: true)
List<SongLyric> songLyrics(SongLyricsRef ref) {
  final songLyrics = queryStore(
    ref,
    condition: SongLyric_.lyrics.notNull().or(SongLyric_.lilypond.notNull()),
    orderBy: SongLyric_.name,
  );

  return songLyrics;
}

@riverpod
List<SongLyric> songsListSongLyrics(SongsListSongLyricsRef ref, SongsList songsList) {
  return [
    for (final record in songsList.records)
      if (record.songLyric.target != null) record.songLyric.target!
  ];
}
