// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../songbook_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SongbookRecord {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  String get number;
  @JsonKey(fromJson: _songLyricFromJson)
  ToOne<SongLyric> get songLyric;
  @JsonKey(fromJson: _songbookFromJson)
  ToOne<Songbook> get songbook;

  /// Create a copy of SongbookRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SongbookRecordCopyWith<SongbookRecord> get copyWith =>
      _$SongbookRecordCopyWithImpl<SongbookRecord>(
          this as SongbookRecord, _$identity);

  @override
  String toString() {
    return 'SongbookRecord(id: $id, number: $number, songLyric: $songLyric, songbook: $songbook)';
  }
}

/// @nodoc
abstract mixin class $SongbookRecordCopyWith<$Res> {
  factory $SongbookRecordCopyWith(
          SongbookRecord value, $Res Function(SongbookRecord) _then) =
      _$SongbookRecordCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String number,
      @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric,
      @JsonKey(fromJson: _songbookFromJson) ToOne<Songbook> songbook});
}

/// @nodoc
class _$SongbookRecordCopyWithImpl<$Res>
    implements $SongbookRecordCopyWith<$Res> {
  _$SongbookRecordCopyWithImpl(this._self, this._then);

  final SongbookRecord _self;
  final $Res Function(SongbookRecord) _then;

  /// Create a copy of SongbookRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? songLyric = null,
    Object? songbook = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      number: null == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      songLyric: null == songLyric
          ? _self.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
      songbook: null == songbook
          ? _self.songbook
          : songbook // ignore: cast_nullable_to_non_nullable
              as ToOne<Songbook>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SongbookRecord].
extension SongbookRecordPatterns on SongbookRecord {
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
    TResult Function(_SongbookRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SongbookRecord() when $default != null:
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
    TResult Function(_SongbookRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongbookRecord():
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
    TResult? Function(_SongbookRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongbookRecord() when $default != null:
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
            String number,
            @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric,
            @JsonKey(fromJson: _songbookFromJson) ToOne<Songbook> songbook)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SongbookRecord() when $default != null:
        return $default(
            _that.id, _that.number, _that.songLyric, _that.songbook);
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
            String number,
            @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric,
            @JsonKey(fromJson: _songbookFromJson) ToOne<Songbook> songbook)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongbookRecord():
        return $default(
            _that.id, _that.number, _that.songLyric, _that.songbook);
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
            String number,
            @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric,
            @JsonKey(fromJson: _songbookFromJson) ToOne<Songbook> songbook)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongbookRecord() when $default != null:
        return $default(
            _that.id, _that.number, _that.songLyric, _that.songbook);
      case _:
        return null;
    }
  }
}

/// @nodoc

@Entity(realClass: SongbookRecord)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _SongbookRecord extends SongbookRecord {
  const _SongbookRecord(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      required this.number,
      @JsonKey(fromJson: _songLyricFromJson) required this.songLyric,
      @JsonKey(fromJson: _songbookFromJson) required this.songbook})
      : super._();
  factory _SongbookRecord.fromJson(Map<String, dynamic> json) =>
      _$SongbookRecordFromJson(json);

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

  /// Create a copy of SongbookRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SongbookRecordCopyWith<_SongbookRecord> get copyWith =>
      __$SongbookRecordCopyWithImpl<_SongbookRecord>(this, _$identity);

  @override
  String toString() {
    return 'SongbookRecord(id: $id, number: $number, songLyric: $songLyric, songbook: $songbook)';
  }
}

/// @nodoc
abstract mixin class _$SongbookRecordCopyWith<$Res>
    implements $SongbookRecordCopyWith<$Res> {
  factory _$SongbookRecordCopyWith(
          _SongbookRecord value, $Res Function(_SongbookRecord) _then) =
      __$SongbookRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String number,
      @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric,
      @JsonKey(fromJson: _songbookFromJson) ToOne<Songbook> songbook});
}

/// @nodoc
class __$SongbookRecordCopyWithImpl<$Res>
    implements _$SongbookRecordCopyWith<$Res> {
  __$SongbookRecordCopyWithImpl(this._self, this._then);

  final _SongbookRecord _self;
  final $Res Function(_SongbookRecord) _then;

  /// Create a copy of SongbookRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? songLyric = null,
    Object? songbook = null,
  }) {
    return _then(_SongbookRecord(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      number: null == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      songLyric: null == songLyric
          ? _self.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
      songbook: null == songbook
          ? _self.songbook
          : songbook // ignore: cast_nullable_to_non_nullable
              as ToOne<Songbook>,
    ));
  }
}

// dart format on
