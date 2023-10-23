// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DisplayableItem {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BibleVerse bibleVerse) bibleVerse,
    required TResult Function(CustomText customText) customText,
    required TResult Function(SongLyric songLyric) songLyric,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BibleVerse bibleVerse)? bibleVerse,
    TResult? Function(CustomText customText)? customText,
    TResult? Function(SongLyric songLyric)? songLyric,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BibleVerse bibleVerse)? bibleVerse,
    TResult Function(CustomText customText)? customText,
    TResult Function(SongLyric songLyric)? songLyric,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BibleVerseItem value) bibleVerse,
    required TResult Function(CustomTextItem value) customText,
    required TResult Function(SongLyricItem value) songLyric,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BibleVerseItem value)? bibleVerse,
    TResult? Function(CustomTextItem value)? customText,
    TResult? Function(SongLyricItem value)? songLyric,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BibleVerseItem value)? bibleVerse,
    TResult Function(CustomTextItem value)? customText,
    TResult Function(SongLyricItem value)? songLyric,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DisplayableItemCopyWith<$Res> {
  factory $DisplayableItemCopyWith(
          DisplayableItem value, $Res Function(DisplayableItem) then) =
      _$DisplayableItemCopyWithImpl<$Res, DisplayableItem>;
}

/// @nodoc
class _$DisplayableItemCopyWithImpl<$Res, $Val extends DisplayableItem>
    implements $DisplayableItemCopyWith<$Res> {
  _$DisplayableItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BibleVerseItemImplCopyWith<$Res> {
  factory _$$BibleVerseItemImplCopyWith(_$BibleVerseItemImpl value,
          $Res Function(_$BibleVerseItemImpl) then) =
      __$$BibleVerseItemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BibleVerse bibleVerse});

  $BibleVerseCopyWith<$Res> get bibleVerse;
}

/// @nodoc
class __$$BibleVerseItemImplCopyWithImpl<$Res>
    extends _$DisplayableItemCopyWithImpl<$Res, _$BibleVerseItemImpl>
    implements _$$BibleVerseItemImplCopyWith<$Res> {
  __$$BibleVerseItemImplCopyWithImpl(
      _$BibleVerseItemImpl _value, $Res Function(_$BibleVerseItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bibleVerse = null,
  }) {
    return _then(_$BibleVerseItemImpl(
      null == bibleVerse
          ? _value.bibleVerse
          : bibleVerse // ignore: cast_nullable_to_non_nullable
              as BibleVerse,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $BibleVerseCopyWith<$Res> get bibleVerse {
    return $BibleVerseCopyWith<$Res>(_value.bibleVerse, (value) {
      return _then(_value.copyWith(bibleVerse: value));
    });
  }
}

/// @nodoc

class _$BibleVerseItemImpl extends BibleVerseItem {
  const _$BibleVerseItemImpl(this.bibleVerse) : super._();

  @override
  final BibleVerse bibleVerse;

  @override
  String toString() {
    return 'DisplayableItem.bibleVerse(bibleVerse: $bibleVerse)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleVerseItemImpl &&
            (identical(other.bibleVerse, bibleVerse) ||
                other.bibleVerse == bibleVerse));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bibleVerse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleVerseItemImplCopyWith<_$BibleVerseItemImpl> get copyWith =>
      __$$BibleVerseItemImplCopyWithImpl<_$BibleVerseItemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BibleVerse bibleVerse) bibleVerse,
    required TResult Function(CustomText customText) customText,
    required TResult Function(SongLyric songLyric) songLyric,
  }) {
    return bibleVerse(this.bibleVerse);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BibleVerse bibleVerse)? bibleVerse,
    TResult? Function(CustomText customText)? customText,
    TResult? Function(SongLyric songLyric)? songLyric,
  }) {
    return bibleVerse?.call(this.bibleVerse);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BibleVerse bibleVerse)? bibleVerse,
    TResult Function(CustomText customText)? customText,
    TResult Function(SongLyric songLyric)? songLyric,
    required TResult orElse(),
  }) {
    if (bibleVerse != null) {
      return bibleVerse(this.bibleVerse);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BibleVerseItem value) bibleVerse,
    required TResult Function(CustomTextItem value) customText,
    required TResult Function(SongLyricItem value) songLyric,
  }) {
    return bibleVerse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BibleVerseItem value)? bibleVerse,
    TResult? Function(CustomTextItem value)? customText,
    TResult? Function(SongLyricItem value)? songLyric,
  }) {
    return bibleVerse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BibleVerseItem value)? bibleVerse,
    TResult Function(CustomTextItem value)? customText,
    TResult Function(SongLyricItem value)? songLyric,
    required TResult orElse(),
  }) {
    if (bibleVerse != null) {
      return bibleVerse(this);
    }
    return orElse();
  }
}

