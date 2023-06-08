// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

External _$ExternalFromJson(Map<String, dynamic> json) {
  return _External.fromJson(json);
}

/// @nodoc
mixin _$External {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id => throw _privateConstructorUsedError;
  String get publicName => throw _privateConstructorUsedError;
  String? get mediaId => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
  int get dbMediaType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExternalCopyWith<External> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExternalCopyWith<$Res> {
  factory $ExternalCopyWith(External value, $Res Function(External) then) =
      _$ExternalCopyWithImpl<$Res, External>;
  @useResult
  $Res call(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          int id,
      String publicName,
      String? mediaId,
      String? url,
      @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
          int dbMediaType});
}

/// @nodoc
class _$ExternalCopyWithImpl<$Res, $Val extends External>
    implements $ExternalCopyWith<$Res> {
  _$ExternalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicName = null,
    Object? mediaId = freezed,
    Object? url = freezed,
    Object? dbMediaType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      publicName: null == publicName
          ? _value.publicName
          : publicName // ignore: cast_nullable_to_non_nullable
              as String,
      mediaId: freezed == mediaId
          ? _value.mediaId
          : mediaId // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      dbMediaType: null == dbMediaType
          ? _value.dbMediaType
          : dbMediaType // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ExternalCopyWith<$Res> implements $ExternalCopyWith<$Res> {
  factory _$$_ExternalCopyWith(
          _$_External value, $Res Function(_$_External) then) =
      __$$_ExternalCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          int id,
      String publicName,
      String? mediaId,
      String? url,
      @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
          int dbMediaType});
}

/// @nodoc
class __$$_ExternalCopyWithImpl<$Res>
    extends _$ExternalCopyWithImpl<$Res, _$_External>
    implements _$$_ExternalCopyWith<$Res> {
  __$$_ExternalCopyWithImpl(
      _$_External _value, $Res Function(_$_External) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicName = null,
    Object? mediaId = freezed,
    Object? url = freezed,
    Object? dbMediaType = null,
  }) {
    return _then(_$_External(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      publicName: null == publicName
          ? _value.publicName
          : publicName // ignore: cast_nullable_to_non_nullable
              as String,
      mediaId: freezed == mediaId
          ? _value.mediaId
          : mediaId // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      dbMediaType: null == dbMediaType
          ? _value.dbMediaType
          : dbMediaType // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@Entity(realClass: External)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _$_External extends _External {
  const _$_External(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          required this.id,
      required this.publicName,
      this.mediaId,
      this.url,
      @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
          required this.dbMediaType})
      : super._();

  factory _$_External.fromJson(Map<String, dynamic> json) =>
      _$$_ExternalFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String publicName;
  @override
  final String? mediaId;
  @override
  final String? url;
  @override
  @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
  final int dbMediaType;

  @override
  String toString() {
    return 'External(id: $id, publicName: $publicName, mediaId: $mediaId, url: $url, dbMediaType: $dbMediaType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_External &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.publicName, publicName) ||
                other.publicName == publicName) &&
            (identical(other.mediaId, mediaId) || other.mediaId == mediaId) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.dbMediaType, dbMediaType) ||
                other.dbMediaType == dbMediaType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, publicName, mediaId, url, dbMediaType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ExternalCopyWith<_$_External> get copyWith =>
      __$$_ExternalCopyWithImpl<_$_External>(this, _$identity);
}

abstract class _External extends External {
  const factory _External(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          required final int id,
      required final String publicName,
      final String? mediaId,
      final String? url,
      @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
          required final int dbMediaType}) = _$_External;
  const _External._() : super._();

  factory _External.fromJson(Map<String, dynamic> json) = _$_External.fromJson;

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  @override
  String get publicName;
  @override
  String? get mediaId;
  @override
  String? get url;
  @override
  @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString)
  int get dbMediaType;
  @override
  @JsonKey(ignore: true)
  _$$_ExternalCopyWith<_$_External> get copyWith =>
      throw _privateConstructorUsedError;
}
