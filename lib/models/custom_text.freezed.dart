// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CustomText {
  @Id(assignable: true)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CustomTextCopyWith<CustomText> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomTextCopyWith<$Res> {
  factory $CustomTextCopyWith(
          CustomText value, $Res Function(CustomText) then) =
      _$CustomTextCopyWithImpl<$Res, CustomText>;
  @useResult
  $Res call({@Id(assignable: true) int id, String name, String content});
}

/// @nodoc
class _$CustomTextCopyWithImpl<$Res, $Val extends CustomText>
    implements $CustomTextCopyWith<$Res> {
  _$CustomTextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomTextImplCopyWith<$Res>
    implements $CustomTextCopyWith<$Res> {
  factory _$$CustomTextImplCopyWith(
          _$CustomTextImpl value, $Res Function(_$CustomTextImpl) then) =
      __$$CustomTextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@Id(assignable: true) int id, String name, String content});
}

/// @nodoc
class __$$CustomTextImplCopyWithImpl<$Res>
    extends _$CustomTextCopyWithImpl<$Res, _$CustomTextImpl>
    implements _$$CustomTextImplCopyWith<$Res> {
  __$$CustomTextImplCopyWithImpl(
      _$CustomTextImpl _value, $Res Function(_$CustomTextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? content = null,
  }) {
    return _then(_$CustomTextImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@Entity(realClass: CustomText)
class _$CustomTextImpl extends _CustomText {
  const _$CustomTextImpl(
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

  @override
  String toString() {
    return 'CustomText(id: $id, name: $name, content: $content)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomTextImplCopyWith<_$CustomTextImpl> get copyWith =>
      __$$CustomTextImplCopyWithImpl<_$CustomTextImpl>(this, _$identity);
}

abstract class _CustomText extends CustomText {
  const factory _CustomText(
      {@Id(assignable: true) required final int id,
      required final String name,
      required final String content}) = _$CustomTextImpl;
  const _CustomText._() : super._();

  @override
  @Id(assignable: true)
  int get id;
  @override
  String get name;
  @override
  String get content;
  @override
  @JsonKey(ignore: true)
  _$$CustomTextImplCopyWith<_$CustomTextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