abstract class BibleVerseItem extends DisplayableItem {
  const factory BibleVerseItem(final BibleVerse bibleVerse) =
      _$BibleVerseItemImpl;
  const BibleVerseItem._() : super._();

  BibleVerse get bibleVerse;
  @JsonKey(ignore: true)
  _$$BibleVerseItemImplCopyWith<_$BibleVerseItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CustomTextItemImplCopyWith<$Res> {
  factory _$$CustomTextItemImplCopyWith(_$CustomTextItemImpl value,
          $Res Function(_$CustomTextItemImpl) then) =
      __$$CustomTextItemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CustomText customText});

  $CustomTextCopyWith<$Res> get customText;
}

/// @nodoc
class __$$CustomTextItemImplCopyWithImpl<$Res>
    extends _$DisplayableItemCopyWithImpl<$Res, _$CustomTextItemImpl>
    implements _$$CustomTextItemImplCopyWith<$Res> {
  __$$CustomTextItemImplCopyWithImpl(
      _$CustomTextItemImpl _value, $Res Function(_$CustomTextItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customText = null,
  }) {
    return _then(_$CustomTextItemImpl(
      null == customText
          ? _value.customText
          : customText // ignore: cast_nullable_to_non_nullable
              as CustomText,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $CustomTextCopyWith<$Res> get customText {
    return $CustomTextCopyWith<$Res>(_value.customText, (value) {
      return _then(_value.copyWith(customText: value));
    });
  }
}

/// @nodoc

class _$CustomTextItemImpl extends CustomTextItem {
  const _$CustomTextItemImpl(this.customText) : super._();

  @override
  final CustomText customText;

  @override
  String toString() {
    return 'DisplayableItem.customText(customText: $customText)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomTextItemImpl &&
            (identical(other.customText, customText) ||
                other.customText == customText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, customText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomTextItemImplCopyWith<_$CustomTextItemImpl> get copyWith =>
      __$$CustomTextItemImplCopyWithImpl<_$CustomTextItemImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BibleVerse bibleVerse) bibleVerse,
    required TResult Function(CustomText customText) customText,
    required TResult Function(SongLyric songLyric) songLyric,
  }) {
    return customText(this.customText);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BibleVerse bibleVerse)? bibleVerse,
    TResult? Function(CustomText customText)? customText,
    TResult? Function(SongLyric songLyric)? songLyric,
  }) {
    return customText?.call(this.customText);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BibleVerse bibleVerse)? bibleVerse,
    TResult Function(CustomText customText)? customText,
    TResult Function(SongLyric songLyric)? songLyric,
    required TResult orElse(),
  }) {
    if (customText != null) {
      return customText(this.customText);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BibleVerseItem value) bibleVerse,
    required TResult Function(CustomTextItem value) customText,
    required TResult Function(SongLyricItem value) songLyric,
  }) {
    return customText(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BibleVerseItem value)? bibleVerse,
    TResult? Function(CustomTextItem value)? customText,
    TResult? Function(SongLyricItem value)? songLyric,
  }) {
    return customText?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BibleVerseItem value)? bibleVerse,
    TResult Function(CustomTextItem value)? customText,
    TResult Function(SongLyricItem value)? songLyric,
    required TResult orElse(),
  }) {
    if (customText != null) {
      return customText(this);
    }
    return orElse();
  }
}

