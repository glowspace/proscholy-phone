// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../song_lyric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SongLyric {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  @JsonKey(readValue: _readDisplayId)
  String get displayId;
  String get name;
  @JsonKey(name: 'secondary_name_1')
  String? get secondaryName1;
  @JsonKey(name: 'secondary_name_2')
  String? get secondaryName2;
  String? get lyrics; // uses *New* to migrate conflicts between ZP and EZ
  @JsonKey(name: 'hymnology')
  String get hymnologyNew;
  String get lang;
  @JsonKey(name: 'lang_string')
  String get langDescription;
  @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
  int get dbType;
  bool get hasChords;
  @Deprecated('is handled independently on model')
  int? get accidentals;
  @Deprecated('is handled independently on model')
  bool? get showChords;
  @Deprecated('is handled independently on model')
  int? get transposition;
  @JsonKey(fromJson: _songFromJson)
  ToOne<Song> get song;
  @JsonKey(fromJson: _settingsFromJson)
  ToOne<SongLyricSettingsModel> get settings;
  @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
  ToMany<Author> get authors;
  @JsonKey(fromJson: _tagsFromJson)
  ToMany<Tag> get tags;
  @JsonKey(fromJson: _externalsFromJson)
  ToMany<External> get externals;
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  ToMany<SongbookRecord> get songbookRecords;
  @Backlink()
  @JsonKey(fromJson: _playlistRecordsFromJson)
  ToMany<PlaylistRecord> get playlistRecords;

  /// Create a copy of SongLyric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SongLyricCopyWith<SongLyric> get copyWith =>
      _$SongLyricCopyWithImpl<SongLyric>(this as SongLyric, _$identity);

  @override
  String toString() {
    return 'SongLyric(id: $id, displayId: $displayId, name: $name, secondaryName1: $secondaryName1, secondaryName2: $secondaryName2, lyrics: $lyrics, hymnologyNew: $hymnologyNew, lang: $lang, langDescription: $langDescription, dbType: $dbType, hasChords: $hasChords, accidentals: $accidentals, showChords: $showChords, transposition: $transposition, song: $song, settings: $settings, authors: $authors, tags: $tags, externals: $externals, songbookRecords: $songbookRecords, playlistRecords: $playlistRecords)';
  }
}

/// @nodoc
abstract mixin class $SongLyricCopyWith<$Res> {
  factory $SongLyricCopyWith(SongLyric value, $Res Function(SongLyric) _then) =
      _$SongLyricCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      @JsonKey(readValue: _readDisplayId) String displayId,
      String name,
      @JsonKey(name: 'secondary_name_1') String? secondaryName1,
      @JsonKey(name: 'secondary_name_2') String? secondaryName2,
      String? lyrics,
      @JsonKey(name: 'hymnology') String hymnologyNew,
      String lang,
      @JsonKey(name: 'lang_string') String langDescription,
      @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
      int dbType,
      bool hasChords,
      @Deprecated('is handled independently on model') int? accidentals,
      @Deprecated('is handled independently on model') bool? showChords,
      @Deprecated('is handled independently on model') int? transposition,
      @JsonKey(fromJson: _songFromJson) ToOne<Song> song,
      @JsonKey(fromJson: _settingsFromJson)
      ToOne<SongLyricSettingsModel> settings,
      @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
      ToMany<Author> authors,
      @JsonKey(fromJson: _tagsFromJson) ToMany<Tag> tags,
      @JsonKey(fromJson: _externalsFromJson) ToMany<External> externals,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
      ToMany<SongbookRecord> songbookRecords,
      @Backlink()
      @JsonKey(fromJson: _playlistRecordsFromJson)
      ToMany<PlaylistRecord> playlistRecords});
}

/// @nodoc
class _$SongLyricCopyWithImpl<$Res> implements $SongLyricCopyWith<$Res> {
  _$SongLyricCopyWithImpl(this._self, this._then);

  final SongLyric _self;
  final $Res Function(SongLyric) _then;

