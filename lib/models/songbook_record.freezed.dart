// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'songbook_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SongbookRecord _$SongbookRecordFromJson(Map<String, dynamic> json) {
  return _SongbookRecord.fromJson(json);
}

/// @nodoc
mixin _$SongbookRecord {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id => throw _privateConstructorUsedError;
  String get number => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _songLyricFromJson)
  ToOne<SongLyric> get songLyric => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _songbookFromJson)
  ToOne<Songbook> get songbook => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongbookRecordCopyWith<SongbookRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongbookRecordCopyWith<$Res> {
  factory $SongbookRecordCopyWith(
          SongbookRecord value, $Res Function(SongbookRecord) then) =
      _$SongbookRecordCopyWithImpl<$Res, SongbookRecord>;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String number,
      @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric,
      @JsonKey(fromJson: _songbookFromJson) ToOne<Songbook> songbook});
}

/// @nodoc
class _$SongbookRecordCopyWithImpl<$Res, $Val extends SongbookRecord>
    implements $SongbookRecordCopyWith<$Res> {
  _$SongbookRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? songLyric = null,
    Object? songbook = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      songLyric: null == songLyric
          ? _value.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
      songbook: null == songbook
          ? _value.songbook
          : songbook // ignore: cast_nullable_to_non_nullable
              as ToOne<Songbook>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongbookRecordImplCopyWith<$Res>
    implements $SongbookRecordCopyWith<$Res> {
  factory _$$SongbookRecordImplCopyWith(_$SongbookRecordImpl value,
          $Res Function(_$SongbookRecordImpl) then) =
      __$$SongbookRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String number,
      @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric,
      @JsonKey(fromJson: _songbookFromJson) ToOne<Songbook> songbook});
}

/// @nodoc
class __$$SongbookRecordImplCopyWithImpl<$Res>
    extends _$SongbookRecordCopyWithImpl<$Res, _$SongbookRecordImpl>
    implements _$$SongbookRecordImplCopyWith<$Res> {
  __$$SongbookRecordImplCopyWithImpl(
      _$SongbookRecordImpl _value, $Res Function(_$SongbookRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? songLyric = null,
    Object? songbook = null,
  }) {
    return _then(_$SongbookRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      songLyric: null == songLyric
          ? _value.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
      songbook: null == songbook
          ? _value.songbook
          : songbook // ignore: cast_nullable_to_non_nullable
              as ToOne<Songbook>,
    ));
  }
}

/// @nodoc

@Entity(realClass: SongbookRecord)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _$SongbookRecordImpl extends _SongbookRecord {
  const _$SongbookRecordImpl(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      required this.number,
      @JsonKey(fromJson: _songLyricFromJson) required this.songLyric,
      @JsonKey(fromJson: _songbookFromJson) required this.songbook})
      : super._();

  factory _$SongbookRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongbookRecordImplFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String number;
  @override
  @JsonKey(fromJson: _songLyricFromJson)
  final ToOne<SongLyric> songLyric;
  @override
  @JsonKey(fromJson: _songbookFromJson)
  final ToOne<Songbook> songbook;

  @override
  String toString() {
    return 'SongbookRecord(id: $id, number: $number, songLyric: $songLyric, songbook: $songbook)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongbookRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.songLyric, songLyric) ||
                other.songLyric == songLyric) &&
            (identical(other.songbook, songbook) ||
                other.songbook == songbook));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, number, songLyric, songbook);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongbookRecordImplCopyWith<_$SongbookRecordImpl> get copyWith =>
      __$$SongbookRecordImplCopyWithImpl<_$SongbookRecordImpl>(
          this, _$identity);
}

abstract class _SongbookRecord extends SongbookRecord {
  const factory _SongbookRecord(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
      required final int id,
      required final String number,
      @JsonKey(fromJson: _songLyricFromJson)
      required final ToOne<SongLyric> songLyric,
      @JsonKey(fromJson: _songbookFromJson)
      required final ToOne<Songbook> songbook}) = _$SongbookRecordImpl;
  const _SongbookRecord._() : super._();

  factory _SongbookRecord.fromJson(Map<String, dynamic> json) =
      _$SongbookRecordImpl.fromJson;

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  @override
  String get number;
  @override
  @JsonKey(fromJson: _songLyricFromJson)
  ToOne<SongLyric> get songLyric;
  @override
  @JsonKey(fromJson: _songbookFromJson)
  ToOne<Songbook> get songbook;
  @override
  @JsonKey(ignore: true)
  _$$SongbookRecordImplCopyWith<_$SongbookRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