abstract class CustomTextItem extends DisplayableItem {
  const factory CustomTextItem(final CustomText customText) =
      _$CustomTextItemImpl;
  const CustomTextItem._() : super._();

  CustomText get customText;
  @JsonKey(ignore: true)
  _$$CustomTextItemImplCopyWith<_$CustomTextItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SongLyricItemImplCopyWith<$Res> {
  factory _$$SongLyricItemImplCopyWith(
          _$SongLyricItemImpl value, $Res Function(_$SongLyricItemImpl) then) =
      __$$SongLyricItemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SongLyric songLyric});

  $SongLyricCopyWith<$Res> get songLyric;
}

/// @nodoc
class __$$SongLyricItemImplCopyWithImpl<$Res>
    extends _$DisplayableItemCopyWithImpl<$Res, _$SongLyricItemImpl>
    implements _$$SongLyricItemImplCopyWith<$Res> {
  __$$SongLyricItemImplCopyWithImpl(
      _$SongLyricItemImpl _value, $Res Function(_$SongLyricItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyric = null,
  }) {
    return _then(_$SongLyricItemImpl(
      null == songLyric
          ? _value.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as SongLyric,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $SongLyricCopyWith<$Res> get songLyric {
    return $SongLyricCopyWith<$Res>(_value.songLyric, (value) {
      return _then(_value.copyWith(songLyric: value));
    });
  }
}

/// @nodoc

class _$SongLyricItemImpl extends SongLyricItem {
  const _$SongLyricItemImpl(this.songLyric) : super._();

  @override
  final SongLyric songLyric;

  @override
  String toString() {
    return 'DisplayableItem.songLyric(songLyric: $songLyric)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongLyricItemImpl &&
            (identical(other.songLyric, songLyric) ||
                other.songLyric == songLyric));
  }

  @override
  int get hashCode => Object.hash(runtimeType, songLyric);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongLyricItemImplCopyWith<_$SongLyricItemImpl> get copyWith =>
      __$$SongLyricItemImplCopyWithImpl<_$SongLyricItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BibleVerse bibleVerse) bibleVerse,
    required TResult Function(CustomText customText) customText,
    required TResult Function(SongLyric songLyric) songLyric,
  }) {
    return songLyric(this.songLyric);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BibleVerse bibleVerse)? bibleVerse,
    TResult? Function(CustomText customText)? customText,
    TResult? Function(SongLyric songLyric)? songLyric,
  }) {
    return songLyric?.call(this.songLyric);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BibleVerse bibleVerse)? bibleVerse,
    TResult Function(CustomText customText)? customText,
    TResult Function(SongLyric songLyric)? songLyric,
    required TResult orElse(),
  }) {
    if (songLyric != null) {
      return songLyric(this.songLyric);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BibleVerseItem value) bibleVerse,
    required TResult Function(CustomTextItem value) customText,
    required TResult Function(SongLyricItem value) songLyric,
  }) {
    return songLyric(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BibleVerseItem value)? bibleVerse,
    TResult? Function(CustomTextItem value)? customText,
    TResult? Function(SongLyricItem value)? songLyric,
  }) {
    return songLyric?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BibleVerseItem value)? bibleVerse,
    TResult Function(CustomTextItem value)? customText,
    TResult Function(SongLyricItem value)? songLyric,
    required TResult orElse(),
  }) {
    if (songLyric != null) {
      return songLyric(this);
    }
    return orElse();
  }
}

abstract class SongLyricItem extends DisplayableItem {
  const factory SongLyricItem(final SongLyric songLyric) = _$SongLyricItemImpl;
  const SongLyricItem._() : super._();

  SongLyric get songLyric;
  @JsonKey(ignore: true)
  _$$SongLyricItemImplCopyWith<_$SongLyricItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
