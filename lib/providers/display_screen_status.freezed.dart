// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'display_screen_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DisplayScreenStatusModel {
  bool get fullScreen => throw _privateConstructorUsedError;
  bool get showingExternals => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DisplayScreenStatusModelCopyWith<DisplayScreenStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DisplayScreenStatusModelCopyWith<$Res> {
  factory $DisplayScreenStatusModelCopyWith(DisplayScreenStatusModel value,
          $Res Function(DisplayScreenStatusModel) then) =
      _$DisplayScreenStatusModelCopyWithImpl<$Res, DisplayScreenStatusModel>;
  @useResult
  $Res call({bool fullScreen, bool showingExternals});
}

/// @nodoc
class _$DisplayScreenStatusModelCopyWithImpl<$Res,
        $Val extends DisplayScreenStatusModel>
    implements $DisplayScreenStatusModelCopyWith<$Res> {
  _$DisplayScreenStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullScreen = null,
    Object? showingExternals = null,
  }) {
    return _then(_value.copyWith(
      fullScreen: null == fullScreen
          ? _value.fullScreen
          : fullScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      showingExternals: null == showingExternals
          ? _value.showingExternals
          : showingExternals // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DisplayScreenStatusModelImplCopyWith<$Res>
    implements $DisplayScreenStatusModelCopyWith<$Res> {
  factory _$$DisplayScreenStatusModelImplCopyWith(
          _$DisplayScreenStatusModelImpl value,
          $Res Function(_$DisplayScreenStatusModelImpl) then) =
      __$$DisplayScreenStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool fullScreen, bool showingExternals});
}

/// @nodoc
class __$$DisplayScreenStatusModelImplCopyWithImpl<$Res>
    extends _$DisplayScreenStatusModelCopyWithImpl<$Res,
        _$DisplayScreenStatusModelImpl>
    implements _$$DisplayScreenStatusModelImplCopyWith<$Res> {
  __$$DisplayScreenStatusModelImplCopyWithImpl(
      _$DisplayScreenStatusModelImpl _value,
      $Res Function(_$DisplayScreenStatusModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullScreen = null,
    Object? showingExternals = null,
  }) {
    return _then(_$DisplayScreenStatusModelImpl(
      fullScreen: null == fullScreen
          ? _value.fullScreen
          : fullScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      showingExternals: null == showingExternals
          ? _value.showingExternals
          : showingExternals // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DisplayScreenStatusModelImpl implements _DisplayScreenStatusModel {
  const _$DisplayScreenStatusModelImpl(
      {required this.fullScreen, required this.showingExternals});

  @override
  final bool fullScreen;
  @override
  final bool showingExternals;

  @override
  String toString() {
    return 'DisplayScreenStatusModel(fullScreen: $fullScreen, showingExternals: $showingExternals)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DisplayScreenStatusModelImpl &&
            (identical(other.fullScreen, fullScreen) ||
                other.fullScreen == fullScreen) &&
            (identical(other.showingExternals, showingExternals) ||
                other.showingExternals == showingExternals));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fullScreen, showingExternals);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DisplayScreenStatusModelImplCopyWith<_$DisplayScreenStatusModelImpl>
      get copyWith => __$$DisplayScreenStatusModelImplCopyWithImpl<
          _$DisplayScreenStatusModelImpl>(this, _$identity);
}

abstract class _DisplayScreenStatusModel implements DisplayScreenStatusModel {
  const factory _DisplayScreenStatusModel(
      {required final bool fullScreen,
      required final bool showingExternals}) = _$DisplayScreenStatusModelImpl;

  @override
  bool get fullScreen;
  @override
  bool get showingExternals;
  @override
  @JsonKey(ignore: true)
  _$$DisplayScreenStatusModelImplCopyWith<_$DisplayScreenStatusModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
