// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_lyric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SongLyricScreenArguments {
  List<SongLyric> get songLyrics => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongLyricScreenArgumentsCopyWith<SongLyricScreenArguments> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongLyricScreenArgumentsCopyWith<$Res> {
  factory $SongLyricScreenArgumentsCopyWith(SongLyricScreenArguments value,
          $Res Function(SongLyricScreenArguments) then) =
      _$SongLyricScreenArgumentsCopyWithImpl<$Res, SongLyricScreenArguments>;
  @useResult
  $Res call({List<SongLyric> songLyrics, int index});
}

/// @nodoc
class _$SongLyricScreenArgumentsCopyWithImpl<$Res,
        $Val extends SongLyricScreenArguments>
    implements $SongLyricScreenArgumentsCopyWith<$Res> {
  _$SongLyricScreenArgumentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyrics = null,
    Object? index = null,
  }) {
    return _then(_value.copyWith(
      songLyrics: null == songLyrics
          ? _value.songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SongLyricScreenArgumentsCopyWith<$Res>
    implements $SongLyricScreenArgumentsCopyWith<$Res> {
  factory _$$_SongLyricScreenArgumentsCopyWith(
          _$_SongLyricScreenArguments value,
          $Res Function(_$_SongLyricScreenArguments) then) =
      __$$_SongLyricScreenArgumentsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SongLyric> songLyrics, int index});
}

/// @nodoc
class __$$_SongLyricScreenArgumentsCopyWithImpl<$Res>
    extends _$SongLyricScreenArgumentsCopyWithImpl<$Res,
        _$_SongLyricScreenArguments>
    implements _$$_SongLyricScreenArgumentsCopyWith<$Res> {
  __$$_SongLyricScreenArgumentsCopyWithImpl(_$_SongLyricScreenArguments _value,
      $Res Function(_$_SongLyricScreenArguments) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyrics = null,
    Object? index = null,
  }) {
    return _then(_$_SongLyricScreenArguments(
      songLyrics: null == songLyrics
          ? _value._songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_SongLyricScreenArguments implements _SongLyricScreenArguments {
  const _$_SongLyricScreenArguments(
      {required final List<SongLyric> songLyrics, this.index = 0})
      : _songLyrics = songLyrics;

  final List<SongLyric> _songLyrics;
  @override
  List<SongLyric> get songLyrics {
    if (_songLyrics is EqualUnmodifiableListView) return _songLyrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songLyrics);
  }

  @override
  @JsonKey()
  final int index;

  @override
  String toString() {
    return 'SongLyricScreenArguments(songLyrics: $songLyrics, index: $index)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SongLyricScreenArguments &&
            const DeepCollectionEquality()
                .equals(other._songLyrics, _songLyrics) &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_songLyrics), index);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SongLyricScreenArgumentsCopyWith<_$_SongLyricScreenArguments>
      get copyWith => __$$_SongLyricScreenArgumentsCopyWithImpl<
          _$_SongLyricScreenArguments>(this, _$identity);
}

abstract class _SongLyricScreenArguments implements SongLyricScreenArguments {
  const factory _SongLyricScreenArguments(
      {required final List<SongLyric> songLyrics,
      final int index}) = _$_SongLyricScreenArguments;

  @override
  List<SongLyric> get songLyrics;
  @override
  int get index;
  @override
  @JsonKey(ignore: true)
  _$$_SongLyricScreenArgumentsCopyWith<_$_SongLyricScreenArguments>
      get copyWith => throw _privateConstructorUsedError;
}
