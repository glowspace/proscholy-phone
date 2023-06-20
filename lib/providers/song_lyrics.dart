import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/tags.dart';
import 'package:zpevnik/providers/utils.dart';

part 'song_lyrics.g.dart';

@riverpod
List<SongLyric> songLyrics(SongLyricsRef ref) {
  final songLyrics = queryStore(
    ref,
    condition: SongLyric_.lyrics.notNull().or(SongLyric_.lilypond.notNull()),
    orderBy: SongLyric_.name,
  );

  return songLyrics;
}

@riverpod
List<SongLyric> filteredSongLyrics(FilteredSongLyricsRef ref, List<SongLyric> songLyrics) {
  final filteredSongLyrics = <SongLyric>[...songLyrics];

  for (int i = filteredSongLyrics.length - 1; i >= 0; i--) {
    final songLyric = filteredSongLyrics[i];

    for (final tagType in supportedTagTypes) {
      final selectedTags = ref.watch(selectedTagsByTypeProvider(tagType));

      if (selectedTags.isNotEmpty) {
        bool shouldKeep = false;

        switch (tagType) {
          case TagType.language:
            shouldKeep = selectedTags.any((tag) => tag.name == songLyric.langDescription);
            break;
          case TagType.playlist:
            shouldKeep = selectedTags.any((tag) => songLyric.playlistRecords
                .map((playlistRecord) => playlistRecord.playlist.target!)
                .any((playlist) => tag.name == playlist.name));
            break;
          case TagType.songbook:
            shouldKeep = selectedTags.any((tag) => songLyric.songbookRecords
                .map((songbookRecord) => songbookRecord.songbook.target!)
                .any((songbook) => tag.name == songbook.name));
            break;
          default:
            shouldKeep = songLyric.tags.any((tag) => selectedTags.contains(tag));
            break;
        }

        if (!shouldKeep) {
          filteredSongLyrics.removeAt(i);
          break;
        }
      }
    }
  }

  return filteredSongLyrics;
}

@riverpod
List<SongLyric> songsListSongLyrics(SongsListSongLyricsRef ref, SongsList songsList) {
  return [
    for (final record in songsList.records)
      if (record.songLyric.target != null) record.songLyric.target!
  ];
}
