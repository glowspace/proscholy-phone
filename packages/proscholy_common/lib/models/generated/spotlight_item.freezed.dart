// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../spotlight_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpotlightItem {
  String get identifier;
  String get title;
  String get description;

  /// Create a copy of SpotlightItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpotlightItemCopyWith<SpotlightItem> get copyWith =>
      _$SpotlightItemCopyWithImpl<SpotlightItem>(
          this as SpotlightItem, _$identity);

  /// Serializes this SpotlightItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpotlightItem &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identifier, title, description);

  @override
  String toString() {
    return 'SpotlightItem(identifier: $identifier, title: $title, description: $description)';
  }
}

/// @nodoc
abstract mixin class $SpotlightItemCopyWith<$Res> {
  factory $SpotlightItemCopyWith(
          SpotlightItem value, $Res Function(SpotlightItem) _then) =
      _$SpotlightItemCopyWithImpl;
  @useResult
  $Res call({String identifier, String title, String description});
}

/// @nodoc
class _$SpotlightItemCopyWithImpl<$Res>
    implements $SpotlightItemCopyWith<$Res> {
  _$SpotlightItemCopyWithImpl(this._self, this._then);

  final SpotlightItem _self;
  final $Res Function(SpotlightItem) _then;

  /// Create a copy of SpotlightItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_self.copyWith(
      identifier: null == identifier
          ? _self.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SpotlightItem implements SpotlightItem {
  const _SpotlightItem(
      {required this.identifier,
      required this.title,
      required this.description});
  factory _SpotlightItem.fromJson(Map<String, dynamic> json) =>
      _$SpotlightItemFromJson(json);

  @override
  final String identifier;
  @override
  final String title;
  @override
  final String description;

  /// Create a copy of SpotlightItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SpotlightItemCopyWith<_SpotlightItem> get copyWith =>
      __$SpotlightItemCopyWithImpl<_SpotlightItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpotlightItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SpotlightItem &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identifier, title, description);

  @override
  String toString() {
    return 'SpotlightItem(identifier: $identifier, title: $title, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$SpotlightItemCopyWith<$Res>
    implements $SpotlightItemCopyWith<$Res> {
  factory _$SpotlightItemCopyWith(
          _SpotlightItem value, $Res Function(_SpotlightItem) _then) =
      __$SpotlightItemCopyWithImpl;
  @override
  @useResult
  $Res call({String identifier, String title, String description});
}

/// @nodoc
class __$SpotlightItemCopyWithImpl<$Res>
    implements _$SpotlightItemCopyWith<$Res> {
  __$SpotlightItemCopyWithImpl(this._self, this._then);

  final _SpotlightItem _self;
  final $Res Function(_SpotlightItem) _then;

  /// Create a copy of SpotlightItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? identifier = null,
    Object? title = null,
    Object? description = null,
  }) {
    return _then(_SpotlightItem(
      identifier: null == identifier
          ? _self.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
