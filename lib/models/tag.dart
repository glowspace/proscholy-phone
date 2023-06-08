import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

enum TagType {
  liturgyPart('Mše svatá'),
  liturgyPeriod('Liturgický rok'),
  liturgyDay('', isSupported: false),
  sacredOccasion('Svátosti a pobožnosti'),
  saints('Ke svatým'),
  historyPeriod('', isSupported: false),
  instrumentation('', isSupported: false),
  genre('', isSupported: false),
  musicalForm('', isSupported: false),
  generic('Příležitosti'),
  language('Jazyky'),
  songbook('Zpěvníky'),
  playlist('Playlisty'),
  unknown('', isSupported: false);

  final String description;
  final bool isSupported;

  const TagType(this.description, {this.isSupported = true});

  static int rawValueFromString(String string) {
    switch (string) {
      case 'LITURGY_PART':
        return 0;
      case 'LITURGY_PERIOD':
        return 1;
      case 'LITURGY_DAY':
        return 10;
      case 'SAINTS':
        return 8;
      case 'HISTORY_PERIOD':
        return 3;
      case 'INSTRUMENTATION':
        return 4;
      case 'GENRE':
        return 5;
      case 'MUSICAL_FORM':
        return 6;
      case 'SACRED_OCCASION':
        return 7;
      case 'LANGUAGE':
        return 9;
      case 'GENERIC':
        return 2;
      default:
        return -1;
    }
  }

  factory TagType.fromRawValue(int rawValue) {
    switch (rawValue) {
      case 0:
        return TagType.liturgyPart;
      case 1:
        return TagType.liturgyPeriod;
      case 2:
        return TagType.generic;
      case 3:
        return TagType.historyPeriod;
      case 4:
        return TagType.instrumentation;
      case 5:
        return TagType.genre;
      case 6:
        return TagType.musicalForm;
      case 7:
        return TagType.sacredOccasion;
      case 8:
        return TagType.saints;
      case 9:
        return TagType.language;
      case 10:
        return TagType.liturgyDay;
      case 11:
        return TagType.songbook;
      case 12:
        return TagType.playlist;
      default:
        return TagType.unknown;
    }
  }
}

@Freezed(toJson: false)
class Tag with _$Tag {
  static const String fieldKey = 'tags_enum';

  const Tag._();

  @Entity(realClass: Tag)
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory Tag({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String name,
    @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString) required int dbType,
  }) = _Tag;

  factory Tag.fromJson(Map<String, Object?> json) => _$TagFromJson(json);

  TagType get type => TagType.fromRawValue(dbType);
}
