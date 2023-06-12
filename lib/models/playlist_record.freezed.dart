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
  ToOne<Playlist> get playlist => throw _privateConstructorUsedError;

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
      ToOne<Playlist> playlist});
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
    Object? playlist = null,
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
      playlist: null == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as ToOne<Playlist>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PlaylistRecordCopyWith<$Res>
    implements $PlaylistRecordCopyWith<$Res> {
  factory _$$_PlaylistRecordCopyWith(
          _$_PlaylistRecord value, $Res Function(_$_PlaylistRecord) then) =
      __$$_PlaylistRecordCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      int rank,
      ToOne<SongLyric> songLyric,
      ToOne<Playlist> playlist});
}

/// @nodoc
class __$$_PlaylistRecordCopyWithImpl<$Res>
    extends _$PlaylistRecordCopyWithImpl<$Res, _$_PlaylistRecord>
    implements _$$_PlaylistRecordCopyWith<$Res> {
  __$$_PlaylistRecordCopyWithImpl(
      _$_PlaylistRecord _value, $Res Function(_$_PlaylistRecord) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rank = null,
    Object? songLyric = null,
    Object? playlist = null,
  }) {
    return _then(_$_PlaylistRecord(
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
      playlist: null == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as ToOne<Playlist>,
    ));
  }
}

/// @nodoc

@Entity(realClass: PlaylistRecord)
class _$_PlaylistRecord extends _PlaylistRecord {
  const _$_PlaylistRecord(
      {@Id(assignable: true) required this.id,
      required this.rank,
      required this.songLyric,
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
  final ToOne<Playlist> playlist;

  @override
  String toString() {
    return 'PlaylistRecord(id: $id, rank: $rank, songLyric: $songLyric, playlist: $playlist)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlaylistRecord &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.songLyric, songLyric) ||
                other.songLyric == songLyric) &&
            (identical(other.playlist, playlist) ||
                other.playlist == playlist));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, rank, songLyric, playlist);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlaylistRecordCopyWith<_$_PlaylistRecord> get copyWith =>
      __$$_PlaylistRecordCopyWithImpl<_$_PlaylistRecord>(this, _$identity);
}

abstract class _PlaylistRecord extends PlaylistRecord {
  const factory _PlaylistRecord(
      {@Id(assignable: true) required final int id,
      required final int rank,
      required final ToOne<SongLyric> songLyric,
      required final ToOne<Playlist> playlist}) = _$_PlaylistRecord;
  const _PlaylistRecord._() : super._();

  @override
  @Id(assignable: true)
  int get id;
  @override
  int get rank;
  @override
  ToOne<SongLyric> get songLyric;
  @override
  ToOne<Playlist> get playlist;
  @override
  @JsonKey(ignore: true)
  _$$_PlaylistRecordCopyWith<_$_PlaylistRecord> get copyWith =>
      throw _privateConstructorUsedError;
}
