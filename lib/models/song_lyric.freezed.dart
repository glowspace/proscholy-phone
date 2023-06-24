// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_lyric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SongLyric _$SongLyricFromJson(Map<String, dynamic> json) {
  return _SongLyric.fromJson(json);
}

/// @nodoc
mixin _$SongLyric {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'secondary_name_1')
  String? get secondaryName1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'secondary_name_2')
  String? get secondaryName2 => throw _privateConstructorUsedError;
  String? get lyrics => throw _privateConstructorUsedError;
  @JsonKey(name: 'lilypond_svg')
  String? get lilypond => throw _privateConstructorUsedError;
  String? get lang => throw _privateConstructorUsedError;
  @JsonKey(name: 'lang_string')
  String? get langDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
  int get dbType => throw _privateConstructorUsedError;
  bool get hasChords => throw _privateConstructorUsedError;
  @Deprecated('is handled independently on model')
  int? get accidentals => throw _privateConstructorUsedError;
  @Deprecated('is handled independently on model')
  bool? get showChords => throw _privateConstructorUsedError;
  @Deprecated('is handled independently on model')
  int? get transposition => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _songFromJson)
  ToOne<Song> get song => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _settingsFromJson)
  ToOne<SongLyricSettingsModel> get settings =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
  ToMany<Author> get authors => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _tagsFromJson)
  ToMany<Tag> get tags => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _externalsFromJson)
  ToMany<External> get externals => throw _privateConstructorUsedError;
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  ToMany<SongbookRecord> get songbookRecords =>
      throw _privateConstructorUsedError;
  @Backlink()
  @JsonKey(fromJson: _playlistRecordsFromJson)
  ToMany<PlaylistRecord> get playlistRecords =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongLyricCopyWith<SongLyric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongLyricCopyWith<$Res> {
  factory $SongLyricCopyWith(SongLyric value, $Res Function(SongLyric) then) =
      _$SongLyricCopyWithImpl<$Res, SongLyric>;
  @useResult
  $Res call(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          int id,
      String name,
      @JsonKey(name: 'secondary_name_1')
          String? secondaryName1,
      @JsonKey(name: 'secondary_name_2')
          String? secondaryName2,
      String? lyrics,
      @JsonKey(name: 'lilypond_svg')
          String? lilypond,
      String? lang,
      @JsonKey(name: 'lang_string')
          String? langDescription,
      @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
          int dbType,
      bool hasChords,
      @Deprecated('is handled independently on model')
          int? accidentals,
      @Deprecated('is handled independently on model')
          bool? showChords,
      @Deprecated('is handled independently on model')
          int? transposition,
      @JsonKey(fromJson: _songFromJson)
          ToOne<Song> song,
      @JsonKey(fromJson: _settingsFromJson)
          ToOne<SongLyricSettingsModel> settings,
      @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
          ToMany<Author> authors,
      @JsonKey(fromJson: _tagsFromJson)
          ToMany<Tag> tags,
      @JsonKey(fromJson: _externalsFromJson)
          ToMany<External> externals,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
          ToMany<SongbookRecord> songbookRecords,
      @Backlink()
      @JsonKey(fromJson: _playlistRecordsFromJson)
          ToMany<PlaylistRecord> playlistRecords});
}

