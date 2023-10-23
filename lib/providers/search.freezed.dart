// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SearchedSongLyricsResult {
  List<SongLyric>? get songLyrics => throw _privateConstructorUsedError;
  String? get searchedNumber => throw _privateConstructorUsedError;
  SongLyric? get matchedById => throw _privateConstructorUsedError;
  List<SongLyric> get matchedBySongbookNumber =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchedSongLyricsResultCopyWith<SearchedSongLyricsResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchedSongLyricsResultCopyWith<$Res> {
  factory $SearchedSongLyricsResultCopyWith(SearchedSongLyricsResult value,
          $Res Function(SearchedSongLyricsResult) then) =
      _$SearchedSongLyricsResultCopyWithImpl<$Res, SearchedSongLyricsResult>;
  @useResult
  $Res call(
      {List<SongLyric>? songLyrics,
      String? searchedNumber,
      SongLyric? matchedById,
      List<SongLyric> matchedBySongbookNumber});

  $SongLyricCopyWith<$Res>? get matchedById;
}

/// @nodoc
class _$SearchedSongLyricsResultCopyWithImpl<$Res,
        $Val extends SearchedSongLyricsResult>
    implements $SearchedSongLyricsResultCopyWith<$Res> {
  _$SearchedSongLyricsResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyrics = freezed,
    Object? searchedNumber = freezed,
    Object? matchedById = freezed,
    Object? matchedBySongbookNumber = null,
  }) {
    return _then(_value.copyWith(
      songLyrics: freezed == songLyrics
          ? _value.songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>?,
      searchedNumber: freezed == searchedNumber
          ? _value.searchedNumber
          : searchedNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      matchedById: freezed == matchedById
          ? _value.matchedById
          : matchedById // ignore: cast_nullable_to_non_nullable
              as SongLyric?,
      matchedBySongbookNumber: null == matchedBySongbookNumber
          ? _value.matchedBySongbookNumber
          : matchedBySongbookNumber // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SongLyricCopyWith<$Res>? get matchedById {
    if (_value.matchedById == null) {
      return null;
    }

    return $SongLyricCopyWith<$Res>(_value.matchedById!, (value) {
      return _then(_value.copyWith(matchedById: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchedSongLyricsResultImplCopyWith<$Res>
    implements $SearchedSongLyricsResultCopyWith<$Res> {
  factory _$$SearchedSongLyricsResultImplCopyWith(
          _$SearchedSongLyricsResultImpl value,
          $Res Function(_$SearchedSongLyricsResultImpl) then) =
      __$$SearchedSongLyricsResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SongLyric>? songLyrics,
      String? searchedNumber,
      SongLyric? matchedById,
      List<SongLyric> matchedBySongbookNumber});

  @override
  $SongLyricCopyWith<$Res>? get matchedById;
}

/// @nodoc
class __$$SearchedSongLyricsResultImplCopyWithImpl<$Res>
    extends _$SearchedSongLyricsResultCopyWithImpl<$Res,
        _$SearchedSongLyricsResultImpl>
    implements _$$SearchedSongLyricsResultImplCopyWith<$Res> {
  __$$SearchedSongLyricsResultImplCopyWithImpl(
      _$SearchedSongLyricsResultImpl _value,
      $Res Function(_$SearchedSongLyricsResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyrics = freezed,
    Object? searchedNumber = freezed,
    Object? matchedById = freezed,
    Object? matchedBySongbookNumber = null,
  }) {
    return _then(_$SearchedSongLyricsResultImpl(
      songLyrics: freezed == songLyrics
          ? _value._songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>?,
      searchedNumber: freezed == searchedNumber
          ? _value.searchedNumber
          : searchedNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      matchedById: freezed == matchedById
          ? _value.matchedById
          : matchedById // ignore: cast_nullable_to_non_nullable
              as SongLyric?,
      matchedBySongbookNumber: null == matchedBySongbookNumber
          ? _value._matchedBySongbookNumber
          : matchedBySongbookNumber // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>,
    ));
  }
}

/// @nodoc

class _$SearchedSongLyricsResultImpl implements _SearchedSongLyricsResult {
  const _$SearchedSongLyricsResultImpl(
      {final List<SongLyric>? songLyrics,
      this.searchedNumber,
      this.matchedById,
      final List<SongLyric> matchedBySongbookNumber = const []})
      : _songLyrics = songLyrics,
        _matchedBySongbookNumber = matchedBySongbookNumber;

  final List<SongLyric>? _songLyrics;
  @override
  List<SongLyric>? get songLyrics {
    final value = _songLyrics;
    if (value == null) return null;
    if (_songLyrics is EqualUnmodifiableListView) return _songLyrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? searchedNumber;
  @override
  final SongLyric? matchedById;
  final List<SongLyric> _matchedBySongbookNumber;
  @override
  @JsonKey()
  List<SongLyric> get matchedBySongbookNumber {
    if (_matchedBySongbookNumber is EqualUnmodifiableListView)
      return _matchedBySongbookNumber;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchedBySongbookNumber);
  }

  @override
  String toString() {
    return 'SearchedSongLyricsResult(songLyrics: $songLyrics, searchedNumber: $searchedNumber, matchedById: $matchedById, matchedBySongbookNumber: $matchedBySongbookNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchedSongLyricsResultImpl &&
            const DeepCollectionEquality()
                .equals(other._songLyrics, _songLyrics) &&
            (identical(other.searchedNumber, searchedNumber) ||
                other.searchedNumber == searchedNumber) &&
            (identical(other.matchedById, matchedById) ||
                other.matchedById == matchedById) &&
            const DeepCollectionEquality().equals(
                other._matchedBySongbookNumber, _matchedBySongbookNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_songLyrics),
      searchedNumber,
      matchedById,
      const DeepCollectionEquality().hash(_matchedBySongbookNumber));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchedSongLyricsResultImplCopyWith<_$SearchedSongLyricsResultImpl>
      get copyWith => __$$SearchedSongLyricsResultImplCopyWithImpl<
          _$SearchedSongLyricsResultImpl>(this, _$identity);
}

abstract class _SearchedSongLyricsResult implements SearchedSongLyricsResult {
  const factory _SearchedSongLyricsResult(
          {final List<SongLyric>? songLyrics,
          final String? searchedNumber,
          final SongLyric? matchedById,
          final List<SongLyric> matchedBySongbookNumber}) =
      _$SearchedSongLyricsResultImpl;

  @override
  List<SongLyric>? get songLyrics;
  @override
  String? get searchedNumber;
  @override
  SongLyric? get matchedById;
  @override
  List<SongLyric> get matchedBySongbookNumber;
  @override
  @JsonKey(ignore: true)
  _$$SearchedSongLyricsResultImplCopyWith<_$SearchedSongLyricsResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
