import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/model.dart' as model;
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/providers/data.dart';

enum SongLyricType {
  original,
  translation,
  authorizedTranslation,
}

extension SongLyricTypeExtension on SongLyricType {
  static SongLyricType fromString(String string) {
    switch (string) {
      case "ORIGINAL":
        return SongLyricType.original;
      case "AUTHORIZED_TRANSLATION":
        return SongLyricType.authorizedTranslation;
      default:
        return SongLyricType.translation;
    }
  }

  int get rawValue => SongLyricType.values.indexOf(this);

  String get description {
    switch (this) {
      case SongLyricType.original:
        return "Originál";
      case SongLyricType.authorizedTranslation:
        return "Autorizovaný překlad";
      default:
        return "Překlad";
    }
  }

  Color get color {
    switch (this) {
      case SongLyricType.original:
        return blue;
      case SongLyricType.authorizedTranslation:
        return yellow;
      default:
        return green;
    }
  }
}

// wrapper around SongLyric db model for easier field access
class SongLyric {
  final model.SongLyric entity;

  static int _nextFavoriteOrder = 0;

  SongLyric(this.entity) {
    _nextFavoriteOrder = max(_nextFavoriteOrder, favoriteRank + 1);

    _isFavoriteNotifier = ValueNotifier(isFavorite);
  }

  // nofier for favorites list screen so it knows when to update showing list
  late ValueNotifier<bool> _isFavoriteNotifier;

  static Future<List<SongLyric>> get songLyrics async {
    final entities =
        await model.SongLyric().select().lyrics.not.isNull().or.lilypond_svg.not.isNull().orderBy('name').toList();

    return entities.map((entity) => SongLyric(entity)).toList();
  }

  int get id => entity.id ?? 0;
  String get name => entity.name ?? '';
  String get lyrics => entity.lyrics ?? '';
  String? get lilypond => entity.lilypond_svg;
  String get language => entity.lang_string ?? '';
  SongLyricType get type => SongLyricTypeExtension.fromString(entity.type_enum ?? '');
  int? get songId => entity.songsId;
  int get favoriteRank => entity.favorite_rank ?? -1;

  bool? get showChords => entity.show_chords;
  int get transposition => entity.transposition ?? 0;
  int? get accidentals => entity.accidentals;

  Key get key => Key(id.toString());

  set favoriteRank(int value) {
    entity.favorite_rank = value;
    entity.upsert();
  }

  set showChords(bool? newValue) {
    entity.show_chords = newValue;
    entity.upsert();
  }

  set transposition(int newValue) {
    if (newValue == 12 || newValue == -12) newValue = 0;

    entity.transposition = newValue;
    entity.save();
  }

  set accidentals(int? newValue) {
    entity.accidentals = newValue;
    entity.upsert();
  }

  bool get isFavorite => entity.favorite_rank != null;
  ValueNotifier<bool> get isFavoriteNotifier => _isFavoriteNotifier;

  String? get secondaryName {
    String? name;

    if (entity.secondary_name_1 != null) name = '${entity.secondary_name_1}';
    if (entity.secondary_name_2 != null) name = '${name == null ? '' : '$name\n'}${entity.secondary_name_2}';

    return name;
  }

  final songbookRecords = Map<int, SongbookRecord>.from({});

  String number(Songbook? songbook) {
    if (songbook != null) return songbookRecords[songbook.id]?.number ?? '0';

    return entity.id.toString();
  }

  final tagIds = List<int>.empty(growable: true);
  // List<int> get tagIds => _tagIds ?? [];

  final authors = List<Author>.empty(growable: true);
  // List<model.Author> get authors => _authors;

  String? _authorsText;
  String authorsText(DataProvider provider) {
    if (_authorsText != null) return _authorsText!;

    String text;

    if (type == SongLyricType.original) {
      if (authors.length == 0)
        text = 'Autor neznámý';
      else if (authors.length == 1)
        text = 'Autor: ${authors[0].name}';
      else
        text = 'Autoři: ${authors.map((author) => author.name).toList().join(", ")}';
    } else {
      String originalText = '';

      try {
        final songLyrics = provider.songsSongLyrics(songId ?? -1);
        final original = songLyrics?.firstWhere((songLyric) => songLyric.type == SongLyricType.original);

        if (original != null) {
          originalText = 'Originál: ${original.name}\n';

          originalText += '${original.authorsText(provider)}\n';
        }
      } on StateError {}

      if (authors.length == 0)
        text = '${originalText}Autor překladu neznámý';
      else if (authors.length == 1)
        text = '${originalText}Autor překladu: ${authors[0].name}';
      else
        text = '${originalText}Autoři překladu: ${authors.map((author) => author.name).toList().join(", ")}';
    }

    return _authorsText ??= text;
  }

  bool get hasExternals => youtubes.isNotEmpty;

  final externals = List<External>.empty(growable: true);
  List<External> get youtubes => externals.where((external) => external.isYoutube).toList();

  void toggleFavorite() {
    if (isFavorite)
      entity.favorite_rank = null;
    else
      entity.favorite_rank = _nextFavoriteOrder++;

    _isFavoriteNotifier.value = isFavorite;

    entity.upsert();
  }
}