  /// Create a copy of SongLyric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayId = null,
    Object? name = null,
    Object? secondaryName1 = freezed,
    Object? secondaryName2 = freezed,
    Object? lyrics = freezed,
    Object? hymnologyNew = null,
    Object? lang = null,
    Object? langDescription = null,
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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      displayId: null == displayId
          ? _self.displayId
          : displayId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryName1: freezed == secondaryName1
          ? _self.secondaryName1
          : secondaryName1 // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryName2: freezed == secondaryName2
          ? _self.secondaryName2
          : secondaryName2 // ignore: cast_nullable_to_non_nullable
              as String?,
      lyrics: freezed == lyrics
          ? _self.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String?,
      hymnologyNew: null == hymnologyNew
          ? _self.hymnologyNew
          : hymnologyNew // ignore: cast_nullable_to_non_nullable
              as String,
      lang: null == lang
          ? _self.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      langDescription: null == langDescription
          ? _self.langDescription
          : langDescription // ignore: cast_nullable_to_non_nullable
              as String,
      dbType: null == dbType
          ? _self.dbType
          : dbType // ignore: cast_nullable_to_non_nullable
              as int,
      hasChords: null == hasChords
          ? _self.hasChords
          : hasChords // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: freezed == accidentals
          ? _self.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int?,
      showChords: freezed == showChords
          ? _self.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool?,
      transposition: freezed == transposition
          ? _self.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int?,
      song: null == song
          ? _self.song
          : song // ignore: cast_nullable_to_non_nullable
              as ToOne<Song>,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyricSettingsModel>,
      authors: null == authors
          ? _self.authors
          : authors // ignore: cast_nullable_to_non_nullable
              as ToMany<Author>,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as ToMany<Tag>,
      externals: null == externals
          ? _self.externals
          : externals // ignore: cast_nullable_to_non_nullable
              as ToMany<External>,
      songbookRecords: null == songbookRecords
          ? _self.songbookRecords
          : songbookRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<SongbookRecord>,
      playlistRecords: null == playlistRecords
          ? _self.playlistRecords
          : playlistRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<PlaylistRecord>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SongLyric].
extension SongLyricPatterns on SongLyric {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SongLyric value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SongLyric() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SongLyric value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongLyric():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SongLyric value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongLyric() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
            @JsonKey(readValue: _readDisplayId) String displayId,
            String name,
            @JsonKey(name: 'secondary_name_1') String? secondaryName1,
            @JsonKey(name: 'secondary_name_2') String? secondaryName2,
            String? lyrics,
            @JsonKey(name: 'hymnology') String hymnologyNew,
            String lang,
            @JsonKey(name: 'lang_string') String langDescription,
            @JsonKey(
                name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
            int dbType,
            bool hasChords,
            @Deprecated('is handled independently on model') int? accidentals,
            @Deprecated('is handled independently on model') bool? showChords,
            @Deprecated('is handled independently on model') int? transposition,
            @JsonKey(fromJson: _songFromJson) ToOne<Song> song,
            @JsonKey(fromJson: _settingsFromJson)
            ToOne<SongLyricSettingsModel> settings,
            @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
            ToMany<Author> authors,
            @JsonKey(fromJson: _tagsFromJson) ToMany<Tag> tags,
            @JsonKey(fromJson: _externalsFromJson) ToMany<External> externals,
            @Backlink()
            @JsonKey(fromJson: _songbookRecordsFromJson)
            ToMany<SongbookRecord> songbookRecords,
            @Backlink()
            @JsonKey(fromJson: _playlistRecordsFromJson)
            ToMany<PlaylistRecord> playlistRecords)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SongLyric() when $default != null:
        return $default(
            _that.id,
            _that.displayId,
            _that.name,
            _that.secondaryName1,
            _that.secondaryName2,
            _that.lyrics,
            _that.hymnologyNew,
            _that.lang,
            _that.langDescription,
            _that.dbType,
            _that.hasChords,
            _that.accidentals,
            _that.showChords,
            _that.transposition,
            _that.song,
            _that.settings,
            _that.authors,
            _that.tags,
            _that.externals,
            _that.songbookRecords,
            _that.playlistRecords);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
            @JsonKey(readValue: _readDisplayId) String displayId,
            String name,
            @JsonKey(name: 'secondary_name_1') String? secondaryName1,
            @JsonKey(name: 'secondary_name_2') String? secondaryName2,
            String? lyrics,
            @JsonKey(name: 'hymnology') String hymnologyNew,
            String lang,
            @JsonKey(name: 'lang_string') String langDescription,
            @JsonKey(
                name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
            int dbType,
            bool hasChords,
            @Deprecated('is handled independently on model') int? accidentals,
            @Deprecated('is handled independently on model') bool? showChords,
            @Deprecated('is handled independently on model') int? transposition,
            @JsonKey(fromJson: _songFromJson) ToOne<Song> song,
            @JsonKey(fromJson: _settingsFromJson)
            ToOne<SongLyricSettingsModel> settings,
            @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
            ToMany<Author> authors,
            @JsonKey(fromJson: _tagsFromJson) ToMany<Tag> tags,
            @JsonKey(fromJson: _externalsFromJson) ToMany<External> externals,
            @Backlink()
            @JsonKey(fromJson: _songbookRecordsFromJson)
            ToMany<SongbookRecord> songbookRecords,
            @Backlink()
            @JsonKey(fromJson: _playlistRecordsFromJson)
            ToMany<PlaylistRecord> playlistRecords)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongLyric():
        return $default(
            _that.id,
            _that.displayId,
            _that.name,
            _that.secondaryName1,
            _that.secondaryName2,
            _that.lyrics,
            _that.hymnologyNew,
            _that.lang,
            _that.langDescription,
            _that.dbType,
            _that.hasChords,
            _that.accidentals,
            _that.showChords,
            _that.transposition,
            _that.song,
            _that.settings,
            _that.authors,
            _that.tags,
            _that.externals,
            _that.songbookRecords,
            _that.playlistRecords);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
            @JsonKey(readValue: _readDisplayId) String displayId,
            String name,
            @JsonKey(name: 'secondary_name_1') String? secondaryName1,
            @JsonKey(name: 'secondary_name_2') String? secondaryName2,
            String? lyrics,
            @JsonKey(name: 'hymnology') String hymnologyNew,
            String lang,
            @JsonKey(name: 'lang_string') String langDescription,
            @JsonKey(
                name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
            int dbType,
            bool hasChords,
            @Deprecated('is handled independently on model') int? accidentals,
            @Deprecated('is handled independently on model') bool? showChords,
            @Deprecated('is handled independently on model') int? transposition,
            @JsonKey(fromJson: _songFromJson) ToOne<Song> song,
            @JsonKey(fromJson: _settingsFromJson)
            ToOne<SongLyricSettingsModel> settings,
            @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
            ToMany<Author> authors,
            @JsonKey(fromJson: _tagsFromJson) ToMany<Tag> tags,
            @JsonKey(fromJson: _externalsFromJson) ToMany<External> externals,
            @Backlink()
            @JsonKey(fromJson: _songbookRecordsFromJson)
            ToMany<SongbookRecord> songbookRecords,
            @Backlink()
            @JsonKey(fromJson: _playlistRecordsFromJson)
            ToMany<PlaylistRecord> playlistRecords)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongLyric() when $default != null:
        return $default(
            _that.id,
            _that.displayId,
            _that.name,
            _that.secondaryName1,
            _that.secondaryName2,
            _that.lyrics,
            _that.hymnologyNew,
            _that.lang,
            _that.langDescription,
            _that.dbType,
            _that.hasChords,
            _that.accidentals,
            _that.showChords,
            _that.transposition,
            _that.song,
            _that.settings,
            _that.authors,
            _that.tags,
            _that.externals,
            _that.songbookRecords,
            _that.playlistRecords);
      case _:
        return null;
    }
  }
}

