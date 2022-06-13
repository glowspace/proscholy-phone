import 'package:objectbox/objectbox.dart';

enum TagType {
  liturgyPart,
  liturgyPeriod,
  sacredOccasion,
  saints,
  historyPeriod,
  instrumentation,
  genre,
  musicalForm,
  generic,
  language,
  unknown
}

extension TagTypeExtension on TagType {
  static TagType fromString(String string) {
    switch (string) {
      case 'LITURGY_PART':
        return TagType.liturgyPart;
      case 'LITURGY_PERIOD':
        return TagType.liturgyPeriod;
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

  int get rawValue => TagType.values.indexOf(this);

  bool get supported {
    switch (this) {
      case TagType.generic:
      case TagType.liturgyPart:
      case TagType.liturgyPeriod:
      case TagType.saints:
      case TagType.language:
      case TagType.sacredOccasion:
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
        return 'Liturgie - mše svatá';
      case TagType.liturgyPeriod:
        return 'Liturgický rok';
      case TagType.saints:
        return 'Ke svatým';
      case TagType.sacredOccasion:
        return 'Svátosti a pobožnosti';
      case TagType.language:
        return 'Jazyky';
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

  Tag(this.id, this.name);

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      int.parse(json['id'] as String),
      json['name'] as String,
    );
  }

  static List<Tag> fromMapList(Map<String, dynamic> json) {
    return (json['tags_enum'] as List).map((json) => Tag.fromJson(json)).toList();
  }

  @override
  String toString() => 'Tag(id: $id, name: $name)';
}

// import 'package:zpevnik/models/model.dart' as model;

// // wrapper around Tag db model for easier field access
// class Tag {
//   final model.Tag entity;

//   Tag(this.entity);

//   Tag.clone(Tag tag) : entity = tag.entity;

//   static Future<List<Tag>> get tags async {
//     final entities = await model.Tag().select().orderBy('id').toList();

//     return entities.map((entity) => Tag(entity)).toList();
//   }

//   int get id => entity.id ?? 0;
//   String get name => entity.name ?? '';
//   TagType get type => TagTypeExtension.fromString(entity.type_enum ?? '');

//   // TODO: remove isSelected and use it from songlyricsprovider
//   bool _isSelected = false;
//   bool get isSelected => _isSelected;

//   void toggleIsSelected() => _isSelected = !_isSelected;
// }

// class TagsSection {
//   final String title;
//   final List<Tag> tags;

//   TagsSection(this.title, this.tags);
// }