/// @nodoc
class _$SongLyricCopyWithImpl<$Res, $Val extends SongLyric>
    implements $SongLyricCopyWith<$Res> {
  _$SongLyricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? secondaryName1 = freezed,
    Object? secondaryName2 = freezed,
    Object? lyrics = freezed,
    Object? lilypond = freezed,
    Object? lang = freezed,
    Object? langDescription = freezed,
    Object? dbType = null,
    Object? hasChords = null,
    Object? accidentals = freezed,
    Object? showChords = freezed,
    Object? transposition = freezed,
    Object? song = null,
    Object? settings = null,
    Object? authors = null,
    Object? tags = null,
    Object? externals = null,
    Object? songbookRecords = null,
    Object? playlistRecords = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryName1: freezed == secondaryName1
          ? _value.secondaryName1
          : secondaryName1 // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryName2: freezed == secondaryName2
          ? _value.secondaryName2
          : secondaryName2 // ignore: cast_nullable_to_non_nullable
              as String?,
      lyrics: freezed == lyrics
          ? _value.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String?,
      lilypond: freezed == lilypond
          ? _value.lilypond
          : lilypond // ignore: cast_nullable_to_non_nullable
              as String?,
      lang: freezed == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
      langDescription: freezed == langDescription
          ? _value.langDescription
          : langDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      dbType: null == dbType
          ? _value.dbType
          : dbType // ignore: cast_nullable_to_non_nullable
              as int,
      hasChords: null == hasChords
          ? _value.hasChords
          : hasChords // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: freezed == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int?,
      showChords: freezed == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool?,
      transposition: freezed == transposition
          ? _value.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int?,
      song: null == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as ToOne<Song>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyricSettingsModel>,
      authors: null == authors
          ? _value.authors
          : authors // ignore: cast_nullable_to_non_nullable
              as ToMany<Author>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as ToMany<Tag>,
      externals: null == externals
          ? _value.externals
          : externals // ignore: cast_nullable_to_non_nullable
              as ToMany<External>,
      songbookRecords: null == songbookRecords
          ? _value.songbookRecords
          : songbookRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<SongbookRecord>,
      playlistRecords: null == playlistRecords
          ? _value.playlistRecords
          : playlistRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<PlaylistRecord>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SongLyricCopyWith<$Res> implements $SongLyricCopyWith<$Res> {
  factory _$$_SongLyricCopyWith(
          _$_SongLyric value, $Res Function(_$_SongLyric) then) =
      __$$_SongLyricCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          int id,
      String name,
      @JsonKey(name: 'secondary_name_1')
          String? secondaryName1,
      @JsonKey(name: 'secondary_name_2')
          String? secondaryName2,
      String? lyrics,
      @JsonKey(name: 'lilypond_svg')
          String? lilypond,
      String? lang,
      @JsonKey(name: 'lang_string')
          String? langDescription,
      @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
          int dbType,
      bool hasChords,
      @Deprecated('is handled independently on model')
          int? accidentals,
      @Deprecated('is handled independently on model')
          bool? showChords,
      @Deprecated('is handled independently on model')
          int? transposition,
      @JsonKey(fromJson: _songFromJson)
          ToOne<Song> song,
      @JsonKey(fromJson: _settingsFromJson)
          ToOne<SongLyricSettingsModel> settings,
      @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
          ToMany<Author> authors,
      @JsonKey(fromJson: _tagsFromJson)
          ToMany<Tag> tags,
      @JsonKey(fromJson: _externalsFromJson)
          ToMany<External> externals,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
          ToMany<SongbookRecord> songbookRecords,
      @Backlink()
      @JsonKey(fromJson: _playlistRecordsFromJson)
          ToMany<PlaylistRecord> playlistRecords});
}

/// @nodoc
class __$$_SongLyricCopyWithImpl<$Res>
    extends _$SongLyricCopyWithImpl<$Res, _$_SongLyric>
    implements _$$_SongLyricCopyWith<$Res> {
  __$$_SongLyricCopyWithImpl(
      _$_SongLyric _value, $Res Function(_$_SongLyric) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? secondaryName1 = freezed,
    Object? secondaryName2 = freezed,
    Object? lyrics = freezed,
    Object? lilypond = freezed,
    Object? lang = freezed,
    Object? langDescription = freezed,
    Object? dbType = null,
    Object? hasChords = null,
    Object? accidentals = freezed,
    Object? showChords = freezed,
    Object? transposition = freezed,
    Object? song = null,
    Object? settings = null,
    Object? authors = null,
    Object? tags = null,
    Object? externals = null,
    Object? songbookRecords = null,
    Object? playlistRecords = null,
  }) {
    return _then(_$_SongLyric(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryName1: freezed == secondaryName1
          ? _value.secondaryName1
          : secondaryName1 // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryName2: freezed == secondaryName2
          ? _value.secondaryName2
          : secondaryName2 // ignore: cast_nullable_to_non_nullable
              as String?,
      lyrics: freezed == lyrics
          ? _value.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String?,
      lilypond: freezed == lilypond
          ? _value.lilypond
          : lilypond // ignore: cast_nullable_to_non_nullable
              as String?,
      lang: freezed == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
      langDescription: freezed == langDescription
          ? _value.langDescription
          : langDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      dbType: null == dbType
          ? _value.dbType
          : dbType // ignore: cast_nullable_to_non_nullable
              as int,
      hasChords: null == hasChords
          ? _value.hasChords
          : hasChords // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: freezed == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int?,
      showChords: freezed == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool?,
      transposition: freezed == transposition
          ? _value.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int?,
      song: null == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as ToOne<Song>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyricSettingsModel>,
      authors: null == authors
          ? _value.authors
          : authors // ignore: cast_nullable_to_non_nullable
              as ToMany<Author>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as ToMany<Tag>,
      externals: null == externals
          ? _value.externals
          : externals // ignore: cast_nullable_to_non_nullable
              as ToMany<External>,
      songbookRecords: null == songbookRecords
          ? _value.songbookRecords
          : songbookRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<SongbookRecord>,
      playlistRecords: null == playlistRecords
          ? _value.playlistRecords
          : playlistRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<PlaylistRecord>,
    ));
  }
}

