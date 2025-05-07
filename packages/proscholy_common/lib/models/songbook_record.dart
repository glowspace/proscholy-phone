import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';

part 'generated/songbook_record.freezed.dart';
part 'generated/songbook_record.g.dart';

@Freezed(toJson: false, equal: false)
sealed class SongbookRecord with _$SongbookRecord implements Comparable<SongbookRecord>, Identifiable, Record {
  static const String fieldKey = 'songbook_records';

  const SongbookRecord._();

  @Entity(realClass: SongbookRecord)
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory SongbookRecord({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String number,
    @JsonKey(fromJson: _songLyricFromJson) required ToOne<SongLyric> songLyric,
    @JsonKey(fromJson: _songbookFromJson) required ToOne<Songbook> songbook,
  }) = _SongbookRecord;

  factory SongbookRecord.fromJson(Map<String, Object?> json) => _$SongbookRecordFromJson(json);

  String get numberWithShortcut => '${songbook.target!.shortcut}$number';

  @override
  int compareTo(SongbookRecord other) => compareNatural(number, other.number);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is SongbookRecord && id == other.id;
}

ToOne<SongLyric> _songLyricFromJson(Map<String, dynamic> json) => ToOne(targetId: int.parse(json['id']));

ToOne<Songbook> _songbookFromJson(Map<String, dynamic> json) => ToOne(targetId: int.parse(json['id']));
