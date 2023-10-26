// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Playlist {
  @Id(assignable: true)
  int get id => throw _privateConstructorUsedError;
  @Unique(onConflict: ConflictStrategy.fail)
  String get name => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  @Backlink()
  ToMany<PlaylistRecord> get records => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaylistCopyWith<Playlist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaylistCopyWith<$Res> {
  factory $PlaylistCopyWith(Playlist value, $Res Function(Playlist) then) =
      _$PlaylistCopyWithImpl<$Res, Playlist>;
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      @Unique(onConflict: ConflictStrategy.fail) String name,
      int rank,
      @Backlink() ToMany<PlaylistRecord> records});
}

/// @nodoc
class _$PlaylistCopyWithImpl<$Res, $Val extends Playlist>
    implements $PlaylistCopyWith<$Res> {
  _$PlaylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rank = null,
    Object? records = null,
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
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      records: null == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as ToMany<PlaylistRecord>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaylistImplCopyWith<$Res>
    implements $PlaylistCopyWith<$Res> {
  factory _$$PlaylistImplCopyWith(
          _$PlaylistImpl value, $Res Function(_$PlaylistImpl) then) =
      __$$PlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      @Unique(onConflict: ConflictStrategy.fail) String name,
      int rank,
      @Backlink() ToMany<PlaylistRecord> records});
}

/// @nodoc
class __$$PlaylistImplCopyWithImpl<$Res>
    extends _$PlaylistCopyWithImpl<$Res, _$PlaylistImpl>
    implements _$$PlaylistImplCopyWith<$Res> {
  __$$PlaylistImplCopyWithImpl(
      _$PlaylistImpl _value, $Res Function(_$PlaylistImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rank = null,
    Object? records = null,
  }) {
    return _then(_$PlaylistImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      records: null == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as ToMany<PlaylistRecord>,
    ));
  }
}

/// @nodoc

@Entity(realClass: Playlist)
class _$PlaylistImpl extends _Playlist {
  const _$PlaylistImpl(
      {@Id(assignable: true) required this.id,
      @Unique(onConflict: ConflictStrategy.fail) required this.name,
      required this.rank,
      @Backlink() required this.records})
      : super._();

  @override
  @Id(assignable: true)
  final int id;
  @override
  @Unique(onConflict: ConflictStrategy.fail)
  final String name;
  @override
  final int rank;
  @override
  @Backlink()
  final ToMany<PlaylistRecord> records;

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, rank: $rank, records: $records)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaylistImplCopyWith<_$PlaylistImpl> get copyWith =>
      __$$PlaylistImplCopyWithImpl<_$PlaylistImpl>(this, _$identity);
}

abstract class _Playlist extends Playlist {
  const factory _Playlist(
          {@Id(assignable: true) required final int id,
          @Unique(onConflict: ConflictStrategy.fail) required final String name,
          required final int rank,
          @Backlink() required final ToMany<PlaylistRecord> records}) =
      _$PlaylistImpl;
  const _Playlist._() : super._();

  @override
  @Id(assignable: true)
  int get id;
  @override
  @Unique(onConflict: ConflictStrategy.fail)
  String get name;
  @override
  int get rank;
  @override
  @Backlink()
  ToMany<PlaylistRecord> get records;
  @override
  @JsonKey(ignore: true)
  _$$PlaylistImplCopyWith<_$PlaylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
