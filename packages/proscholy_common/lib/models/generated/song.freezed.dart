// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../song.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Song {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  String get name;
  @Backlink()
  @JsonKey(fromJson: _songLyricsFromJson)
  ToMany<SongLyric> get songLyrics;

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SongCopyWith<Song> get copyWith =>
      _$SongCopyWithImpl<Song>(this as Song, _$identity);

  @override
  String toString() {
    return 'Song(id: $id, name: $name, songLyrics: $songLyrics)';
  }
}

/// @nodoc
abstract mixin class $SongCopyWith<$Res> {
  factory $SongCopyWith(Song value, $Res Function(Song) _then) =
      _$SongCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String name,
      @Backlink()
      @JsonKey(fromJson: _songLyricsFromJson)
      ToMany<SongLyric> songLyrics});
}

/// @nodoc
class _$SongCopyWithImpl<$Res> implements $SongCopyWith<$Res> {
  _$SongCopyWithImpl(this._self, this._then);

  final Song _self;
  final $Res Function(Song) _then;

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? songLyrics = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      songLyrics: null == songLyrics
          ? _self.songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as ToMany<SongLyric>,
    ));
  }
}

/// @nodoc

@Entity(realClass: Song)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _Song extends Song {
  const _Song(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      required this.name,
      @Backlink()
      @JsonKey(fromJson: _songLyricsFromJson)
      required this.songLyrics})
      : super._();
  factory _Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String name;
  @override
  @Backlink()
  @JsonKey(fromJson: _songLyricsFromJson)
  final ToMany<SongLyric> songLyrics;

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SongCopyWith<_Song> get copyWith =>
      __$SongCopyWithImpl<_Song>(this, _$identity);

  @override
  String toString() {
    return 'Song(id: $id, name: $name, songLyrics: $songLyrics)';
  }
}

/// @nodoc
abstract mixin class _$SongCopyWith<$Res> implements $SongCopyWith<$Res> {
  factory _$SongCopyWith(_Song value, $Res Function(_Song) _then) =
      __$SongCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String name,
      @Backlink()
      @JsonKey(fromJson: _songLyricsFromJson)
      ToMany<SongLyric> songLyrics});
}

/// @nodoc
class __$SongCopyWithImpl<$Res> implements _$SongCopyWith<$Res> {
  __$SongCopyWithImpl(this._self, this._then);

  final _Song _self;
  final $Res Function(_Song) _then;

  /// Create a copy of Song
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? songLyrics = null,
  }) {
    return _then(_Song(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      songLyrics: null == songLyrics
          ? _self.songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as ToMany<SongLyric>,
    ));
  }
}

// dart format on
