// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../app_dependencies.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppDependencies {
// reference to simple key-value storage
  SharedPreferences
      get sharedPreferences; // objectbox store used as NoSQL database
  Store get store; // FTS4 database that is used during song lyrics search
  Database
      get ftsDatabase; // info about application (used for version and build number)
  PackageInfo get packageInfo;

  /// Create a copy of AppDependencies
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppDependenciesCopyWith<AppDependencies> get copyWith =>
      _$AppDependenciesCopyWithImpl<AppDependencies>(
          this as AppDependencies, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppDependencies &&
            (identical(other.sharedPreferences, sharedPreferences) ||
                other.sharedPreferences == sharedPreferences) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.ftsDatabase, ftsDatabase) ||
                other.ftsDatabase == ftsDatabase) &&
            (identical(other.packageInfo, packageInfo) ||
                other.packageInfo == packageInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, sharedPreferences, store, ftsDatabase, packageInfo);

  @override
  String toString() {
    return 'AppDependencies(sharedPreferences: $sharedPreferences, store: $store, ftsDatabase: $ftsDatabase, packageInfo: $packageInfo)';
  }
}

/// @nodoc
abstract mixin class $AppDependenciesCopyWith<$Res> {
  factory $AppDependenciesCopyWith(
          AppDependencies value, $Res Function(AppDependencies) _then) =
      _$AppDependenciesCopyWithImpl;
  @useResult
  $Res call(
      {SharedPreferences sharedPreferences,
      Store store,
      Database ftsDatabase,
      PackageInfo packageInfo});
}

/// @nodoc
class _$AppDependenciesCopyWithImpl<$Res>
    implements $AppDependenciesCopyWith<$Res> {
  _$AppDependenciesCopyWithImpl(this._self, this._then);

  final AppDependencies _self;
  final $Res Function(AppDependencies) _then;

  /// Create a copy of AppDependencies
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedPreferences = null,
    Object? store = null,
    Object? ftsDatabase = null,
    Object? packageInfo = null,
  }) {
    return _then(_self.copyWith(
      sharedPreferences: null == sharedPreferences
          ? _self.sharedPreferences
          : sharedPreferences // ignore: cast_nullable_to_non_nullable
              as SharedPreferences,
      store: null == store
          ? _self.store
          : store // ignore: cast_nullable_to_non_nullable
              as Store,
      ftsDatabase: null == ftsDatabase
          ? _self.ftsDatabase
          : ftsDatabase // ignore: cast_nullable_to_non_nullable
              as Database,
      packageInfo: null == packageInfo
          ? _self.packageInfo
          : packageInfo // ignore: cast_nullable_to_non_nullable
              as PackageInfo,
    ));
  }
}

/// Adds pattern-matching-related methods to [AppDependencies].
extension AppDependenciesPatterns on AppDependencies {
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
    TResult Function(_AppDependencies value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppDependencies() when $default != null:
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
    TResult Function(_AppDependencies value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppDependencies():
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
    TResult? Function(_AppDependencies value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppDependencies() when $default != null:
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
    TResult Function(SharedPreferences sharedPreferences, Store store,
            Database ftsDatabase, PackageInfo packageInfo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppDependencies() when $default != null:
        return $default(_that.sharedPreferences, _that.store, _that.ftsDatabase,
            _that.packageInfo);
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
    TResult Function(SharedPreferences sharedPreferences, Store store,
            Database ftsDatabase, PackageInfo packageInfo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppDependencies():
        return $default(_that.sharedPreferences, _that.store, _that.ftsDatabase,
            _that.packageInfo);
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
    TResult? Function(SharedPreferences sharedPreferences, Store store,
            Database ftsDatabase, PackageInfo packageInfo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppDependencies() when $default != null:
        return $default(_that.sharedPreferences, _that.store, _that.ftsDatabase,
            _that.packageInfo);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AppDependencies implements AppDependencies {
  const _AppDependencies(
      {required this.sharedPreferences,
      required this.store,
      required this.ftsDatabase,
      required this.packageInfo});

// reference to simple key-value storage
  @override
  final SharedPreferences sharedPreferences;
// objectbox store used as NoSQL database
  @override
  final Store store;
// FTS4 database that is used during song lyrics search
  @override
  final Database ftsDatabase;
// info about application (used for version and build number)
  @override
  final PackageInfo packageInfo;

  /// Create a copy of AppDependencies
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppDependenciesCopyWith<_AppDependencies> get copyWith =>
      __$AppDependenciesCopyWithImpl<_AppDependencies>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppDependencies &&
            (identical(other.sharedPreferences, sharedPreferences) ||
                other.sharedPreferences == sharedPreferences) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.ftsDatabase, ftsDatabase) ||
                other.ftsDatabase == ftsDatabase) &&
            (identical(other.packageInfo, packageInfo) ||
                other.packageInfo == packageInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, sharedPreferences, store, ftsDatabase, packageInfo);

  @override
  String toString() {
    return 'AppDependencies(sharedPreferences: $sharedPreferences, store: $store, ftsDatabase: $ftsDatabase, packageInfo: $packageInfo)';
  }
}

/// @nodoc
abstract mixin class _$AppDependenciesCopyWith<$Res>
    implements $AppDependenciesCopyWith<$Res> {
  factory _$AppDependenciesCopyWith(
          _AppDependencies value, $Res Function(_AppDependencies) _then) =
      __$AppDependenciesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SharedPreferences sharedPreferences,
      Store store,
      Database ftsDatabase,
      PackageInfo packageInfo});
}

/// @nodoc
class __$AppDependenciesCopyWithImpl<$Res>
    implements _$AppDependenciesCopyWith<$Res> {
  __$AppDependenciesCopyWithImpl(this._self, this._then);

  final _AppDependencies _self;
  final $Res Function(_AppDependencies) _then;

  /// Create a copy of AppDependencies
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sharedPreferences = null,
    Object? store = null,
    Object? ftsDatabase = null,
    Object? packageInfo = null,
  }) {
    return _then(_AppDependencies(
      sharedPreferences: null == sharedPreferences
          ? _self.sharedPreferences
          : sharedPreferences // ignore: cast_nullable_to_non_nullable
              as SharedPreferences,
      store: null == store
          ? _self.store
          : store // ignore: cast_nullable_to_non_nullable
              as Store,
      ftsDatabase: null == ftsDatabase
          ? _self.ftsDatabase
          : ftsDatabase // ignore: cast_nullable_to_non_nullable
              as Database,
      packageInfo: null == packageInfo
          ? _self.packageInfo
          : packageInfo // ignore: cast_nullable_to_non_nullable
              as PackageInfo,
    ));
  }
}

// dart format on
