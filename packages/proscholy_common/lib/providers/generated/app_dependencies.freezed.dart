// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