/// @nodoc

@Entity(realClass: SongLyric)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _$_SongLyric extends _SongLyric {
  const _$_SongLyric(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          required this.id,
      required this.name,
      @JsonKey(name: 'secondary_name_1')
          this.secondaryName1,
      @JsonKey(name: 'secondary_name_2')
          this.secondaryName2,
      this.lyrics,
      @JsonKey(name: 'lilypond_svg')
          this.lilypond,
      this.lang,
      @JsonKey(name: 'lang_string')
          this.langDescription,
      @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
          required this.dbType,
      required this.hasChords,
      @Deprecated('is handled independently on model')
          this.accidentals,
      @Deprecated('is handled independently on model')
          this.showChords,
      @Deprecated('is handled independently on model')
          this.transposition,
      @JsonKey(fromJson: _songFromJson)
          required this.song,
      @JsonKey(fromJson: _settingsFromJson)
          required this.settings,
      @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
          required this.authors,
      @JsonKey(fromJson: _tagsFromJson)
          required this.tags,
      @JsonKey(fromJson: _externalsFromJson)
          required this.externals,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
          required this.songbookRecords,
      @Backlink()
      @JsonKey(fromJson: _playlistRecordsFromJson)
          required this.playlistRecords})
      : super._();

  factory _$_SongLyric.fromJson(Map<String, dynamic> json) =>
      _$$_SongLyricFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'secondary_name_1')
  final String? secondaryName1;
  @override
  @JsonKey(name: 'secondary_name_2')
  final String? secondaryName2;
  @override
  final String? lyrics;
  @override
  @JsonKey(name: 'lilypond_svg')
  final String? lilypond;
  @override
  final String? lang;
  @override
  @JsonKey(name: 'lang_string')
  final String? langDescription;
  @override
  @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
  final int dbType;
  @override
  final bool hasChords;
  @override
  @Deprecated('is handled independently on model')
  final int? accidentals;
  @override
  @Deprecated('is handled independently on model')
  final bool? showChords;
  @override
  @Deprecated('is handled independently on model')
  final int? transposition;
  @override
  @JsonKey(fromJson: _songFromJson)
  final ToOne<Song> song;
  @override
  @JsonKey(fromJson: _settingsFromJson)
  final ToOne<SongLyricSettingsModel> settings;
  @override
  @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
  final ToMany<Author> authors;
  @override
  @JsonKey(fromJson: _tagsFromJson)
  final ToMany<Tag> tags;
  @override
  @JsonKey(fromJson: _externalsFromJson)
  final ToMany<External> externals;
  @override
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  final ToMany<SongbookRecord> songbookRecords;
  @override
  @Backlink()
  @JsonKey(fromJson: _playlistRecordsFromJson)
  final ToMany<PlaylistRecord> playlistRecords;

  @override
  String toString() {
    return 'SongLyric(id: $id, name: $name, secondaryName1: $secondaryName1, secondaryName2: $secondaryName2, lyrics: $lyrics, lilypond: $lilypond, lang: $lang, langDescription: $langDescription, dbType: $dbType, hasChords: $hasChords, accidentals: $accidentals, showChords: $showChords, transposition: $transposition, song: $song, settings: $settings, authors: $authors, tags: $tags, externals: $externals, songbookRecords: $songbookRecords, playlistRecords: $playlistRecords)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SongLyric &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.secondaryName1, secondaryName1) ||
                other.secondaryName1 == secondaryName1) &&
            (identical(other.secondaryName2, secondaryName2) ||
                other.secondaryName2 == secondaryName2) &&
            (identical(other.lyrics, lyrics) || other.lyrics == lyrics) &&
            (identical(other.lilypond, lilypond) ||
                other.lilypond == lilypond) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.langDescription, langDescription) ||
                other.langDescription == langDescription) &&
            (identical(other.dbType, dbType) || other.dbType == dbType) &&
            (identical(other.hasChords, hasChords) ||
                other.hasChords == hasChords) &&
            (identical(other.accidentals, accidentals) ||
                other.accidentals == accidentals) &&
            (identical(other.showChords, showChords) ||
                other.showChords == showChords) &&
            (identical(other.transposition, transposition) ||
                other.transposition == transposition) &&
            (identical(other.song, song) || other.song == song) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            const DeepCollectionEquality().equals(other.authors, authors) &&
            const DeepCollectionEquality().equals(other.tags, tags) &&
            const DeepCollectionEquality().equals(other.externals, externals) &&
            const DeepCollectionEquality()
                .equals(other.songbookRecords, songbookRecords) &&
            const DeepCollectionEquality()
                .equals(other.playlistRecords, playlistRecords));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        secondaryName1,
        secondaryName2,
        lyrics,
        lilypond,
        lang,
        langDescription,
        dbType,
        hasChords,
        accidentals,
        showChords,
        transposition,
        song,
        settings,
        const DeepCollectionEquality().hash(authors),
        const DeepCollectionEquality().hash(tags),
        const DeepCollectionEquality().hash(externals),
        const DeepCollectionEquality().hash(songbookRecords),
        const DeepCollectionEquality().hash(playlistRecords)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SongLyricCopyWith<_$_SongLyric> get copyWith =>
      __$$_SongLyricCopyWithImpl<_$_SongLyric>(this, _$identity);
}

