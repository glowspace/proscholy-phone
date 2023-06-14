// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'songbook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Songbook _$SongbookFromJson(Map<String, dynamic> json) {
  return _Songbook.fromJson(json);
}

/// @nodoc
mixin _$Songbook {
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: '')
  String get shortcut => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get colorText => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  @Deprecated('is handled independently on model')
  bool? get isPinned => throw _privateConstructorUsedError;
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  ToMany<SongbookRecord> get records => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongbookCopyWith<Songbook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongbookCopyWith<$Res> {
  factory $SongbookCopyWith(Songbook value, $Res Function(Songbook) then) =
      _$SongbookCopyWithImpl<$Res, Songbook>;
  @useResult
  $Res call(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          int id,
      String name,
      @JsonKey(defaultValue: '')
          String shortcut,
      String? color,
      String? colorText,
      bool isPrivate,
      @Deprecated('is handled independently on model')
          bool? isPinned,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
          ToMany<SongbookRecord> records});
}

/// @nodoc
class _$SongbookCopyWithImpl<$Res, $Val extends Songbook>
    implements $SongbookCopyWith<$Res> {
  _$SongbookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortcut = null,
    Object? color = freezed,
    Object? colorText = freezed,
    Object? isPrivate = null,
    Object? isPinned = freezed,
    Object? records = null,
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
      shortcut: null == shortcut
          ? _value.shortcut
          : shortcut // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      colorText: freezed == colorText
          ? _value.colorText
          : colorText // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: freezed == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool?,
      records: null == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as ToMany<SongbookRecord>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SongbookCopyWith<$Res> implements $SongbookCopyWith<$Res> {
  factory _$$_SongbookCopyWith(
          _$_Songbook value, $Res Function(_$_Songbook) then) =
      __$$_SongbookCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          int id,
      String name,
      @JsonKey(defaultValue: '')
          String shortcut,
      String? color,
      String? colorText,
      bool isPrivate,
      @Deprecated('is handled independently on model')
          bool? isPinned,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
          ToMany<SongbookRecord> records});
}

/// @nodoc
class __$$_SongbookCopyWithImpl<$Res>
    extends _$SongbookCopyWithImpl<$Res, _$_Songbook>
    implements _$$_SongbookCopyWith<$Res> {
  __$$_SongbookCopyWithImpl(
      _$_Songbook _value, $Res Function(_$_Songbook) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortcut = null,
    Object? color = freezed,
    Object? colorText = freezed,
    Object? isPrivate = null,
    Object? isPinned = freezed,
    Object? records = null,
  }) {
    return _then(_$_Songbook(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortcut: null == shortcut
          ? _value.shortcut
          : shortcut // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      colorText: freezed == colorText
          ? _value.colorText
          : colorText // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: freezed == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool?,
      records: null == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as ToMany<SongbookRecord>,
    ));
  }
}

/// @nodoc

@Entity(realClass: Songbook)
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class _$_Songbook extends _Songbook {
  const _$_Songbook(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          required this.id,
      required this.name,
      @JsonKey(defaultValue: '')
          required this.shortcut,
      this.color,
      this.colorText,
      required this.isPrivate,
      @Deprecated('is handled independently on model')
          this.isPinned,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
          required this.records})
      : super._();

  factory _$_Songbook.fromJson(Map<String, dynamic> json) =>
      _$$_SongbookFromJson(json);

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  final int id;
  @override
  final String name;
  @override
  @JsonKey(defaultValue: '')
  final String shortcut;
  @override
  final String? color;
  @override
  final String? colorText;
  @override
  final bool isPrivate;
  @override
  @Deprecated('is handled independently on model')
  final bool? isPinned;
  @override
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  final ToMany<SongbookRecord> records;

  @override
  String toString() {
    return 'Songbook(id: $id, name: $name, shortcut: $shortcut, color: $color, colorText: $colorText, isPrivate: $isPrivate, isPinned: $isPinned, records: $records)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Songbook &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortcut, shortcut) ||
                other.shortcut == shortcut) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.colorText, colorText) ||
                other.colorText == colorText) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            const DeepCollectionEquality().equals(other.records, records));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      shortcut,
      color,
      colorText,
      isPrivate,
      isPinned,
      const DeepCollectionEquality().hash(records));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SongbookCopyWith<_$_Songbook> get copyWith =>
      __$$_SongbookCopyWithImpl<_$_Songbook>(this, _$identity);
}

abstract class _Songbook extends Songbook {
  const factory _Songbook(
      {@Id(assignable: true)
      @JsonKey(fromJson: int.parse)
          required final int id,
      required final String name,
      @JsonKey(defaultValue: '')
          required final String shortcut,
      final String? color,
      final String? colorText,
      required final bool isPrivate,
      @Deprecated('is handled independently on model')
          final bool? isPinned,
      @Backlink()
      @JsonKey(fromJson: _songbookRecordsFromJson)
          required final ToMany<SongbookRecord> records}) = _$_Songbook;
  const _Songbook._() : super._();

  factory _Songbook.fromJson(Map<String, dynamic> json) = _$_Songbook.fromJson;

  @override
  @Id(assignable: true)
  @JsonKey(fromJson: int.parse)
  int get id;
  @override
  String get name;
  @override
  @JsonKey(defaultValue: '')
  String get shortcut;
  @override
  String? get color;
  @override
  String? get colorText;
  @override
  bool get isPrivate;
  @override
  @Deprecated('is handled independently on model')
  bool? get isPinned;
  @override
  @Backlink()
  @JsonKey(fromJson: _songbookRecordsFromJson)
  ToMany<SongbookRecord> get records;
  @override
  @JsonKey(ignore: true)
  _$$_SongbookCopyWith<_$_Songbook> get copyWith =>
      throw _privateConstructorUsedError;
}
