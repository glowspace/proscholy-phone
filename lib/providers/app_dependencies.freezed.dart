// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_dependencies.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppDependencies {
  SharedPreferences get sharedPreferences => throw _privateConstructorUsedError;
  Store get store => throw _privateConstructorUsedError;
  Database get ftsDatabase => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppDependenciesCopyWith<AppDependencies> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDependenciesCopyWith<$Res> {
  factory $AppDependenciesCopyWith(
          AppDependencies value, $Res Function(AppDependencies) then) =
      _$AppDependenciesCopyWithImpl<$Res, AppDependencies>;
  @useResult
  $Res call(
      {SharedPreferences sharedPreferences, Store store, Database ftsDatabase});
}

/// @nodoc
class _$AppDependenciesCopyWithImpl<$Res, $Val extends AppDependencies>
    implements $AppDependenciesCopyWith<$Res> {
  _$AppDependenciesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedPreferences = null,
    Object? store = null,
    Object? ftsDatabase = null,
  }) {
    return _then(_value.copyWith(
      sharedPreferences: null == sharedPreferences
          ? _value.sharedPreferences
          : sharedPreferences // ignore: cast_nullable_to_non_nullable
              as SharedPreferences,
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as Store,
      ftsDatabase: null == ftsDatabase
          ? _value.ftsDatabase
          : ftsDatabase // ignore: cast_nullable_to_non_nullable
              as Database,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppDependenciesCopyWith<$Res>
    implements $AppDependenciesCopyWith<$Res> {
  factory _$$_AppDependenciesCopyWith(
          _$_AppDependencies value, $Res Function(_$_AppDependencies) then) =
      __$$_AppDependenciesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SharedPreferences sharedPreferences, Store store, Database ftsDatabase});
}

/// @nodoc
class __$$_AppDependenciesCopyWithImpl<$Res>
    extends _$AppDependenciesCopyWithImpl<$Res, _$_AppDependencies>
    implements _$$_AppDependenciesCopyWith<$Res> {
  __$$_AppDependenciesCopyWithImpl(
      _$_AppDependencies _value, $Res Function(_$_AppDependencies) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sharedPreferences = null,
    Object? store = null,
    Object? ftsDatabase = null,
  }) {
    return _then(_$_AppDependencies(
      sharedPreferences: null == sharedPreferences
          ? _value.sharedPreferences
          : sharedPreferences // ignore: cast_nullable_to_non_nullable
              as SharedPreferences,
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as Store,
      ftsDatabase: null == ftsDatabase
          ? _value.ftsDatabase
          : ftsDatabase // ignore: cast_nullable_to_non_nullable
              as Database,
    ));
  }
}

/// @nodoc

class _$_AppDependencies implements _AppDependencies {
  const _$_AppDependencies(
      {required this.sharedPreferences,
      required this.store,
      required this.ftsDatabase});

  @override
  final SharedPreferences sharedPreferences;
  @override
  final Store store;
  @override
  final Database ftsDatabase;

  @override
  String toString() {
    return 'AppDependencies(sharedPreferences: $sharedPreferences, store: $store, ftsDatabase: $ftsDatabase)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppDependencies &&
            (identical(other.sharedPreferences, sharedPreferences) ||
                other.sharedPreferences == sharedPreferences) &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.ftsDatabase, ftsDatabase) ||
                other.ftsDatabase == ftsDatabase));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sharedPreferences, store, ftsDatabase);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppDependenciesCopyWith<_$_AppDependencies> get copyWith =>
      __$$_AppDependenciesCopyWithImpl<_$_AppDependencies>(this, _$identity);
}

abstract class _AppDependencies implements AppDependencies {
  const factory _AppDependencies(
      {required final SharedPreferences sharedPreferences,
      required final Store store,
      required final Database ftsDatabase}) = _$_AppDependencies;

  @override
  SharedPreferences get sharedPreferences;
  @override
  Store get store;
  @override
  Database get ftsDatabase;
  @override
  @JsonKey(ignore: true)
  _$$_AppDependenciesCopyWith<_$_AppDependencies> get copyWith =>
      throw _privateConstructorUsedError;
}
