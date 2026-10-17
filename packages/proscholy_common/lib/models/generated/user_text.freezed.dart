// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../user_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserText {

@Id(assignable: true) int get id; String get name; String get content;
/// Create a copy of UserText
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserTextCopyWith<UserText> get copyWith => _$UserTextCopyWithImpl<UserText>(this as UserText, _$identity);





@override
String toString() {
  return 'UserText(id: $id, name: $name, content: $content)';
}


}

/// @nodoc
abstract mixin class $UserTextCopyWith<$Res>  {
  factory $UserTextCopyWith(UserText value, $Res Function(UserText) _then) = _$UserTextCopyWithImpl;
@useResult
$Res call({
@Id(assignable: true) int id, String name, String content
});




}
/// @nodoc
class _$UserTextCopyWithImpl<$Res>
    implements $UserTextCopyWith<$Res> {
  _$UserTextCopyWithImpl(this._self, this._then);

  final UserText _self;
  final $Res Function(UserText) _then;

/// Create a copy of UserText
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? content = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserText].
extension UserTextPatterns on UserText {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserText value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserText() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserText value)  $default,){
final _that = this;
switch (_that) {
case _UserText():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserText value)?  $default,){
final _that = this;
switch (_that) {
case _UserText() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@Id(assignable: true)  int id,  String name,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserText() when $default != null:
return $default(_that.id,_that.name,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@Id(assignable: true)  int id,  String name,  String content)  $default,) {final _that = this;
switch (_that) {
case _UserText():
return $default(_that.id,_that.name,_that.content);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@Id(assignable: true)  int id,  String name,  String content)?  $default,) {final _that = this;
switch (_that) {
case _UserText() when $default != null:
return $default(_that.id,_that.name,_that.content);case _:
  return null;

}
}

}

/// @nodoc

@Entity(realClass: UserText)
class _UserText extends UserText {
  const _UserText({@Id(assignable: true) required this.id, required this.name, required this.content}): super._();
  

@override@Id(assignable: true) final  int id;
@override final  String name;
@override final  String content;

/// Create a copy of UserText
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserTextCopyWith<_UserText> get copyWith => __$UserTextCopyWithImpl<_UserText>(this, _$identity);





@override
String toString() {
  return 'UserText(id: $id, name: $name, content: $content)';
}


}

/// @nodoc
abstract mixin class _$UserTextCopyWith<$Res> implements $UserTextCopyWith<$Res> {
  factory _$UserTextCopyWith(_UserText value, $Res Function(_UserText) _then) = __$UserTextCopyWithImpl;
@override @useResult
$Res call({
@Id(assignable: true) int id, String name, String content
});




}
/// @nodoc
class __$UserTextCopyWithImpl<$Res>
    implements _$UserTextCopyWith<$Res> {
  __$UserTextCopyWithImpl(this._self, this._then);

  final _UserText _self;
  final $Res Function(_UserText) _then;

/// Create a copy of UserText
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? content = null,}) {
  return _then(_UserText(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
