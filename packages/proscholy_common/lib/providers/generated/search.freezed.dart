// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchedSongLyricsResult {
  List<SongLyric>? get songLyrics;
  String? get searchedNumber;
  SongLyric? get matchedById;
  List<SongLyric> get matchedBySongbookNumber;

  /// Create a copy of SearchedSongLyricsResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchedSongLyricsResultCopyWith<SearchedSongLyricsResult> get copyWith =>
      _$SearchedSongLyricsResultCopyWithImpl<SearchedSongLyricsResult>(
          this as SearchedSongLyricsResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchedSongLyricsResult &&
            const DeepCollectionEquality()
                .equals(other.songLyrics, songLyrics) &&
            (identical(other.searchedNumber, searchedNumber) ||
                other.searchedNumber == searchedNumber) &&
            (identical(other.matchedById, matchedById) ||
                other.matchedById == matchedById) &&
            const DeepCollectionEquality().equals(
                other.matchedBySongbookNumber, matchedBySongbookNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(songLyrics),
      searchedNumber,
      matchedById,
      const DeepCollectionEquality().hash(matchedBySongbookNumber));

  @override
  String toString() {
    return 'SearchedSongLyricsResult(songLyrics: $songLyrics, searchedNumber: $searchedNumber, matchedById: $matchedById, matchedBySongbookNumber: $matchedBySongbookNumber)';
  }
}

/// @nodoc
abstract mixin class $SearchedSongLyricsResultCopyWith<$Res> {
  factory $SearchedSongLyricsResultCopyWith(SearchedSongLyricsResult value,
          $Res Function(SearchedSongLyricsResult) _then) =
      _$SearchedSongLyricsResultCopyWithImpl;
  @useResult
  $Res call(
      {List<SongLyric>? songLyrics,
      String? searchedNumber,
      SongLyric? matchedById,
      List<SongLyric> matchedBySongbookNumber});

  $SongLyricCopyWith<$Res>? get matchedById;
}

/// @nodoc
class _$SearchedSongLyricsResultCopyWithImpl<$Res>
    implements $SearchedSongLyricsResultCopyWith<$Res> {
  _$SearchedSongLyricsResultCopyWithImpl(this._self, this._then);

  final SearchedSongLyricsResult _self;
  final $Res Function(SearchedSongLyricsResult) _then;

  /// Create a copy of SearchedSongLyricsResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyrics = freezed,
    Object? searchedNumber = freezed,
    Object? matchedById = freezed,
    Object? matchedBySongbookNumber = null,
  }) {
    return _then(_self.copyWith(
      songLyrics: freezed == songLyrics
          ? _self.songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>?,
      searchedNumber: freezed == searchedNumber
          ? _self.searchedNumber
          : searchedNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      matchedById: freezed == matchedById
          ? _self.matchedById
          : matchedById // ignore: cast_nullable_to_non_nullable
              as SongLyric?,
      matchedBySongbookNumber: null == matchedBySongbookNumber
          ? _self.matchedBySongbookNumber
          : matchedBySongbookNumber // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>,
    ));
  }

  /// Create a copy of SearchedSongLyricsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SongLyricCopyWith<$Res>? get matchedById {
    if (_self.matchedById == null) {
      return null;
    }

    return $SongLyricCopyWith<$Res>(_self.matchedById!, (value) {
      return _then(_self.copyWith(matchedById: value));
    });
  }
}

/// @nodoc

class _SearchedSongLyricsResult implements SearchedSongLyricsResult {
  const _SearchedSongLyricsResult(
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

  /// Create a copy of SearchedSongLyricsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchedSongLyricsResultCopyWith<_SearchedSongLyricsResult> get copyWith =>
      __$SearchedSongLyricsResultCopyWithImpl<_SearchedSongLyricsResult>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchedSongLyricsResult &&
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

  @override
  String toString() {
    return 'SearchedSongLyricsResult(songLyrics: $songLyrics, searchedNumber: $searchedNumber, matchedById: $matchedById, matchedBySongbookNumber: $matchedBySongbookNumber)';
  }
}

/// @nodoc
abstract mixin class _$SearchedSongLyricsResultCopyWith<$Res>
    implements $SearchedSongLyricsResultCopyWith<$Res> {
  factory _$SearchedSongLyricsResultCopyWith(_SearchedSongLyricsResult value,
          $Res Function(_SearchedSongLyricsResult) _then) =
      __$SearchedSongLyricsResultCopyWithImpl;
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
class __$SearchedSongLyricsResultCopyWithImpl<$Res>
    implements _$SearchedSongLyricsResultCopyWith<$Res> {
  __$SearchedSongLyricsResultCopyWithImpl(this._self, this._then);

  final _SearchedSongLyricsResult _self;
  final $Res Function(_SearchedSongLyricsResult) _then;

  /// Create a copy of SearchedSongLyricsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? songLyrics = freezed,
    Object? searchedNumber = freezed,
    Object? matchedById = freezed,
    Object? matchedBySongbookNumber = null,
  }) {
    return _then(_SearchedSongLyricsResult(
      songLyrics: freezed == songLyrics
          ? _self._songLyrics
          : songLyrics // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>?,
      searchedNumber: freezed == searchedNumber
          ? _self.searchedNumber
          : searchedNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      matchedById: freezed == matchedById
          ? _self.matchedById
          : matchedById // ignore: cast_nullable_to_non_nullable
              as SongLyric?,
      matchedBySongbookNumber: null == matchedBySongbookNumber
          ? _self._matchedBySongbookNumber
          : matchedBySongbookNumber // ignore: cast_nullable_to_non_nullable
              as List<SongLyric>,
    ));
  }

  /// Create a copy of SearchedSongLyricsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SongLyricCopyWith<$Res>? get matchedById {
    if (_self.matchedById == null) {
      return null;
    }

    return $SongLyricCopyWith<$Res>(_self.matchedById!, (value) {
      return _then(_self.copyWith(matchedById: value));
    });
  }
}

// dart format on
