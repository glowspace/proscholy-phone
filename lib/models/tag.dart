// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/objectbox.g.dart';

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
  unknown
}

extension TagTypeExtension on TagType {
  static TagType fromString(String string) {
    switch (string) {
      case 'LITURGY_PART':
        return TagType.liturgyPart;
      case 'LITURGY_PERIOD':
        return TagType.liturgyPeriod;
      case 'LITURGY_DAY':
        return TagType.liturgyDay;
      case 'SAINTS':
        return TagType.saints;
      case 'HISTORY_PERIOD':
        return TagType.historyPeriod;
      case 'INSTRUMENTATION':
        return TagType.instrumentation;
      case 'GENRE':
        return TagType.genre;
      case 'MUSICAL_FORM':
        return TagType.musicalForm;
      case 'SACRED_OCCASION':
        return TagType.sacredOccasion;
      case 'LANGUAGE':
        return TagType.language;
      case 'GENERIC':
        return TagType.generic;
      default:
        return TagType.unknown;
    }
  }

  static TagType fromRawValue(int rawValue) {
    switch (rawValue) {
      case 0:
        return TagType.liturgyPart;
      case 1:
        return TagType.liturgyPeriod;
      case 2:
        return TagType.saints;
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
        return TagType.language;
      case 9:
        return TagType.generic;
      case 10:
        return TagType.liturgyDay;
      case 11:
        return TagType.songbook;
      default:
        return TagType.unknown;
    }
  }

  int get rawValue {
    switch (this) {
      case TagType.liturgyPart:
        return 0;
      case TagType.liturgyPeriod:
        return 1;
      case TagType.saints:
        return 2;
      case TagType.historyPeriod:
        return 3;
      case TagType.instrumentation:
        return 4;
      case TagType.genre:
        return 5;
      case TagType.musicalForm:
        return 6;
      case TagType.sacredOccasion:
        return 7;
      case TagType.language:
        return 8;
      case TagType.generic:
        return 9;
      case TagType.liturgyDay:
        return 10;
      case TagType.songbook:
        return 11;
      default:
        return 10;
    }
  }

  bool get supported {
    switch (this) {
      case TagType.generic:
      case TagType.liturgyPart:
      case TagType.liturgyPeriod:
      case TagType.saints:
      case TagType.sacredOccasion:
      case TagType.language:
      case TagType.songbook:
        return true;
      default:
        return false;
    }
  }

  String get description {
    switch (this) {
      case TagType.generic:
        return 'Příležitosti';
      case TagType.liturgyPart:
        return 'Mše svatá';
      case TagType.liturgyPeriod:
        return 'Liturgický rok';
      case TagType.saints:
        return 'Ke svatým';
      case TagType.sacredOccasion:
        return 'Svátosti a pobožnosti';
      case TagType.language:
        return 'Jazyky';
      case TagType.songbook:
        return 'Zpěvníky';
      default:
        return 'Filtry';
    }
  }
}

@Entity()
class Tag {
  @Id(assignable: true)
  final int id;

  final String name;

  final int dbType;

  Tag(this.id, this.name, this.dbType);

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      int.parse(json['id'] as String),
      json['name'] as String,
      TagTypeExtension.fromString(json['type_enum'] as String).rawValue,
    );
  }

  static List<Tag> fromMapList(Map<String, dynamic> json) {
    return (json['tags_enum'] as List).map((json) => Tag.fromJson(json)).toList();
  }

  static List<Tag> load(Store store, _) {
    final query = store.box<Tag>().query();
    query.order(Tag_.id);

    return query.build().find();
  }

  TagType get type => TagTypeExtension.fromRawValue(dbType);

  @override
  String toString() => 'Tag(id: $id, name: $name)';

  @override
  bool operator ==(Object other) => other is Tag && id == other.id;

  @override
  int get hashCode => id;
}

class TagsSection {
  final String title;
  final List<Tag> tags;

  TagsSection(this.title, this.tags);
}
