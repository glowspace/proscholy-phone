// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/models/tag.dart';

enum SongLyricType {
  original,
  translation,
  authorizedTranslation,
}

extension SongLyricTypeExtension on SongLyricType {
  static SongLyricType fromString(String? string) {
    switch (string) {
      case "ORIGINAL":
        return SongLyricType.original;
      case "AUTHORIZED_TRANSLATION":
        return SongLyricType.authorizedTranslation;
      default:
        return SongLyricType.translation;
    }
  }

  static SongLyricType fromIndex(int index) {
    switch (index) {
      case 0:
        return SongLyricType.original;
      case 1:
        return SongLyricType.authorizedTranslation;
      default:
        return SongLyricType.translation;
    }
  }

  int get index {
    switch (this) {
      case SongLyricType.original:
        return 0;
      case SongLyricType.authorizedTranslation:
        return 1;
      default:
        return 2;
    }
  }

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
}

@Entity()
class SongLyric {
  @Id(assignable: true)
  final int id;

  final String name;
  final String? secondaryName1;
  final String? secondaryName2;

  final String? lyrics;
  final String? lilypond;

  final String? lang;
  final String? langDescription;

  final int dbType;

  final authors = ToMany<Author>();
  final song = ToOne<Song>();
  final tags = ToMany<Tag>();

  @Backlink()
  final externals = ToMany<External>();

  @Backlink()
  final songbookRecords = ToMany<SongbookRecord>();

  SongLyric(
    this.id,
    this.name,
    this.secondaryName1,
    this.secondaryName2,
    this.lyrics,
    this.lilypond,
    this.lang,
    this.langDescription,
    this.dbType,
  );

  factory SongLyric.fromJson(Map<String, dynamic> json, Store store) {
    final id = int.parse(json['id'] as String);

    final authors = store.box<Author>().getMany(
        (json['authors_pivot'] as List).map((json) => int.parse(json['pivot']['author']['id'] as String)).toList());
    final tags =
        store.box<Tag>().getMany((json['tags'] as List).map((json) => int.parse(json['id'] as String)).toList());

    final songbookRecords = SongbookRecord.fromMapList(json, id);
    final externals = External.fromMapList(json, id);

    return SongLyric(
      id,
      json['name'] as String,
      json['secondary_name_1'] as String?,
      json['secondary_name_2'] as String?,
      json['lyrics'] as String?,
      json['lilypond_svg'] as String?,
      json['lang'] as String,
      json['lang_string'] as String,
      SongLyricTypeExtension.fromString(json['type_enum'] as String?).index,
    )
      ..authors.addAll(authors.cast())
      ..song.targetId = json['song'] == null ? null : int.parse(json['song']['id'] as String)
      ..tags.addAll(tags.cast())
      ..externals.addAll(externals)
      ..songbookRecords.addAll(songbookRecords);
  }

  static List<SongLyric> fromMapList(Map<String, dynamic> json, Store store) {
    return (json['song_lyrics'] as List).map((json) => SongLyric.fromJson(json, store)).toList();
  }

  static List<SongLyric> load(Store store) {
    final query = store.box<SongLyric>().query(SongLyric_.lyrics.notNull());
    query.order(SongLyric_.name);

    return query.build().find();
  }

  SongLyricType get type => SongLyricTypeExtension.fromIndex(dbType);

  String get authorsText {
    if (type == SongLyricType.original) {
      if (authors.isEmpty) {
        return 'Autor neznámý';
      } else if (authors.length == 1) {
        return 'Autor: ${authors[0].name}';
      } else {
        return 'Autoři: ${authors.map((author) => author.name).toList().join(", ")}';
      }
    } else {
      String originalText = '';

      final original = song.target?.songLyrics
          .cast()
          .firstWhere((songLyric) => songLyric.type == SongLyricType.original, orElse: () => null);

      if (original != null) {
        originalText = 'Originál: ${original.name}\n';

        originalText += '${original.authorsText}\n';
      }

      if (authors.isEmpty) {
        return '${originalText}Autor překladu neznámý';
      } else if (authors.length == 1) {
        return '${originalText}Autor překladu: ${authors[0].name}';
      } else {
        return '${originalText}Autoři překladu: ${authors.map((author) => author.name).toList().join(", ")}';
      }
    }
  }

  @override
  String toString() => 'SongLyric(id: $id, name: $name)';
}

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:zpevnik/constants.dart';
// import 'package:zpevnik/models/author.dart';
// import 'package:zpevnik/models/external.dart';
// import 'package:zpevnik/models/model.dart' as model;
// import 'package:zpevnik/models/songbook.dart';
// import 'package:zpevnik/models/songbook_record.dart';
// import 'package:zpevnik/providers/data.dart';

// enum SongLyricType {
//   original,
//   translation,
//   authorizedTranslation,
// }