abstract class _SongLyric extends SongLyric {
  const factory _SongLyric(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          required final int id,
      required final String name,
      @JsonKey(name: 'secondary_name_1')
          final String? secondaryName1,
      @JsonKey(name: 'secondary_name_2')
          final String? secondaryName2,
      final String? lyrics,
      @JsonKey(name: 'lilypond_svg')
          final String? lilypond,
      final String? lang,
      @JsonKey(name: 'lang_string')
          final String? langDescription,
      @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
          required final int dbType,
      required final bool hasChords,
      @Deprecated('is handled independently on model')
          final int? accidentals,
      @Deprecated('is handled independently on model')
          final bool? showChords,
      @Deprecated('is handled independently on model')
          final int? transposition,
      @JsonKey(fromJson: _songFromJson)
          required final ToOne<Song> song,
      @JsonKey(fromJson: _settingsFromJson)
          required final ToOne<SongLyricSettingsModel> settings,
      @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
          required final ToMany<Author> authors,
      @JsonKey(fromJson: _tagsFromJson)
          required final ToMany<Tag> tags,
      @JsonKey(fromJson: _externalsFromJson)
          required final ToMany<External> externals,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
          required final ToMany<SongbookRecord> songbookRecords,
      @Backlink()
      @JsonKey(fromJson: _playlistRecordsFromJson)
          required final ToMany<PlaylistRecord>
              playlistRecords}) = _$_SongLyric;
  const _SongLyric._() : super._();

  factory _SongLyric.fromJson(Map<String, dynamic> json) =
      _$_SongLyric.fromJson;

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'secondary_name_1')
  String? get secondaryName1;
  @override
  @JsonKey(name: 'secondary_name_2')
  String? get secondaryName2;
  @override
  String? get lyrics;
  @override
  @JsonKey(name: 'lilypond_svg')
  String? get lilypond;
  @override
  String? get lang;
  @override
  @JsonKey(name: 'lang_string')
  String? get langDescription;
  @override
  @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
  int get dbType;
  @override
  bool get hasChords;
  @override
  @Deprecated('is handled independently on model')
  int? get accidentals;
  @override
  @Deprecated('is handled independently on model')
  bool? get showChords;
  @override
  @Deprecated('is handled independently on model')
  int? get transposition;
  @override
  @JsonKey(fromJson: _songFromJson)
  ToOne<Song> get song;
  @override
  @JsonKey(fromJson: _settingsFromJson)
  ToOne<SongLyricSettingsModel> get settings;
  @override
  @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
  ToMany<Author> get authors;
  @override
  @JsonKey(fromJson: _tagsFromJson)
  ToMany<Tag> get tags;
  @override
  @JsonKey(fromJson: _externalsFromJson)
  ToMany<External> get externals;
  @override
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  ToMany<SongbookRecord> get songbookRecords;
  @override
  @Backlink()
  @JsonKey(fromJson: _playlistRecordsFromJson)
  ToMany<PlaylistRecord> get playlistRecords;
  @override
  @JsonKey(ignore: true)
  _$$_SongLyricCopyWith<_$_SongLyric> get copyWith =>
      throw _privateConstructorUsedError;
}