/// @nodoc

@Entity(realClass: SongLyric)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _SongLyric extends SongLyric {
  const _SongLyric(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      @JsonKey(readValue: _readDisplayId) required this.displayId,
      required this.name,
      @JsonKey(name: 'secondary_name_1') this.secondaryName1,
      @JsonKey(name: 'secondary_name_2') this.secondaryName2,
      this.lyrics,
      @JsonKey(name: 'hymnology') this.hymnologyNew = '',
      required this.lang,
      @JsonKey(name: 'lang_string') required this.langDescription,
      @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
      required this.dbType,
      required this.hasChords,
      @Deprecated('is handled independently on model') this.accidentals,
      @Deprecated('is handled independently on model') this.showChords,
      @Deprecated('is handled independently on model') this.transposition,
      @JsonKey(fromJson: _songFromJson) required this.song,
      @JsonKey(fromJson: _settingsFromJson) required this.settings,
      @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
      required this.authors,
      @JsonKey(fromJson: _tagsFromJson) required this.tags,
      @JsonKey(fromJson: _externalsFromJson) required this.externals,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
      required this.songbookRecords,
      @Backlink()
      @JsonKey(fromJson: _playlistRecordsFromJson)
      required this.playlistRecords})
      : super._();
  factory _SongLyric.fromJson(Map<String, dynamic> json) =>
      _$SongLyricFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  @JsonKey(readValue: _readDisplayId)
  final String displayId;
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
// uses *New* to migrate conflicts between ZP and EZ
  @override
  @JsonKey(name: 'hymnology')
  final String hymnologyNew;
  @override
  final String lang;
  @override
  @JsonKey(name: 'lang_string')
  final String langDescription;
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

  /// Create a copy of SongLyric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SongLyricCopyWith<_SongLyric> get copyWith =>
      __$SongLyricCopyWithImpl<_SongLyric>(this, _$identity);

  @override
  String toString() {
    return 'SongLyric(id: $id, displayId: $displayId, name: $name, secondaryName1: $secondaryName1, secondaryName2: $secondaryName2, lyrics: $lyrics, hymnologyNew: $hymnologyNew, lang: $lang, langDescription: $langDescription, dbType: $dbType, hasChords: $hasChords, accidentals: $accidentals, showChords: $showChords, transposition: $transposition, song: $song, settings: $settings, authors: $authors, tags: $tags, externals: $externals, songbookRecords: $songbookRecords, playlistRecords: $playlistRecords)';
  }
}

