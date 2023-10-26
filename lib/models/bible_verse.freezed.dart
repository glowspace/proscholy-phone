// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bible_verse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BibleVerse {
  @Id(assignable: true)
  int get id => throw _privateConstructorUsedError;
  int get book => throw _privateConstructorUsedError;
  int get chapter => throw _privateConstructorUsedError;
  int get startVerse => throw _privateConstructorUsedError;
  int? get endVerse => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleVerseCopyWith<BibleVerse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleVerseCopyWith<$Res> {
  factory $BibleVerseCopyWith(
          BibleVerse value, $Res Function(BibleVerse) then) =
      _$BibleVerseCopyWithImpl<$Res, BibleVerse>;
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      int book,
      int chapter,
      int startVerse,
      int? endVerse,
      String text});
}

/// @nodoc
class _$BibleVerseCopyWithImpl<$Res, $Val extends BibleVerse>
    implements $BibleVerseCopyWith<$Res> {
  _$BibleVerseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? book = null,
    Object? chapter = null,
    Object? startVerse = null,
    Object? endVerse = freezed,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      book: null == book
          ? _value.book
          : book // ignore: cast_nullable_to_non_nullable
              as int,
      chapter: null == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int,
      startVerse: null == startVerse
          ? _value.startVerse
          : startVerse // ignore: cast_nullable_to_non_nullable
              as int,
      endVerse: freezed == endVerse
          ? _value.endVerse
          : endVerse // ignore: cast_nullable_to_non_nullable
              as int?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleVerseImplCopyWith<$Res>
    implements $BibleVerseCopyWith<$Res> {
  factory _$$BibleVerseImplCopyWith(
          _$BibleVerseImpl value, $Res Function(_$BibleVerseImpl) then) =
      __$$BibleVerseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      int book,
      int chapter,
      int startVerse,
      int? endVerse,
      String text});
}

/// @nodoc
class __$$BibleVerseImplCopyWithImpl<$Res>
    extends _$BibleVerseCopyWithImpl<$Res, _$BibleVerseImpl>
    implements _$$BibleVerseImplCopyWith<$Res> {
  __$$BibleVerseImplCopyWithImpl(
      _$BibleVerseImpl _value, $Res Function(_$BibleVerseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? book = null,
    Object? chapter = null,
    Object? startVerse = null,
    Object? endVerse = freezed,
    Object? text = null,
  }) {
    return _then(_$BibleVerseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      book: null == book
          ? _value.book
          : book // ignore: cast_nullable_to_non_nullable
              as int,
      chapter: null == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int,
      startVerse: null == startVerse
          ? _value.startVerse
          : startVerse // ignore: cast_nullable_to_non_nullable
              as int,
      endVerse: freezed == endVerse
          ? _value.endVerse
          : endVerse // ignore: cast_nullable_to_non_nullable
              as int?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@Entity(realClass: BibleVerse)
class _$BibleVerseImpl extends _BibleVerse {
  const _$BibleVerseImpl(
      {@Id(assignable: true) required this.id,
      required this.book,
      required this.chapter,
      required this.startVerse,
      this.endVerse,
      required this.text})
      : super._();

  @override
  @Id(assignable: true)
  final int id;
  @override
  final int book;
  @override
  final int chapter;
  @override
  final int startVerse;
  @override
  final int? endVerse;
  @override
  final String text;

  @override
  String toString() {
    return 'BibleVerse(id: $id, book: $book, chapter: $chapter, startVerse: $startVerse, endVerse: $endVerse, text: $text)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleVerseImplCopyWith<_$BibleVerseImpl> get copyWith =>
      __$$BibleVerseImplCopyWithImpl<_$BibleVerseImpl>(this, _$identity);
}

abstract class _BibleVerse extends BibleVerse {
  const factory _BibleVerse(
      {@Id(assignable: true) required final int id,
      required final int book,
      required final int chapter,
      required final int startVerse,
      final int? endVerse,
      required final String text}) = _$BibleVerseImpl;
  const _BibleVerse._() : super._();

  @override
  @Id(assignable: true)
  int get id;
  @override
  int get book;
  @override
  int get chapter;
  @override
  int get startVerse;
  @override
  int? get endVerse;
  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$BibleVerseImplCopyWith<_$BibleVerseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
