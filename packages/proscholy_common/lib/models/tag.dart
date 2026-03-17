// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proscholy_common/models/model.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/songbook.dart';

part 'generated/tag.freezed.dart';
part 'generated/tag.g.dart';

// offset for songbook tags, tags from API have id > 0, language tags have negative id starting from -1, so these offsets should be enough
const int _languageTagIdOffset = -1;
const int kSongbookTagIdOffset = -1000;
const int kPlaylistTagIdOffset = -2000;

enum TagType {
  liturgyPart,
  liturgyPeriod,
  liturgyDay,
  sacredOccasion,
  saints,
  historyPeriod,
  instrumentation,
  genre,
  musicalForm,
  generic,
  language,
  songbook,
  playlist,
  unknown;

  factory TagType.fromRawValue(int rawValue) => switch (rawValue) {
        0 => TagType.liturgyPart,
        1 => TagType.liturgyPeriod,
        2 => TagType.generic,
        3 => TagType.historyPeriod,
        4 => TagType.instrumentation,
        5 => TagType.genre,
        6 => TagType.musicalForm,
        7 => TagType.sacredOccasion,
        8 => TagType.saints,
        9 => TagType.language,
        10 => TagType.liturgyDay,
        11 => TagType.songbook,
        12 => TagType.playlist,
        _ => TagType.unknown,
      };

  static int rawValueFromString(String string) => switch (string) {
        'LITURGY_PART' => 0,
        'LITURGY_PERIOD' => 1,
        'LITURGY_DAY' => 10,
        'SAINTS' => 8,
        'HISTORY_PERIOD' => 3,
        'INSTRUMENTATION' => 4,
        'GENRE' => 5,
        'MUSICAL_FORM' => 6,
        'SACRED_OCCASION' => 7,
        'LANGUAGE' => 9,
        'GENERIC' => 2,
        _ => -1,
      };

  int get rawValue => switch (this) {
        TagType.liturgyPart => 0,
        TagType.liturgyPeriod => 1,
        TagType.generic => 2,
        TagType.historyPeriod => 3,
        TagType.instrumentation => 4,
        TagType.genre => 5,
        TagType.musicalForm => 6,
        TagType.sacredOccasion => 7,
        TagType.saints => 8,
        TagType.language => 9,
        TagType.liturgyDay => 10,
        TagType.songbook => 11,
        TagType.playlist => 12,
        _ => -1,
      };
}

@Freezed(toJson: false, equal: false)
sealed class Tag extends Model with _$Tag {
  const Tag._();

  @Entity(realClass: Tag)
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Tag({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String name,
    @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString) required int dbType,
    required int songLyricsCount,
  }) = _Tag;

  factory Tag.fromSongbook(Songbook songbook) {
    return Tag(
      id: kSongbookTagIdOffset - songbook.id,
      name: songbook.name,
      dbType: TagType.songbook.rawValue,
      songLyricsCount: songbook.records.length,
    );
  }

  factory Tag.fromPlaylist(Playlist playlist) {
    return Tag(
      id: kPlaylistTagIdOffset - playlist.id,
      name: playlist.name,
      dbType: TagType.playlist.rawValue,
      songLyricsCount: playlist.records.length,
    );
  }

  factory Tag.fromLanguage(int id, String language, int songLyricsCount) {
    return Tag(
      id: _languageTagIdOffset - id,
      name: language,
      dbType: TagType.language.rawValue,
      songLyricsCount: songLyricsCount,
    );
  }

  factory Tag.fromJson(Map<String, Object?> json) => _$TagFromJson(json);

  TagType get type => TagType.fromRawValue(dbType);
}
