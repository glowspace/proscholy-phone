// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../external.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$External {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  String get publicName;
  String? get mediaId;
  String? get url;
  @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
  int get dbMediaType;
  @JsonKey(fromJson: _songLyricFromJson)
  ToOne<SongLyric> get songLyric;

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExternalCopyWith<External> get copyWith =>
      _$ExternalCopyWithImpl<External>(this as External, _$identity);

  @override
  String toString() {
    return 'External(id: $id, publicName: $publicName, mediaId: $mediaId, url: $url, dbMediaType: $dbMediaType, songLyric: $songLyric)';
  }
}

/// @nodoc
abstract mixin class $ExternalCopyWith<$Res> {
  factory $ExternalCopyWith(External value, $Res Function(External) _then) =
      _$ExternalCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String publicName,
      String? mediaId,
      String? url,
      @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
      int dbMediaType,
      @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric});
}

/// @nodoc
class _$ExternalCopyWithImpl<$Res> implements $ExternalCopyWith<$Res> {
  _$ExternalCopyWithImpl(this._self, this._then);

  final External _self;
  final $Res Function(External) _then;

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicName = null,
    Object? mediaId = freezed,
    Object? url = freezed,
    Object? dbMediaType = null,
    Object? songLyric = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      publicName: null == publicName
          ? _self.publicName
          : publicName // ignore: cast_nullable_to_non_nullable
              as String,
      mediaId: freezed == mediaId
          ? _self.mediaId
          : mediaId // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      dbMediaType: null == dbMediaType
          ? _self.dbMediaType
          : dbMediaType // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _self.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
    ));
  }
}

/// Adds pattern-matching-related methods to [External].
extension ExternalPatterns on External {
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
    TResult Function(_External value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _External() when $default != null:
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
    TResult Function(_External value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _External():
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
    TResult? Function(_External value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _External() when $default != null:
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
            String publicName,
            String? mediaId,
            String? url,
            @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
            int dbMediaType,
            @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _External() when $default != null:
        return $default(_that.id, _that.publicName, _that.mediaId, _that.url,
            _that.dbMediaType, _that.songLyric);
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
            String publicName,
            String? mediaId,
            String? url,
            @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
            int dbMediaType,
            @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _External():
        return $default(_that.id, _that.publicName, _that.mediaId, _that.url,
            _that.dbMediaType, _that.songLyric);
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
            String publicName,
            String? mediaId,
            String? url,
            @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
            int dbMediaType,
            @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _External() when $default != null:
        return $default(_that.id, _that.publicName, _that.mediaId, _that.url,
            _that.dbMediaType, _that.songLyric);
      case _:
        return null;
    }
  }
}

/// @nodoc

@Entity(realClass: External)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _External extends External {
  const _External(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      required this.publicName,
      this.mediaId,
      this.url,
      @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
      required this.dbMediaType,
      @JsonKey(fromJson: _songLyricFromJson) required this.songLyric})
      : super._();
  factory _External.fromJson(Map<String, dynamic> json) =>
      _$ExternalFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String publicName;
  @override
  final String? mediaId;
  @override
  final String? url;
  @override
  @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
  final int dbMediaType;
  @override
  @JsonKey(fromJson: _songLyricFromJson)
  final ToOne<SongLyric> songLyric;

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExternalCopyWith<_External> get copyWith =>
      __$ExternalCopyWithImpl<_External>(this, _$identity);

  @override
  String toString() {
    return 'External(id: $id, publicName: $publicName, mediaId: $mediaId, url: $url, dbMediaType: $dbMediaType, songLyric: $songLyric)';
  }
}

/// @nodoc
abstract mixin class _$ExternalCopyWith<$Res>
    implements $ExternalCopyWith<$Res> {
  factory _$ExternalCopyWith(_External value, $Res Function(_External) _then) =
      __$ExternalCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String publicName,
      String? mediaId,
      String? url,
      @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
      int dbMediaType,
      @JsonKey(fromJson: _songLyricFromJson) ToOne<SongLyric> songLyric});
}

/// @nodoc
class __$ExternalCopyWithImpl<$Res> implements _$ExternalCopyWith<$Res> {
  __$ExternalCopyWithImpl(this._self, this._then);

  final _External _self;
  final $Res Function(_External) _then;

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? publicName = null,
    Object? mediaId = freezed,
    Object? url = freezed,
    Object? dbMediaType = null,
    Object? songLyric = null,
  }) {
    return _then(_External(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      publicName: null == publicName
          ? _self.publicName
          : publicName // ignore: cast_nullable_to_non_nullable
              as String,
      mediaId: freezed == mediaId
          ? _self.mediaId
          : mediaId // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      dbMediaType: null == dbMediaType
          ? _self.dbMediaType
          : dbMediaType // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _self.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
    ));
  }
}

// dart format on
