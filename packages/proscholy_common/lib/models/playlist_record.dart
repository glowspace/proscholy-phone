import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/models/bible_verse.dart';
import 'package:proscholy_common/models/custom_text.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';

part 'generated/playlist_record.freezed.dart';

@Freezed(equal: false)
sealed class PlaylistRecord with _$PlaylistRecord implements Identifiable, Record {
  const PlaylistRecord._();

  @Entity(realClass: PlaylistRecord)
  const factory PlaylistRecord({
    @Id(assignable: true) required int id,
    required int rank,
    required ToOne<SongLyric> songLyric,
    required ToOne<CustomText> customText,
    required ToOne<BibleVerse> bibleVerse,
    required ToOne<Playlist> playlist,
  }) = _PlaylistRecord;

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is PlaylistRecord && id == other.id;
}