// extension SongLyricTypeExtension on SongLyricType {
//   static SongLyricType fromString(String string) {
//     switch (string) {
//       case "ORIGINAL":
//         return SongLyricType.original;
//       case "AUTHORIZED_TRANSLATION":
//         return SongLyricType.authorizedTranslation;
//       default:
//         return SongLyricType.translation;
//     }
//   }

//   int get rawValue => SongLyricType.values.indexOf(this);

//   String get description {
//     switch (this) {
//       case SongLyricType.original:
//         return "Originál";
//       case SongLyricType.authorizedTranslation:
//         return "Autorizovaný překlad";
//       default:
//         return "Překlad";
//     }
//   }

//   Color get color {
//     switch (this) {
//       case SongLyricType.original:
//         return blue;
//       case SongLyricType.authorizedTranslation:
//         return yellow;
//       default:
//         return green;
//     }
//   }
// }

// // wrapper around SongLyric db model for easier field access
// class SongLyric {
//   final model.SongLyric entity;

//   static int _nextFavoriteOrder = 0;

//   SongLyric(this.entity) {
//     _nextFavoriteOrder = max(_nextFavoriteOrder, favoriteRank + 1);
//   }

//   static Future<List<SongLyric>> get songLyrics async {
//     final entities =
//         await model.SongLyric().select().lyrics.not.isNull().or.lilypond_svg.not.isNull().orderBy('name').toList();

//     return entities.map((entity) => SongLyric(entity)).toList();
//   }

//   final Map<int, SongbookRecord> songbookRecords = {};

//   int get id => entity.id ?? 0;
//   String get name => entity.name ?? '';
//   String get lyrics => entity.lyrics ?? '';
//   String? get lilypond => entity.lilypond_svg;
//   String get language => entity.lang_string ?? '';
//   SongLyricType get type => SongLyricTypeExtension.fromString(entity.type_enum ?? '');
//   int? get songId => entity.songsId;

//   int get favoriteRank => entity.favorite_rank ?? -1;
//   bool get isFavorite => entity.favorite_rank != null;

//   bool? get showChords => entity.show_chords;
//   int get transposition => entity.transposition ?? 0;
//   int? get accidentals => entity.accidentals;

//   // TODO: this should not be here
//   Key get key => Key(id.toString());

//   String? get secondaryName {
//     String? name;

//     if (entity.secondary_name_1 != null) name = '${entity.secondary_name_1}';
//     if (entity.secondary_name_2 != null) name = '$name\n${entity.secondary_name_2}';

//     return name;
//   }

//   set favoriteRank(int value) {
//     entity.favorite_rank = value;
//     entity.save();
//   }

//   set showChords(bool? newValue) {
//     entity.show_chords = newValue;
//     entity.save();
//   }

//   set transposition(int newValue) {
//     if (newValue == 12 || newValue == -12) newValue = 0;

//     entity.transposition = newValue;
//     entity.save();
//   }

//   set accidentals(int? newValue) {
//     entity.accidentals = newValue;
//     entity.save();
//   }

//   void toggleFavorite() {
//     if (isFavorite) {
//       entity.favorite_rank = null;
//     } else {
//       entity.favorite_rank = _nextFavoriteOrder++;
//     }

//     entity.save();
//   }

//   String number(Songbook? songbook) {
//     if (songbook != null) return songbookRecords[songbook.id]?.number ?? '0';

//     return entity.id.toString();
//   }

//   final List<int> tagIds = [];
//   final List<Author> authors = [];

//   String? _authorsText;
//   String authorsText(DataProvider provider) {
//     if (_authorsText != null) return _authorsText!;

//     String text;

//     if (type == SongLyricType.original) {
//       if (authors.length == 0)
//         text = 'Autor neznámý';
//       else if (authors.length == 1)
//         text = 'Autor: ${authors[0].name}';
//       else
//         text = 'Autoři: ${authors.map((author) => author.name).toList().join(", ")}';
//     } else {
//       String originalText = '';

//       try {
//         final songLyrics = provider.songsSongLyrics(songId ?? -1);
//         final original = songLyrics?.firstWhere((songLyric) => songLyric.type == SongLyricType.original);

//         if (original != null) {
//           originalText = 'Originál: ${original.name}\n';

//           originalText += '${original.authorsText(provider)}\n';
//         }
//       } on StateError {}

//       if (authors.length == 0)
//         text = '${originalText}Autor překladu neznámý';
//       else if (authors.length == 1)
//         text = '${originalText}Autor překladu: ${authors[0].name}';
//       else
//         text = '${originalText}Autoři překladu: ${authors.map((author) => author.name).toList().join(", ")}';
//     }

//     return _authorsText ??= text;
//   }

//   bool get hasExternals => youtubes.isNotEmpty;

//   final List<External> externals = [];
//   List<External> get youtubes => externals.where((external) => external.isYoutubeVideo).toList();
// }
