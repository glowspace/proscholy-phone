import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/entities/tag.dart';

enum TagType {
  liturgyPart,
  liturgyPeriod,
  saints,
  historyPeriod,
  instrumentation,
  genre,
  musicalForm,
  generic,
  language
}

extension TagTypeExtension on TagType {
  static TagType fromString(String string) {
    switch (string) {
      case "LITURGY_PART":
        return TagType.liturgyPart;
      case "LITURGY_PERIOD":
        return TagType.liturgyPeriod;
      case "SAINTS":
        return TagType.saints;
      case "HISTORY_PERIOD":
        return TagType.historyPeriod;
      case "INSTRUMENTATION":
        return TagType.instrumentation;
      case "GENRE":
        return TagType.genre;
      case "MUSICAL_FORM":
        return TagType.musicalForm;
      default:
        return TagType.generic;
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
        return true;
      default:
        return false;
    }
  }

  String get description {
    switch (this) {
      case TagType.generic:
        return "Příležitosti";
      case TagType.liturgyPart:
        return "Liturgie - mše svatá";
      case TagType.liturgyPeriod:
        return "Liturgický rok";
      case TagType.saints:
        return "Ke svatým";
      case TagType.language:
        return "Jazyky";
      default:
        return "Filtry";
    }
  }

  Color get selectedColor {
    switch (this) {
      case TagType.liturgyPart:
        return blue;
      case TagType.liturgyPeriod:
        return red;
      case TagType.saints:
      case TagType.generic:
        return green;
      case TagType.language:
        return red;
      default:
        return Colors.transparent;
    }
  }
}

class Tag {
  final TagEntity _entity;

  Tag(this._entity);

  int get id => _entity.id;

  String get name => _entity.name;

  TagType get type => TagType.values[_entity.type];
}
