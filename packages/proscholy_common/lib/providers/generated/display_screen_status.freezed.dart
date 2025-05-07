// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../display_screen_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DisplayScreenStatusModel {
  bool get fullScreen;
  bool get showingExternals;

  /// Create a copy of DisplayScreenStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DisplayScreenStatusModelCopyWith<DisplayScreenStatusModel> get copyWith =>
      _$DisplayScreenStatusModelCopyWithImpl<DisplayScreenStatusModel>(
          this as DisplayScreenStatusModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DisplayScreenStatusModel &&
            (identical(other.fullScreen, fullScreen) ||
                other.fullScreen == fullScreen) &&
            (identical(other.showingExternals, showingExternals) ||
                other.showingExternals == showingExternals));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fullScreen, showingExternals);

  @override
  String toString() {
    return 'DisplayScreenStatusModel(fullScreen: $fullScreen, showingExternals: $showingExternals)';
  }
}

/// @nodoc
abstract mixin class $DisplayScreenStatusModelCopyWith<$Res> {
  factory $DisplayScreenStatusModelCopyWith(DisplayScreenStatusModel value,
          $Res Function(DisplayScreenStatusModel) _then) =
      _$DisplayScreenStatusModelCopyWithImpl;
  @useResult
  $Res call({bool fullScreen, bool showingExternals});
}

/// @nodoc
class _$DisplayScreenStatusModelCopyWithImpl<$Res>
    implements $DisplayScreenStatusModelCopyWith<$Res> {
  _$DisplayScreenStatusModelCopyWithImpl(this._self, this._then);

  final DisplayScreenStatusModel _self;
  final $Res Function(DisplayScreenStatusModel) _then;

  /// Create a copy of DisplayScreenStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullScreen = null,
    Object? showingExternals = null,
  }) {
    return _then(_self.copyWith(
      fullScreen: null == fullScreen
          ? _self.fullScreen
          : fullScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      showingExternals: null == showingExternals
          ? _self.showingExternals
          : showingExternals // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _DisplayScreenStatusModel implements DisplayScreenStatusModel {
  const _DisplayScreenStatusModel(
      {required this.fullScreen, required this.showingExternals});

  @override
  final bool fullScreen;
  @override
  final bool showingExternals;

  /// Create a copy of DisplayScreenStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DisplayScreenStatusModelCopyWith<_DisplayScreenStatusModel> get copyWith =>
      __$DisplayScreenStatusModelCopyWithImpl<_DisplayScreenStatusModel>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DisplayScreenStatusModel &&
            (identical(other.fullScreen, fullScreen) ||
                other.fullScreen == fullScreen) &&
            (identical(other.showingExternals, showingExternals) ||
                other.showingExternals == showingExternals));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fullScreen, showingExternals);

  @override
  String toString() {
    return 'DisplayScreenStatusModel(fullScreen: $fullScreen, showingExternals: $showingExternals)';
  }
}

/// @nodoc
abstract mixin class _$DisplayScreenStatusModelCopyWith<$Res>
    implements $DisplayScreenStatusModelCopyWith<$Res> {
  factory _$DisplayScreenStatusModelCopyWith(_DisplayScreenStatusModel value,
          $Res Function(_DisplayScreenStatusModel) _then) =
      __$DisplayScreenStatusModelCopyWithImpl;
  @override
  @useResult
  $Res call({bool fullScreen, bool showingExternals});
}

/// @nodoc
class __$DisplayScreenStatusModelCopyWithImpl<$Res>
    implements _$DisplayScreenStatusModelCopyWith<$Res> {
  __$DisplayScreenStatusModelCopyWithImpl(this._self, this._then);

  final _DisplayScreenStatusModel _self;
  final $Res Function(_DisplayScreenStatusModel) _then;

  /// Create a copy of DisplayScreenStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? fullScreen = null,
    Object? showingExternals = null,
  }) {
    return _then(_DisplayScreenStatusModel(
      fullScreen: null == fullScreen
          ? _self.fullScreen
          : fullScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      showingExternals: null == showingExternals
          ? _self.showingExternals
          : showingExternals // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
