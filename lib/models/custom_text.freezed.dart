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
  @Backlink()
  ToMany<PlaylistRecord> get playlistRecords =>
      throw _privateConstructorUsedError;

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
  $Res call(
      {@Id(assignable: true) int id,
      String name,
      String content,
      @Backlink() ToMany<PlaylistRecord> playlistRecords});
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
    Object? playlistRecords = null,
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
      playlistRecords: null == playlistRecords
          ? _value.playlistRecords
          : playlistRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<PlaylistRecord>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CustomTextCopyWith<$Res>
    implements $CustomTextCopyWith<$Res> {
  factory _$$_CustomTextCopyWith(
          _$_CustomText value, $Res Function(_$_CustomText) then) =
      __$$_CustomTextCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      String name,
      String content,
      @Backlink() ToMany<PlaylistRecord> playlistRecords});
}

/// @nodoc
class __$$_CustomTextCopyWithImpl<$Res>
    extends _$CustomTextCopyWithImpl<$Res, _$_CustomText>
    implements _$$_CustomTextCopyWith<$Res> {
  __$$_CustomTextCopyWithImpl(
      _$_CustomText _value, $Res Function(_$_CustomText) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? content = null,
    Object? playlistRecords = null,
  }) {
    return _then(_$_CustomText(
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
      playlistRecords: null == playlistRecords
          ? _value.playlistRecords
          : playlistRecords // ignore: cast_nullable_to_non_nullable
              as ToMany<PlaylistRecord>,
    ));
  }
}

/// @nodoc

@Entity(realClass: CustomText)
class _$_CustomText implements _CustomText {
  const _$_CustomText(
      {@Id(assignable: true) required this.id,
      required this.name,
      required this.content,
      @Backlink() required this.playlistRecords});

  @override
  @Id(assignable: true)
  final int id;
  @override
  final String name;
  @override
  final String content;
  @override
  @Backlink()
  final ToMany<PlaylistRecord> playlistRecords;

  @override
  String toString() {
    return 'CustomText(id: $id, name: $name, content: $content, playlistRecords: $playlistRecords)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CustomText &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other.playlistRecords, playlistRecords));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, content,
      const DeepCollectionEquality().hash(playlistRecords));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CustomTextCopyWith<_$_CustomText> get copyWith =>
      __$$_CustomTextCopyWithImpl<_$_CustomText>(this, _$identity);
}

abstract class _CustomText implements CustomText {
  const factory _CustomText(
          {@Id(assignable: true) required final int id,
          required final String name,
          required final String content,
          @Backlink() required final ToMany<PlaylistRecord> playlistRecords}) =
      _$_CustomText;

  @override
  @Id(assignable: true)
  int get id;
  @override
  String get name;
  @override
  String get content;
  @override
  @Backlink()
  ToMany<PlaylistRecord> get playlistRecords;
  @override
  @JsonKey(ignore: true)
  _$$_CustomTextCopyWith<_$_CustomText> get copyWith =>
      throw _privateConstructorUsedError;
}
