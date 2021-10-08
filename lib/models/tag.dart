import 'package:zpevnik/models/model.dart' as model;

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

// wrapper around Tag db model for easier field access
class Tag {
  final model.Tag entity;

  Tag(this.entity);

  Tag.clone(Tag tag) : entity = tag.entity;

  static Future<List<Tag>> get tags async {
    final entities = await model.Tag().select().orderBy('id').toList();

    return entities.map((entity) => Tag(entity)).toList();
  }

  int get id => entity.id ?? 0;
  String get name => entity.name ?? '';
  TagType get type => TagTypeExtension.fromString(entity.type_enum ?? '');

  bool _isSelected = false;
  bool get isSelected => _isSelected;

  void toggleIsSelected() => _isSelected = !_isSelected;
}
