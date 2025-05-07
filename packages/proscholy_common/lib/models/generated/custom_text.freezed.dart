// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../custom_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomText {
  @Id(assignable: true)
  int get id;
  String get name;
  String get content;

  /// Create a copy of CustomText
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomTextCopyWith<CustomText> get copyWith =>
      _$CustomTextCopyWithImpl<CustomText>(this as CustomText, _$identity);

  @override
  String toString() {
    return 'CustomText(id: $id, name: $name, content: $content)';
  }
}

/// @nodoc
abstract mixin class $CustomTextCopyWith<$Res> {
  factory $CustomTextCopyWith(
          CustomText value, $Res Function(CustomText) _then) =
      _$CustomTextCopyWithImpl;
  @useResult
  $Res call({@Id(assignable: true) int id, String name, String content});
}

/// @nodoc
class _$CustomTextCopyWithImpl<$Res> implements $CustomTextCopyWith<$Res> {
  _$CustomTextCopyWithImpl(this._self, this._then);

  final CustomText _self;
  final $Res Function(CustomText) _then;

  /// Create a copy of CustomText
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? content = null,
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
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@Entity(realClass: CustomText)
class _CustomText extends CustomText {
  const _CustomText(
      {@Id(assignable: true) required this.id,
      required this.name,
      required this.content})
      : super._();

  @override
  @Id(assignable: true)
  final int id;
  @override
  final String name;
  @override
  final String content;

  /// Create a copy of CustomText
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomTextCopyWith<_CustomText> get copyWith =>
      __$CustomTextCopyWithImpl<_CustomText>(this, _$identity);

  @override
  String toString() {
    return 'CustomText(id: $id, name: $name, content: $content)';
  }
}

/// @nodoc
abstract mixin class _$CustomTextCopyWith<$Res>
    implements $CustomTextCopyWith<$Res> {
  factory _$CustomTextCopyWith(
          _CustomText value, $Res Function(_CustomText) _then) =
      __$CustomTextCopyWithImpl;
  @override
  @useResult
  $Res call({@Id(assignable: true) int id, String name, String content});
}

/// @nodoc
class __$CustomTextCopyWithImpl<$Res> implements _$CustomTextCopyWith<$Res> {
  __$CustomTextCopyWithImpl(this._self, this._then);

  final _CustomText _self;
  final $Res Function(_CustomText) _then;

  /// Create a copy of CustomText
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? content = null,
  }) {
    return _then(_CustomText(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
