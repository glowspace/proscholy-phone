// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../songbook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Songbook {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  String get name;
  @JsonKey(defaultValue: '')
  String get shortcut;
  String? get color;
  String? get colorText;
  bool get isPrivate;
  @Deprecated('is handled independently on model')
  bool? get isPinned;
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  ToMany<SongbookRecord> get records;

  /// Create a copy of Songbook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SongbookCopyWith<Songbook> get copyWith =>
      _$SongbookCopyWithImpl<Songbook>(this as Songbook, _$identity);

  @override
  String toString() {
    return 'Songbook(id: $id, name: $name, shortcut: $shortcut, color: $color, colorText: $colorText, isPrivate: $isPrivate, isPinned: $isPinned, records: $records)';
  }
}

/// @nodoc
abstract mixin class $SongbookCopyWith<$Res> {
  factory $SongbookCopyWith(Songbook value, $Res Function(Songbook) _then) =
      _$SongbookCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String name,
      @JsonKey(defaultValue: '') String shortcut,
      String? color,
      String? colorText,
      bool isPrivate,
      @Deprecated('is handled independently on model') bool? isPinned,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
      ToMany<SongbookRecord> records});
}

/// @nodoc
class _$SongbookCopyWithImpl<$Res> implements $SongbookCopyWith<$Res> {
  _$SongbookCopyWithImpl(this._self, this._then);

  final Songbook _self;
  final $Res Function(Songbook) _then;

  /// Create a copy of Songbook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortcut = null,
    Object? color = freezed,
    Object? colorText = freezed,
    Object? isPrivate = null,
    Object? isPinned = freezed,
    Object? records = null,
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
      shortcut: null == shortcut
          ? _self.shortcut
          : shortcut // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      colorText: freezed == colorText
          ? _self.colorText
          : colorText // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrivate: null == isPrivate
          ? _self.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: freezed == isPinned
          ? _self.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool?,
      records: null == records
          ? _self.records
          : records // ignore: cast_nullable_to_non_nullable
              as ToMany<SongbookRecord>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Songbook].
extension SongbookPatterns on Songbook {
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
    TResult Function(_Songbook value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Songbook() when $default != null:
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
    TResult Function(_Songbook value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Songbook():
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
    TResult? Function(_Songbook value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Songbook() when $default != null:
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
            @JsonKey(defaultValue: '') String shortcut,
            String? color,
            String? colorText,
            bool isPrivate,
            @Deprecated('is handled independently on model') bool? isPinned,
            @Backlink()
            @JsonKey(fromJson: _songbookRecordsFromJson)
            ToMany<SongbookRecord> records)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Songbook() when $default != null:
        return $default(_that.id, _that.name, _that.shortcut, _that.color,
            _that.colorText, _that.isPrivate, _that.isPinned, _that.records);
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
            @JsonKey(defaultValue: '') String shortcut,
            String? color,
            String? colorText,
            bool isPrivate,
            @Deprecated('is handled independently on model') bool? isPinned,
            @Backlink()
            @JsonKey(fromJson: _songbookRecordsFromJson)
            ToMany<SongbookRecord> records)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Songbook():
        return $default(_that.id, _that.name, _that.shortcut, _that.color,
            _that.colorText, _that.isPrivate, _that.isPinned, _that.records);
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
            @JsonKey(defaultValue: '') String shortcut,
            String? color,
            String? colorText,
            bool isPrivate,
            @Deprecated('is handled independently on model') bool? isPinned,
            @Backlink()
            @JsonKey(fromJson: _songbookRecordsFromJson)
            ToMany<SongbookRecord> records)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Songbook() when $default != null:
        return $default(_that.id, _that.name, _that.shortcut, _that.color,
            _that.colorText, _that.isPrivate, _that.isPinned, _that.records);
      case _:
        return null;
    }
  }
}

/// @nodoc

@Entity(realClass: Songbook)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _Songbook extends Songbook {
  const _Songbook(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      required this.name,
      @JsonKey(defaultValue: '') required this.shortcut,
      this.color,
      this.colorText,
      required this.isPrivate,
      @Deprecated('is handled independently on model') this.isPinned,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
      required this.records})
      : super._();
  factory _Songbook.fromJson(Map<String, dynamic> json) =>
      _$SongbookFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String name;
  @override
  @JsonKey(defaultValue: '')
  final String shortcut;
  @override
  final String? color;
  @override
  final String? colorText;
  @override
  final bool isPrivate;
  @override
  @Deprecated('is handled independently on model')
  final bool? isPinned;
  @override
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  final ToMany<SongbookRecord> records;

  /// Create a copy of Songbook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SongbookCopyWith<_Songbook> get copyWith =>
      __$SongbookCopyWithImpl<_Songbook>(this, _$identity);

  @override
  String toString() {
    return 'Songbook(id: $id, name: $name, shortcut: $shortcut, color: $color, colorText: $colorText, isPrivate: $isPrivate, isPinned: $isPinned, records: $records)';
  }
}

/// @nodoc
abstract mixin class _$SongbookCopyWith<$Res>
    implements $SongbookCopyWith<$Res> {
  factory _$SongbookCopyWith(_Songbook value, $Res Function(_Songbook) _then) =
      __$SongbookCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String name,
      @JsonKey(defaultValue: '') String shortcut,
      String? color,
      String? colorText,
      bool isPrivate,
      @Deprecated('is handled independently on model') bool? isPinned,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
      ToMany<SongbookRecord> records});
}

/// @nodoc
class __$SongbookCopyWithImpl<$Res> implements _$SongbookCopyWith<$Res> {
  __$SongbookCopyWithImpl(this._self, this._then);

  final _Songbook _self;
  final $Res Function(_Songbook) _then;

  /// Create a copy of Songbook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortcut = null,
    Object? color = freezed,
    Object? colorText = freezed,
    Object? isPrivate = null,
    Object? isPinned = freezed,
    Object? records = null,
  }) {
    return _then(_Songbook(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortcut: null == shortcut
          ? _self.shortcut
          : shortcut // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      colorText: freezed == colorText
          ? _self.colorText
          : colorText // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrivate: null == isPrivate
          ? _self.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: freezed == isPinned
          ? _self.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool?,
      records: null == records
          ? _self.records
          : records // ignore: cast_nullable_to_non_nullable
              as ToMany<SongbookRecord>,
    ));
  }
}

// dart format on
