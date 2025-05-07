// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tag {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  String get name;
  @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString)
  int get dbType;
  int get songLyricsCount;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TagCopyWith<Tag> get copyWith =>
      _$TagCopyWithImpl<Tag>(this as Tag, _$identity);

  @override
  String toString() {
    return 'Tag(id: $id, name: $name, dbType: $dbType, songLyricsCount: $songLyricsCount)';
  }
}

/// @nodoc
abstract mixin class $TagCopyWith<$Res> {
  factory $TagCopyWith(Tag value, $Res Function(Tag) _then) = _$TagCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String name,
      @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString)
      int dbType,
      int songLyricsCount});
}

/// @nodoc
class _$TagCopyWithImpl<$Res> implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._self, this._then);

  final Tag _self;
  final $Res Function(Tag) _then;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dbType = null,
    Object? songLyricsCount = null,
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
      dbType: null == dbType
          ? _self.dbType
          : dbType // ignore: cast_nullable_to_non_nullable
              as int,
      songLyricsCount: null == songLyricsCount
          ? _self.songLyricsCount
          : songLyricsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@Entity(realClass: Tag)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _Tag extends Tag {
  const _Tag(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      required this.name,
      @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString)
      required this.dbType,
      required this.songLyricsCount})
      : super._();
  factory _Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString)
  final int dbType;
  @override
  final int songLyricsCount;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TagCopyWith<_Tag> get copyWith =>
      __$TagCopyWithImpl<_Tag>(this, _$identity);

  @override
  String toString() {
    return 'Tag(id: $id, name: $name, dbType: $dbType, songLyricsCount: $songLyricsCount)';
  }
}

/// @nodoc
abstract mixin class _$TagCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$TagCopyWith(_Tag value, $Res Function(_Tag) _then) =
      __$TagCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String name,
      @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString)
      int dbType,
      int songLyricsCount});
}

/// @nodoc
class __$TagCopyWithImpl<$Res> implements _$TagCopyWith<$Res> {
  __$TagCopyWithImpl(this._self, this._then);

  final _Tag _self;
  final $Res Function(_Tag) _then;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dbType = null,
    Object? songLyricsCount = null,
  }) {
    return _then(_Tag(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dbType: null == dbType
          ? _self.dbType
          : dbType // ignore: cast_nullable_to_non_nullable
              as int,
      songLyricsCount: null == songLyricsCount
          ? _self.songLyricsCount
          : songLyricsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
