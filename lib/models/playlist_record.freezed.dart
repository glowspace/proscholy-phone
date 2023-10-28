// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlaylistRecord {
  @Id(assignable: true)
  int get id => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  ToOne<SongLyric> get songLyric => throw _privateConstructorUsedError;
  ToOne<CustomText> get customText => throw _privateConstructorUsedError;
  ToOne<BibleVerse> get bibleVerse => throw _privateConstructorUsedError;
  ToOne<Playlist> get playlist => throw _privateConstructorUsedError;
  ToOne<SongLyricSettingsModel> get settings =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaylistRecordCopyWith<PlaylistRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaylistRecordCopyWith<$Res> {
  factory $PlaylistRecordCopyWith(
          PlaylistRecord value, $Res Function(PlaylistRecord) then) =
      _$PlaylistRecordCopyWithImpl<$Res, PlaylistRecord>;
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      int rank,
      ToOne<SongLyric> songLyric,
      ToOne<CustomText> customText,
      ToOne<BibleVerse> bibleVerse,
      ToOne<Playlist> playlist,
      ToOne<SongLyricSettingsModel> settings});
}

/// @nodoc
class _$PlaylistRecordCopyWithImpl<$Res, $Val extends PlaylistRecord>
    implements $PlaylistRecordCopyWith<$Res> {
  _$PlaylistRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rank = null,
    Object? songLyric = null,
    Object? customText = null,
    Object? bibleVerse = null,
    Object? playlist = null,
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _value.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
      customText: null == customText
          ? _value.customText
          : customText // ignore: cast_nullable_to_non_nullable
              as ToOne<CustomText>,
      bibleVerse: null == bibleVerse
          ? _value.bibleVerse
          : bibleVerse // ignore: cast_nullable_to_non_nullable
              as ToOne<BibleVerse>,
      playlist: null == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as ToOne<Playlist>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyricSettingsModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaylistRecordImplCopyWith<$Res>
    implements $PlaylistRecordCopyWith<$Res> {
  factory _$$PlaylistRecordImplCopyWith(_$PlaylistRecordImpl value,
          $Res Function(_$PlaylistRecordImpl) then) =
      __$$PlaylistRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      int rank,
      ToOne<SongLyric> songLyric,
      ToOne<CustomText> customText,
      ToOne<BibleVerse> bibleVerse,
      ToOne<Playlist> playlist,
      ToOne<SongLyricSettingsModel> settings});
}

/// @nodoc
class __$$PlaylistRecordImplCopyWithImpl<$Res>
    extends _$PlaylistRecordCopyWithImpl<$Res, _$PlaylistRecordImpl>
    implements _$$PlaylistRecordImplCopyWith<$Res> {
  __$$PlaylistRecordImplCopyWithImpl(
      _$PlaylistRecordImpl _value, $Res Function(_$PlaylistRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rank = null,
    Object? songLyric = null,
    Object? customText = null,
    Object? bibleVerse = null,
    Object? playlist = null,
    Object? settings = null,
  }) {
    return _then(_$PlaylistRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _value.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
      customText: null == customText
          ? _value.customText
          : customText // ignore: cast_nullable_to_non_nullable
              as ToOne<CustomText>,
      bibleVerse: null == bibleVerse
          ? _value.bibleVerse
          : bibleVerse // ignore: cast_nullable_to_non_nullable
              as ToOne<BibleVerse>,
      playlist: null == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as ToOne<Playlist>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyricSettingsModel>,
    ));
  }
}

/// @nodoc

@Entity(realClass: PlaylistRecord)
class _$PlaylistRecordImpl extends _PlaylistRecord {
  const _$PlaylistRecordImpl(
      {@Id(assignable: true) required this.id,
      required this.rank,
      required this.songLyric,
      required this.customText,
      required this.bibleVerse,
      required this.playlist,
      required this.settings})
      : super._();

  @override
  @Id(assignable: true)
  final int id;
  @override
  final int rank;
  @override
  final ToOne<SongLyric> songLyric;
  @override
  final ToOne<CustomText> customText;
  @override
  final ToOne<BibleVerse> bibleVerse;
  @override
  final ToOne<Playlist> playlist;
  @override
  final ToOne<SongLyricSettingsModel> settings;

  @override
  String toString() {
    return 'PlaylistRecord(id: $id, rank: $rank, songLyric: $songLyric, customText: $customText, bibleVerse: $bibleVerse, playlist: $playlist, settings: $settings)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaylistRecordImplCopyWith<_$PlaylistRecordImpl> get copyWith =>
      __$$PlaylistRecordImplCopyWithImpl<_$PlaylistRecordImpl>(
          this, _$identity);
}

abstract class _PlaylistRecord extends PlaylistRecord {
  const factory _PlaylistRecord(
          {@Id(assignable: true) required final int id,
          required final int rank,
          required final ToOne<SongLyric> songLyric,
          required final ToOne<CustomText> customText,
          required final ToOne<BibleVerse> bibleVerse,
          required final ToOne<Playlist> playlist,
          required final ToOne<SongLyricSettingsModel> settings}) =
      _$PlaylistRecordImpl;
  const _PlaylistRecord._() : super._();

  @override
  @Id(assignable: true)
  int get id;
  @override
  int get rank;
  @override
  ToOne<SongLyric> get songLyric;
  @override
  ToOne<CustomText> get customText;
  @override
  ToOne<BibleVerse> get bibleVerse;
  @override
  ToOne<Playlist> get playlist;
  @override
  ToOne<SongLyricSettingsModel> get settings;
  @override
  @JsonKey(ignore: true)
  _$$PlaylistRecordImplCopyWith<_$PlaylistRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
