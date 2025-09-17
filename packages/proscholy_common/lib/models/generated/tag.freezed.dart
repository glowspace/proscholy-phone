// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

/// Adds pattern-matching-related methods to [Tag].
extension TagPatterns on Tag {
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
    TResult Function(_Tag value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Tag() when $default != null:
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
    TResult Function(_Tag value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Tag():
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
    TResult? Function(_Tag value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Tag() when $default != null:
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
            String name,
            @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString)
            int dbType,
            int songLyricsCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Tag() when $default != null:
        return $default(
            _that.id, _that.name, _that.dbType, _that.songLyricsCount);
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
            String name,
            @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString)
            int dbType,
            int songLyricsCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Tag():
        return $default(
            _that.id, _that.name, _that.dbType, _that.songLyricsCount);
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
            String name,
            @JsonKey(name: 'type_enum', fromJson: TagType.rawValueFromString)
            int dbType,
            int songLyricsCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Tag() when $default != null:
        return $default(
            _that.id, _that.name, _that.dbType, _that.songLyricsCount);
      case _:
        return null;
    }
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
