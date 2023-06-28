import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';

part 'playlist_record.freezed.dart';

@freezed
class PlaylistRecord with _$PlaylistRecord implements Identifiable, Record {
  @Entity(realClass: PlaylistRecord)
  const factory PlaylistRecord({
    @Id(assignable: true) required int id,
    required int rank,
    required ToOne<SongLyric> songLyric,
    required ToOne<CustomText> customText,
    required ToOne<BibleVerse> bibleVerse,
    required ToOne<Playlist> playlist,
  }) = _PlaylistRecord;
}
