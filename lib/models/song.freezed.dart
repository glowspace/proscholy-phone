// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Song _$SongFromJson(Map<String, dynamic> json) {
  return _Song.fromJson(json);
}

/// @nodoc
mixin _$Song {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @Backlink()
  @JsonKey(fromJson: _songLyricsFromJson)
  ToMany<SongLyric> get songLyrics => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongCopyWith<Song> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongCopyWith<$Res> {
  factory $SongCopyWith(Song value, $Res Function(Song) then) =
      _$SongCopyWithImpl<$Res, Song>;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String name,
      @Backlink()
      @JsonKey(fromJson: _songLyricsFromJson)
      ToMany<SongLyric> songLyrics});
}

/// @nodoc
class _$SongCopyWithImpl<$Res, $Val extends Song>
    implements $SongCopyWith<$Res> {
  _$SongCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? songLyrics = null,
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
      songLyrics: null == songLyrics
          ? _value.songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as ToMany<SongLyric>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SongCopyWith<$Res> implements $SongCopyWith<$Res> {
  factory _$$_SongCopyWith(_$_Song value, $Res Function(_$_Song) then) =
      __$$_SongCopyWithImpl<$Res>;
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
class __$$_SongCopyWithImpl<$Res> extends _$SongCopyWithImpl<$Res, _$_Song>
    implements _$$_SongCopyWith<$Res> {
  __$$_SongCopyWithImpl(_$_Song _value, $Res Function(_$_Song) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? songLyrics = null,
  }) {
    return _then(_$_Song(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      songLyrics: null == songLyrics
          ? _value.songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as ToMany<SongLyric>,
    ));
  }
}

/// @nodoc

@Entity(realClass: Song)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _$_Song extends _Song {
  const _$_Song(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      required this.name,
      @Backlink()
      @JsonKey(fromJson: _songLyricsFromJson)
      required this.songLyrics})
      : super._();

  factory _$_Song.fromJson(Map<String, dynamic> json) => _$$_SongFromJson(json);

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

  @override
  String toString() {
    return 'Song(id: $id, name: $name, songLyrics: $songLyrics)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Song &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other.songLyrics, songLyrics));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(songLyrics));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SongCopyWith<_$_Song> get copyWith =>
      __$$_SongCopyWithImpl<_$_Song>(this, _$identity);
}

abstract class _Song extends Song {
  const factory _Song(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
      required final int id,
      required final String name,
      @Backlink()
      @JsonKey(fromJson: _songLyricsFromJson)
      required final ToMany<SongLyric> songLyrics}) = _$_Song;
  const _Song._() : super._();

  factory _Song.fromJson(Map<String, dynamic> json) = _$_Song.fromJson;

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  @override
  String get name;
  @override
  @Backlink()
  @JsonKey(fromJson: _songLyricsFromJson)
  ToMany<SongLyric> get songLyrics;
  @override
  @JsonKey(ignore: true)
  _$$_SongCopyWith<_$_Song> get copyWith => throw _privateConstructorUsedError;
}
