// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) {
  return _NewsItem.fromJson(json);
}

/// @nodoc
mixin _$NewsItem {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  @Property(type: PropertyType.date)
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NewsItemCopyWith<NewsItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsItemCopyWith<$Res> {
  factory $NewsItemCopyWith(NewsItem value, $Res Function(NewsItem) then) =
      _$NewsItemCopyWithImpl<$Res, NewsItem>;
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String text,
      String link,
      @Property(type: PropertyType.date) DateTime? expiresAt});
}

/// @nodoc
class _$NewsItemCopyWithImpl<$Res, $Val extends NewsItem>
    implements $NewsItemCopyWith<$Res> {
  _$NewsItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? link = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NewsItemCopyWith<$Res> implements $NewsItemCopyWith<$Res> {
  factory _$$_NewsItemCopyWith(
          _$_NewsItem value, $Res Function(_$_NewsItem) then) =
      __$$_NewsItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) int id,
      String text,
      String link,
      @Property(type: PropertyType.date) DateTime? expiresAt});
}

/// @nodoc
class __$$_NewsItemCopyWithImpl<$Res>
    extends _$NewsItemCopyWithImpl<$Res, _$_NewsItem>
    implements _$$_NewsItemCopyWith<$Res> {
  __$$_NewsItemCopyWithImpl(
      _$_NewsItem _value, $Res Function(_$_NewsItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? link = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_$_NewsItem(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@Entity(realClass: NewsItem)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _$_NewsItem implements _NewsItem {
  const _$_NewsItem(
      {@Id(assignable: true) @JsonKey(fromJson: int.parse) required this.id,
      required this.text,
      required this.link,
      @Property(type: PropertyType.date) this.expiresAt});

  factory _$_NewsItem.fromJson(Map<String, dynamic> json) =>
      _$$_NewsItemFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String text;
  @override
  final String link;
  @override
  @Property(type: PropertyType.date)
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'NewsItem(id: $id, text: $text, link: $link, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NewsItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, link, expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NewsItemCopyWith<_$_NewsItem> get copyWith =>
      __$$_NewsItemCopyWithImpl<_$_NewsItem>(this, _$identity);
}

abstract class _NewsItem implements NewsItem {
  const factory _NewsItem(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          required final int id,
      required final String text,
      required final String link,
      @Property(type: PropertyType.date)
          final DateTime? expiresAt}) = _$_NewsItem;

  factory _NewsItem.fromJson(Map<String, dynamic> json) = _$_NewsItem.fromJson;

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  @override
  String get text;
  @override
  String get link;
  @override
  @Property(type: PropertyType.date)
  DateTime? get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$_NewsItemCopyWith<_$_NewsItem> get copyWith =>
      throw _privateConstructorUsedError;
}