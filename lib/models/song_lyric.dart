import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/models/settings.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/models/utils.dart';

part 'song_lyric.freezed.dart';
part 'song_lyric.g.dart';

enum SongLyricType {
  original('Originál'),
  translation('Překlad'),
  authorizedTranslation('Autorizovaný překlad');

  final String description;

  const SongLyricType(this.description);

  static int rawValueFromString(String? string) {
    switch (string) {
      case "ORIGINAL":
        return 0;
      case "AUTHORIZED_TRANSLATION":
        return 1;
      default:
        return 2;
    }
  }

  factory SongLyricType.fromRawValue(int rawValue) {
    switch (rawValue) {
      case 0:
        return SongLyricType.original;
      case 1:
        return SongLyricType.authorizedTranslation;
      default:
        return SongLyricType.translation;
    }
  }
}

@Freezed(toJson: false, equal: false)
class SongLyric with _$SongLyric implements DisplayableItem, Identifiable, RecentItem {
  static const String fieldKey = 'song_lyrics';

  const SongLyric._();

  @Entity(realClass: SongLyric)
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory SongLyric({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String name,
    @JsonKey(name: 'secondary_name_1') String? secondaryName1,
    @JsonKey(name: 'secondary_name_2') String? secondaryName2,
    String? lyrics,
    @JsonKey(name: 'lilypond_svg') String? lilypond,
    required String lang,
    @JsonKey(name: 'lang_string') required String langDescription,
    @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString) required int dbType,
    required bool hasChords,
    @Deprecated('is handled independently on model') int? accidentals,
    @Deprecated('is handled independently on model') bool? showChords,
    @Deprecated('is handled independently on model') int? transposition,
    @JsonKey(fromJson: _songFromJson) required ToOne<Song> song,
    @JsonKey(fromJson: _settingsFromJson) required ToOne<SongLyricSettingsModel> settings,
    @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson) required ToMany<Author> authors,
    @JsonKey(fromJson: _tagsFromJson) required ToMany<Tag> tags,
    @JsonKey(fromJson: _externalsFromJson) required ToMany<External> externals,
    @Backlink() @JsonKey(fromJson: _songbookRecordsFromJson) required ToMany<SongbookRecord> songbookRecords,
    @Backlink() @JsonKey(fromJson: _playlistRecordsFromJson) required ToMany<PlaylistRecord> playlistRecords,
  }) = _SongLyric;

  factory SongLyric.fromJson(Map<String, Object?> json) => _$SongLyricFromJson(json);

  SongLyricType get type => SongLyricType.fromRawValue(dbType);

  // show song lyrics that have lyrics or lilypond or supported external files or supported recordings
  bool get shouldAppearToUser => hasLyrics || hasLilypond || hasFiles || hasRecordings;

  bool get hasTranslations => song.target?.hasTranslations ?? false;

  bool get hasLyrics => lyrics != null && lyrics!.isNotEmpty;
  bool get hasLilypond => lilypond != null && lilypond!.isNotEmpty;

  // temporary fix, until API provides correct value
  bool get hasChordsReal => lyrics?.contains('[') ?? false;

  bool get hasFiles {
    return externals.any((external) => external.mediaType == MediaType.pdf || external.mediaType == MediaType.jpg);
  }

  bool get hasRecordings {
    return externals.any((external) => external.mediaType == MediaType.youtube || external.mediaType == MediaType.mp3);
  }

  bool get hasTags => tags.isNotEmpty;
  bool get hasSongbooks => songbookRecords.isNotEmpty;

  bool get isFavorite =>
      playlistRecords.any((playlistRecord) => playlistRecord.playlist.targetId == favoritesPlaylistId);

  String get authorsText {
    if (type == SongLyricType.original) {
      if (authors.isEmpty) {
        return 'Autor neznámý';
      } else if (authors.length == 1) {
        return 'Autor: ${authors.first.name}';
      } else {
        return 'Autoři: ${authors.map((author) => author.name).join(", ")}';
      }
    } else {
      final original = song.target?.original;

      String originalText = original != null ? 'Originál: ${original.name}\n${original.authorsText}, ' : '';

      if (authors.isEmpty) {
        return '${originalText}Autor překladu neznámý';
      } else if (authors.length == 1) {
        return '${originalText}Autor překladu: ${authors.first.name}';
      } else {
        return '${originalText}Autoři překladu: ${authors.map((author) => author.name).join(", ")}';
      }
    }
  }

  List<External> get files {
    return externals
        .where((external) => external.mediaType == MediaType.pdf || external.mediaType == MediaType.jpg)
        .toList();
  }

  @override
  RecentItemType get recentItemType => RecentItemType.songLyric;

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is SongLyric && id == other.id;
}

ToOne<Song> _songFromJson(Map<String, dynamic>? json) {
  return json == null ? ToOne() : ToOne(targetId: int.parse(json['id']));
}

ToOne<SongLyricSettingsModel> _settingsFromJson(Map<String, dynamic>? json) => ToOne();

ToMany<Author> _authorsFromJson(List<dynamic> jsonList) {
  final authors = [for (final json in jsonList) Author(id: int.parse(json['pivot']['author']['id']), name: '')];

  return ToMany(items: authors);
}

ToMany<Tag> _tagsFromJson(List<dynamic> jsonList) {
  final tags = [for (final json in jsonList) Tag(id: int.parse(json['id']), name: '', dbType: 0)];

  return ToMany(items: tags);
}

ToMany<External> _externalsFromJson(List<dynamic> jsonList) {
  return ToMany(items: readJsonList(jsonList, mapper: External.fromJson));
}

ToMany<SongbookRecord> _songbookRecordsFromJson(List<dynamic> jsonList) {
  return ToMany(items: readJsonList(jsonList, mapper: (json) => SongbookRecord.fromJson(json['pivot'])));
}

ToMany<PlaylistRecord> _playlistRecordsFromJson(List<dynamic>? jsonList) => ToMany();