/// @nodoc
abstract mixin class _$SongLyricCopyWith<$Res>
    implements $SongLyricCopyWith<$Res> {
  factory _$SongLyricCopyWith(
          _SongLyric value, $Res Function(_SongLyric) _then) =
      __$SongLyricCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      @JsonKey(readValue: _readDisplayId) String displayId,
      String name,
      @JsonKey(name: 'secondary_name_1') String? secondaryName1,
      @JsonKey(name: 'secondary_name_2') String? secondaryName2,
      String? lyrics,
      @JsonKey(name: 'hymnology') String hymnologyNew,
      String lang,
      @JsonKey(name: 'lang_string') String langDescription,
      @JsonKey(name: 'type_enum', fromJson: SongLyricType.rawValueFromString)
      int dbType,
      bool hasChords,
      @Deprecated('is handled independently on model') int? accidentals,
      @Deprecated('is handled independently on model') bool? showChords,
      @Deprecated('is handled independently on model') int? transposition,
      @JsonKey(fromJson: _songFromJson) ToOne<Song> song,
      @JsonKey(fromJson: _settingsFromJson)
      ToOne<SongLyricSettingsModel> settings,
      @JsonKey(name: 'authors_pivot', fromJson: _authorsFromJson)
      ToMany<Author> authors,
      @JsonKey(fromJson: _tagsFromJson) ToMany<Tag> tags,
      @JsonKey(fromJson: _externalsFromJson) ToMany<External> externals,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
      ToMany<SongbookRecord> songbookRecords,
      @Backlink()
      @JsonKey(fromJson: _playlistRecordsFromJson)
      ToMany<PlaylistRecord> playlistRecords});
}

/// @nodoc
class __$SongLyricCopyWithImpl<$Res> implements _$SongLyricCopyWith<$Res> {
  __$SongLyricCopyWithImpl(this._self, this._then);

  final _SongLyric _self;
  final $Res Function(_SongLyric) _then;

  /// Create a copy of SongLyric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? displayId = null,
    Object? name = null,
    Object? secondaryName1 = freezed,
    Object? secondaryName2 = freezed,
    Object? lyrics = freezed,
    Object? hymnologyNew = null,
    Object? lang = null,
    Object? langDescription = null,
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
    return _then(_SongLyric(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      displayId: null == displayId
          ? _self.displayId
          : displayId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryName1: freezed == secondaryName1
          ? _self.secondaryName1
          : secondaryName1 // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryName2: freezed == secondaryName2
          ? _self.secondaryName2
          : secondaryName2 // ignore: cast_nullable_to_non_nullable
              as String?,
      lyrics: freezed == lyrics
          ? _self.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String?,
      hymnologyNew: null == hymnologyNew
          ? _self.hymnologyNew
          : hymnologyNew // ignore: cast_nullable_to_non_nullable
              as String,
      lang: null == lang
          ? _self.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      langDescription: null == langDescription
          ? _self.langDescription
          : langDescription // ignore: cast_nullable_to_non_nullable
              as String,
      dbType: null == dbType
          ? _self.dbType
          : dbType // ignore: cast_nullable_to_non_nullable
              as int,
      hasChords: null == hasChords
          ? _self.hasChords
          : hasChords // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: freezed == accidentals
          ? _self.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int?,
      showChords: freezed == showChords
          ? _self.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool?,
      transposition: freezed == transposition
          ? _self.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int?,
      song: null == song
          ? _self.song
          : song // ignore: cast_nullable_to_non_nullable
              as ToOne<Song>,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyricSettingsModel>,
      authors: null == authors
          ? _self.authors
          : authors // ignore: cast_nullable_to_non_nullable
              as ToMany<Author>,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as ToMany<Tag>,
      externals: null == externals
          ? _self.externals
          : externals // ignore: cast_nullable_to_non_nullable
              as ToMany<External>,
      songbookRecords: null == songbookRecords
          ? _self.songbookRecords
          : songbookRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<SongbookRecord>,
      playlistRecords: null == playlistRecords
          ? _self.playlistRecords
          : playlistRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<PlaylistRecord>,
    ));
  }
}

// dart format on
