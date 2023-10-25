// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotlight_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpotlightItem _$SpotlightItemFromJson(Map<String, dynamic> json) {
  return _SpotlightItem.fromJson(json);
}

/// @nodoc
mixin _$SpotlightItem {
  String get identifier => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotlightItemCopyWith<SpotlightItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotlightItemCopyWith<$Res> {
  factory $SpotlightItemCopyWith(
          SpotlightItem value, $Res Function(SpotlightItem) then) =
      _$SpotlightItemCopyWithImpl<$Res, SpotlightItem>;
  @useResult
  $Res call({String identifier, String title, String description});
}

/// @nodoc
class _$SpotlightItemCopyWithImpl<$Res, $Val extends SpotlightItem>
    implements $SpotlightItemCopyWith<$Res> {
  _$SpotlightItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotlightItemImplCopyWith<$Res>
    implements $SpotlightItemCopyWith<$Res> {
  factory _$$SpotlightItemImplCopyWith(
          _$SpotlightItemImpl value, $Res Function(_$SpotlightItemImpl) then) =
      __$$SpotlightItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String identifier, String title, String description});
}

/// @nodoc
class __$$SpotlightItemImplCopyWithImpl<$Res>
    extends _$SpotlightItemCopyWithImpl<$Res, _$SpotlightItemImpl>
    implements _$$SpotlightItemImplCopyWith<$Res> {
  __$$SpotlightItemImplCopyWithImpl(
      _$SpotlightItemImpl _value, $Res Function(_$SpotlightItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_$SpotlightItemImpl(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpotlightItemImpl implements _SpotlightItem {
  const _$SpotlightItemImpl(
      {required this.identifier,
      required this.title,
      required this.description});

  factory _$SpotlightItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotlightItemImplFromJson(json);

  @override
  final String identifier;
  @override
  final String title;
  @override
  final String description;

  @override
  String toString() {
    return 'SpotlightItem(identifier: $identifier, title: $title, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotlightItemImpl &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, identifier, title, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotlightItemImplCopyWith<_$SpotlightItemImpl> get copyWith =>
      __$$SpotlightItemImplCopyWithImpl<_$SpotlightItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotlightItemImplToJson(
      this,
    );
  }
}

abstract class _SpotlightItem implements SpotlightItem {
  const factory _SpotlightItem(
      {required final String identifier,
      required final String title,
      required final String description}) = _$SpotlightItemImpl;

  factory _SpotlightItem.fromJson(Map<String, dynamic> json) =
      _$SpotlightItemImpl.fromJson;

  @override
  String get identifier;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$SpotlightItemImplCopyWith<_$SpotlightItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
