// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../playlist_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaylistRecord {
  @Id(assignable: true)
  int get id;
  int get rank;
  ToOne<SongLyric> get songLyric;
  ToOne<CustomText> get customText;
  ToOne<BibleVerse> get bibleVerse;
  ToOne<Playlist> get playlist;

  /// Create a copy of PlaylistRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlaylistRecordCopyWith<PlaylistRecord> get copyWith =>
      _$PlaylistRecordCopyWithImpl<PlaylistRecord>(
          this as PlaylistRecord, _$identity);

  @override
  String toString() {
    return 'PlaylistRecord(id: $id, rank: $rank, songLyric: $songLyric, customText: $customText, bibleVerse: $bibleVerse, playlist: $playlist)';
  }
}

/// @nodoc
abstract mixin class $PlaylistRecordCopyWith<$Res> {
  factory $PlaylistRecordCopyWith(
          PlaylistRecord value, $Res Function(PlaylistRecord) _then) =
      _$PlaylistRecordCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      int rank,
      ToOne<SongLyric> songLyric,
      ToOne<CustomText> customText,
      ToOne<BibleVerse> bibleVerse,
      ToOne<Playlist> playlist});
}

/// @nodoc
class _$PlaylistRecordCopyWithImpl<$Res>
    implements $PlaylistRecordCopyWith<$Res> {
  _$PlaylistRecordCopyWithImpl(this._self, this._then);

  final PlaylistRecord _self;
  final $Res Function(PlaylistRecord) _then;

  /// Create a copy of PlaylistRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rank = null,
    Object? songLyric = null,
    Object? customText = null,
    Object? bibleVerse = null,
    Object? playlist = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _self.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
      customText: null == customText
          ? _self.customText
          : customText // ignore: cast_nullable_to_non_nullable
              as ToOne<CustomText>,
      bibleVerse: null == bibleVerse
          ? _self.bibleVerse
          : bibleVerse // ignore: cast_nullable_to_non_nullable
              as ToOne<BibleVerse>,
      playlist: null == playlist
          ? _self.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as ToOne<Playlist>,
    ));
  }
}

/// @nodoc

@Entity(realClass: PlaylistRecord)
class _PlaylistRecord extends PlaylistRecord {
  const _PlaylistRecord(
      {@Id(assignable: true) required this.id,
      required this.rank,
      required this.songLyric,
      required this.customText,
      required this.bibleVerse,
      required this.playlist})
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

  /// Create a copy of PlaylistRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlaylistRecordCopyWith<_PlaylistRecord> get copyWith =>
      __$PlaylistRecordCopyWithImpl<_PlaylistRecord>(this, _$identity);

  @override
  String toString() {
    return 'PlaylistRecord(id: $id, rank: $rank, songLyric: $songLyric, customText: $customText, bibleVerse: $bibleVerse, playlist: $playlist)';
  }
}

/// @nodoc
abstract mixin class _$PlaylistRecordCopyWith<$Res>
    implements $PlaylistRecordCopyWith<$Res> {
  factory _$PlaylistRecordCopyWith(
          _PlaylistRecord value, $Res Function(_PlaylistRecord) _then) =
      __$PlaylistRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      int rank,
      ToOne<SongLyric> songLyric,
      ToOne<CustomText> customText,
      ToOne<BibleVerse> bibleVerse,
      ToOne<Playlist> playlist});
}

/// @nodoc
class __$PlaylistRecordCopyWithImpl<$Res>
    implements _$PlaylistRecordCopyWith<$Res> {
  __$PlaylistRecordCopyWithImpl(this._self, this._then);

  final _PlaylistRecord _self;
  final $Res Function(_PlaylistRecord) _then;

  /// Create a copy of PlaylistRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? rank = null,
    Object? songLyric = null,
    Object? customText = null,
    Object? bibleVerse = null,
    Object? playlist = null,
  }) {
    return _then(_PlaylistRecord(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _self.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
      customText: null == customText
          ? _self.customText
          : customText // ignore: cast_nullable_to_non_nullable
              as ToOne<CustomText>,
      bibleVerse: null == bibleVerse
          ? _self.bibleVerse
          : bibleVerse // ignore: cast_nullable_to_non_nullable
              as ToOne<BibleVerse>,
      playlist: null == playlist
          ? _self.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as ToOne<Playlist>,
    ));
  }
}

// dart format on
