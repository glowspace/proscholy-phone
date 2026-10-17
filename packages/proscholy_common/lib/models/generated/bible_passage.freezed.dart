// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../bible_passage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BiblePassage {

@Id(assignable: true) int get id; int get book; int get chapter; int get startVerse; int? get endVerse; String get text;
/// Create a copy of BiblePassage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BiblePassageCopyWith<BiblePassage> get copyWith => _$BiblePassageCopyWithImpl<BiblePassage>(this as BiblePassage, _$identity);





@override
String toString() {
  return 'BiblePassage(id: $id, book: $book, chapter: $chapter, startVerse: $startVerse, endVerse: $endVerse, text: $text)';
}


}

/// @nodoc
abstract mixin class $BiblePassageCopyWith<$Res>  {
  factory $BiblePassageCopyWith(BiblePassage value, $Res Function(BiblePassage) _then) = _$BiblePassageCopyWithImpl;
@useResult
$Res call({
@Id(assignable: true) int id, int book, int chapter, int startVerse, int? endVerse, String text
});




}
/// @nodoc
class _$BiblePassageCopyWithImpl<$Res>
    implements $BiblePassageCopyWith<$Res> {
  _$BiblePassageCopyWithImpl(this._self, this._then);

  final BiblePassage _self;
  final $Res Function(BiblePassage) _then;

/// Create a copy of BiblePassage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? book = null,Object? chapter = null,Object? startVerse = null,Object? endVerse = freezed,Object? text = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as int,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,startVerse: null == startVerse ? _self.startVerse : startVerse // ignore: cast_nullable_to_non_nullable
as int,endVerse: freezed == endVerse ? _self.endVerse : endVerse // ignore: cast_nullable_to_non_nullable
as int?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BiblePassage].
extension BiblePassagePatterns on BiblePassage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BiblePassage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BiblePassage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BiblePassage value)  $default,){
final _that = this;
switch (_that) {
case _BiblePassage():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BiblePassage value)?  $default,){
final _that = this;
switch (_that) {
case _BiblePassage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@Id(assignable: true)  int id,  int book,  int chapter,  int startVerse,  int? endVerse,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BiblePassage() when $default != null:
return $default(_that.id,_that.book,_that.chapter,_that.startVerse,_that.endVerse,_that.text);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@Id(assignable: true)  int id,  int book,  int chapter,  int startVerse,  int? endVerse,  String text)  $default,) {final _that = this;
switch (_that) {
case _BiblePassage():
return $default(_that.id,_that.book,_that.chapter,_that.startVerse,_that.endVerse,_that.text);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@Id(assignable: true)  int id,  int book,  int chapter,  int startVerse,  int? endVerse,  String text)?  $default,) {final _that = this;
switch (_that) {
case _BiblePassage() when $default != null:
return $default(_that.id,_that.book,_that.chapter,_that.startVerse,_that.endVerse,_that.text);case _:
  return null;

}
}

}

/// @nodoc

@Entity(realClass: BiblePassage)
class _BiblePassage extends BiblePassage {
  const _BiblePassage({@Id(assignable: true) required this.id, required this.book, required this.chapter, required this.startVerse, this.endVerse, required this.text}): super._();
  

@override@Id(assignable: true) final  int id;
@override final  int book;
@override final  int chapter;
@override final  int startVerse;
@override final  int? endVerse;
@override final  String text;

/// Create a copy of BiblePassage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BiblePassageCopyWith<_BiblePassage> get copyWith => __$BiblePassageCopyWithImpl<_BiblePassage>(this, _$identity);





@override
String toString() {
  return 'BiblePassage(id: $id, book: $book, chapter: $chapter, startVerse: $startVerse, endVerse: $endVerse, text: $text)';
}


}

/// @nodoc
abstract mixin class _$BiblePassageCopyWith<$Res> implements $BiblePassageCopyWith<$Res> {
  factory _$BiblePassageCopyWith(_BiblePassage value, $Res Function(_BiblePassage) _then) = __$BiblePassageCopyWithImpl;
@override @useResult
$Res call({
@Id(assignable: true) int id, int book, int chapter, int startVerse, int? endVerse, String text
});




}
/// @nodoc
class __$BiblePassageCopyWithImpl<$Res>
    implements _$BiblePassageCopyWith<$Res> {
  __$BiblePassageCopyWithImpl(this._self, this._then);

  final _BiblePassage _self;
  final $Res Function(_BiblePassage) _then;

/// Create a copy of BiblePassage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? book = null,Object? chapter = null,Object? startVerse = null,Object? endVerse = freezed,Object? text = null,}) {
  return _then(_BiblePassage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as int,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,startVerse: null == startVerse ? _self.startVerse : startVerse // ignore: cast_nullable_to_non_nullable
as int,endVerse: freezed == endVerse ? _self.endVerse : endVerse // ignore: cast_nullable_to_non_nullable
as int?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
