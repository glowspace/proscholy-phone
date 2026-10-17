import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/models/bible_passage.dart';
import 'package:proscholy_common/models/user_text.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/song_lyric.dart';

part 'generated/playlist_record.freezed.dart';

@freezed
sealed class PlaylistRecord with _$PlaylistRecord implements Identifiable, Record {
  const PlaylistRecord._();

  @Entity(realClass: PlaylistRecord)
  const factory PlaylistRecord({
    @Id(assignable: true) required int id,
    required int rank,
    required ToOne<SongLyric> songLyric,
    required ToOne<UserText> userText,
    required ToOne<BiblePassage> biblePassage,
    required ToOne<Playlist> playlist,
  }) = _PlaylistRecord;

  factory PlaylistRecord.songLyric({
    required int id,
    required int rank,
    required Playlist playlist,
    required SongLyric songLyric,
  }) => PlaylistRecord(
    id: id,
    rank: rank,
    songLyric: ToOne(target: songLyric),
    userText: ToOne(),
    biblePassage: ToOne(),
    playlist: ToOne(target: playlist),
  );

  factory PlaylistRecord.userText({
    required int id,
    required int rank,
    required Playlist playlist,
    required UserText userText,
  }) => PlaylistRecord(
    id: id,
    rank: rank,
    songLyric: ToOne(),
    userText: ToOne(target: userText),
    biblePassage: ToOne(),
    playlist: ToOne(target: playlist),
  );

  factory PlaylistRecord.biblePassage({
    required int id,
    required int rank,
    required Playlist playlist,
    required BiblePassage biblePassage,
  }) => PlaylistRecord(
    id: id,
    rank: rank,
    songLyric: ToOne(),
    userText: ToOne(),
    biblePassage: ToOne(target: biblePassage),
    playlist: ToOne(target: playlist),
  );

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is PlaylistRecord && id == other.id;
}
