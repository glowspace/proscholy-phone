// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GlobalSettings {
  bool? get darkModeEnabled;
  int get seedColor;
  double get fontSizeScale;
  bool get showChords;
  bool get showMusicalNotes;
  int get accidentals;
  int get autoScrollSpeedIndex;

  /// Create a copy of GlobalSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GlobalSettingsCopyWith<GlobalSettings> get copyWith =>
      _$GlobalSettingsCopyWithImpl<GlobalSettings>(
          this as GlobalSettings, _$identity);

  /// Serializes this GlobalSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GlobalSettings &&
            (identical(other.darkModeEnabled, darkModeEnabled) ||
                other.darkModeEnabled == darkModeEnabled) &&
            (identical(other.seedColor, seedColor) ||
                other.seedColor == seedColor) &&
            (identical(other.fontSizeScale, fontSizeScale) ||
                other.fontSizeScale == fontSizeScale) &&
            (identical(other.showChords, showChords) ||
                other.showChords == showChords) &&
            (identical(other.showMusicalNotes, showMusicalNotes) ||
                other.showMusicalNotes == showMusicalNotes) &&
            (identical(other.accidentals, accidentals) ||
                other.accidentals == accidentals) &&
            (identical(other.autoScrollSpeedIndex, autoScrollSpeedIndex) ||
                other.autoScrollSpeedIndex == autoScrollSpeedIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      darkModeEnabled,
      seedColor,
      fontSizeScale,
      showChords,
      showMusicalNotes,
      accidentals,
      autoScrollSpeedIndex);

  @override
  String toString() {
    return 'GlobalSettings(darkModeEnabled: $darkModeEnabled, seedColor: $seedColor, fontSizeScale: $fontSizeScale, showChords: $showChords, showMusicalNotes: $showMusicalNotes, accidentals: $accidentals, autoScrollSpeedIndex: $autoScrollSpeedIndex)';
  }
}

/// @nodoc
abstract mixin class $GlobalSettingsCopyWith<$Res> {
  factory $GlobalSettingsCopyWith(
          GlobalSettings value, $Res Function(GlobalSettings) _then) =
      _$GlobalSettingsCopyWithImpl;
  @useResult
  $Res call(
      {bool? darkModeEnabled,
      int seedColor,
      double fontSizeScale,
      bool showChords,
      bool showMusicalNotes,
      int accidentals,
      int autoScrollSpeedIndex});
}

/// @nodoc
class _$GlobalSettingsCopyWithImpl<$Res>
    implements $GlobalSettingsCopyWith<$Res> {
  _$GlobalSettingsCopyWithImpl(this._self, this._then);

  final GlobalSettings _self;
  final $Res Function(GlobalSettings) _then;

  /// Create a copy of GlobalSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? darkModeEnabled = freezed,
    Object? seedColor = null,
    Object? fontSizeScale = null,
    Object? showChords = null,
    Object? showMusicalNotes = null,
    Object? accidentals = null,
    Object? autoScrollSpeedIndex = null,
  }) {
    return _then(_self.copyWith(
      darkModeEnabled: freezed == darkModeEnabled
          ? _self.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      seedColor: null == seedColor
          ? _self.seedColor
          : seedColor // ignore: cast_nullable_to_non_nullable
              as int,
      fontSizeScale: null == fontSizeScale
          ? _self.fontSizeScale
          : fontSizeScale // ignore: cast_nullable_to_non_nullable
              as double,
      showChords: null == showChords
          ? _self.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      showMusicalNotes: null == showMusicalNotes
          ? _self.showMusicalNotes
          : showMusicalNotes // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _self.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
      autoScrollSpeedIndex: null == autoScrollSpeedIndex
          ? _self.autoScrollSpeedIndex
          : autoScrollSpeedIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [GlobalSettings].
extension GlobalSettingsPatterns on GlobalSettings {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GlobalSettings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GlobalSettings() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GlobalSettings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GlobalSettings():
        return $default(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GlobalSettings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GlobalSettings() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            bool? darkModeEnabled,
            int seedColor,
            double fontSizeScale,
            bool showChords,
            bool showMusicalNotes,
            int accidentals,
            int autoScrollSpeedIndex)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GlobalSettings() when $default != null:
        return $default(
            _that.darkModeEnabled,
            _that.seedColor,
            _that.fontSizeScale,
            _that.showChords,
            _that.showMusicalNotes,
            _that.accidentals,
            _that.autoScrollSpeedIndex);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            bool? darkModeEnabled,
            int seedColor,
            double fontSizeScale,
            bool showChords,
            bool showMusicalNotes,
            int accidentals,
            int autoScrollSpeedIndex)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GlobalSettings():
        return $default(
            _that.darkModeEnabled,
            _that.seedColor,
            _that.fontSizeScale,
            _that.showChords,
            _that.showMusicalNotes,
            _that.accidentals,
            _that.autoScrollSpeedIndex);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            bool? darkModeEnabled,
            int seedColor,
            double fontSizeScale,
            bool showChords,
            bool showMusicalNotes,
            int accidentals,
            int autoScrollSpeedIndex)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GlobalSettings() when $default != null:
        return $default(
            _that.darkModeEnabled,
            _that.seedColor,
            _that.fontSizeScale,
            _that.showChords,
            _that.showMusicalNotes,
            _that.accidentals,
            _that.autoScrollSpeedIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GlobalSettings implements GlobalSettings {
  const _GlobalSettings(
      {this.darkModeEnabled,
      required this.seedColor,
      required this.fontSizeScale,
      required this.showChords,
      required this.showMusicalNotes,
      required this.accidentals,
      required this.autoScrollSpeedIndex});
  factory _GlobalSettings.fromJson(Map<String, dynamic> json) =>
      _$GlobalSettingsFromJson(json);

  @override
  final bool? darkModeEnabled;
  @override
  final int seedColor;
  @override
  final double fontSizeScale;
  @override
  final bool showChords;
  @override
  final bool showMusicalNotes;
  @override
  final int accidentals;
  @override
  final int autoScrollSpeedIndex;

  /// Create a copy of GlobalSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GlobalSettingsCopyWith<_GlobalSettings> get copyWith =>
      __$GlobalSettingsCopyWithImpl<_GlobalSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GlobalSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GlobalSettings &&
            (identical(other.darkModeEnabled, darkModeEnabled) ||
                other.darkModeEnabled == darkModeEnabled) &&
            (identical(other.seedColor, seedColor) ||
                other.seedColor == seedColor) &&
            (identical(other.fontSizeScale, fontSizeScale) ||
                other.fontSizeScale == fontSizeScale) &&
            (identical(other.showChords, showChords) ||
                other.showChords == showChords) &&
            (identical(other.showMusicalNotes, showMusicalNotes) ||
                other.showMusicalNotes == showMusicalNotes) &&
            (identical(other.accidentals, accidentals) ||
                other.accidentals == accidentals) &&
            (identical(other.autoScrollSpeedIndex, autoScrollSpeedIndex) ||
                other.autoScrollSpeedIndex == autoScrollSpeedIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      darkModeEnabled,
      seedColor,
      fontSizeScale,
      showChords,
      showMusicalNotes,
      accidentals,
      autoScrollSpeedIndex);

  @override
  String toString() {
    return 'GlobalSettings(darkModeEnabled: $darkModeEnabled, seedColor: $seedColor, fontSizeScale: $fontSizeScale, showChords: $showChords, showMusicalNotes: $showMusicalNotes, accidentals: $accidentals, autoScrollSpeedIndex: $autoScrollSpeedIndex)';
  }
}

/// @nodoc
abstract mixin class _$GlobalSettingsCopyWith<$Res>
    implements $GlobalSettingsCopyWith<$Res> {
  factory _$GlobalSettingsCopyWith(
          _GlobalSettings value, $Res Function(_GlobalSettings) _then) =
      __$GlobalSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool? darkModeEnabled,
      int seedColor,
      double fontSizeScale,
      bool showChords,
      bool showMusicalNotes,
      int accidentals,
      int autoScrollSpeedIndex});
}

/// @nodoc
class __$GlobalSettingsCopyWithImpl<$Res>
    implements _$GlobalSettingsCopyWith<$Res> {
  __$GlobalSettingsCopyWithImpl(this._self, this._then);

  final _GlobalSettings _self;
  final $Res Function(_GlobalSettings) _then;

  /// Create a copy of GlobalSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? darkModeEnabled = freezed,
    Object? seedColor = null,
    Object? fontSizeScale = null,
    Object? showChords = null,
    Object? showMusicalNotes = null,
    Object? accidentals = null,
    Object? autoScrollSpeedIndex = null,
  }) {
    return _then(_GlobalSettings(
      darkModeEnabled: freezed == darkModeEnabled
          ? _self.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      seedColor: null == seedColor
          ? _self.seedColor
          : seedColor // ignore: cast_nullable_to_non_nullable
              as int,
      fontSizeScale: null == fontSizeScale
          ? _self.fontSizeScale
          : fontSizeScale // ignore: cast_nullable_to_non_nullable
              as double,
      showChords: null == showChords
          ? _self.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      showMusicalNotes: null == showMusicalNotes
          ? _self.showMusicalNotes
          : showMusicalNotes // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _self.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
      autoScrollSpeedIndex: null == autoScrollSpeedIndex
          ? _self.autoScrollSpeedIndex
          : autoScrollSpeedIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$SongLyricSettingsModel {
  @Id(assignable: true)
  int get id;
  bool get showChords;
  bool get showMusicalNotes;
  int? get accidentals;
  int get transposition;
  ToOne<SongLyric> get songLyric;

  /// Create a copy of SongLyricSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SongLyricSettingsModelCopyWith<SongLyricSettingsModel> get copyWith =>
      _$SongLyricSettingsModelCopyWithImpl<SongLyricSettingsModel>(
          this as SongLyricSettingsModel, _$identity);

  @override
  String toString() {
    return 'SongLyricSettingsModel(id: $id, showChords: $showChords, showMusicalNotes: $showMusicalNotes, accidentals: $accidentals, transposition: $transposition, songLyric: $songLyric)';
  }
}

/// @nodoc
abstract mixin class $SongLyricSettingsModelCopyWith<$Res> {
  factory $SongLyricSettingsModelCopyWith(SongLyricSettingsModel value,
          $Res Function(SongLyricSettingsModel) _then) =
      _$SongLyricSettingsModelCopyWithImpl;
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      bool showChords,
      bool showMusicalNotes,
      int? accidentals,
      int transposition,
      ToOne<SongLyric> songLyric});
}

/// @nodoc
class _$SongLyricSettingsModelCopyWithImpl<$Res>
    implements $SongLyricSettingsModelCopyWith<$Res> {
  _$SongLyricSettingsModelCopyWithImpl(this._self, this._then);

  final SongLyricSettingsModel _self;
  final $Res Function(SongLyricSettingsModel) _then;

  /// Create a copy of SongLyricSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? showChords = null,
    Object? showMusicalNotes = null,
    Object? accidentals = freezed,
    Object? transposition = null,
    Object? songLyric = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      showChords: null == showChords
          ? _self.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      showMusicalNotes: null == showMusicalNotes
          ? _self.showMusicalNotes
          : showMusicalNotes // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: freezed == accidentals
          ? _self.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int?,
      transposition: null == transposition
          ? _self.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _self.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SongLyricSettingsModel].
extension SongLyricSettingsModelPatterns on SongLyricSettingsModel {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SongLyricSettingsModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SongLyricSettingsModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SongLyricSettingsModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongLyricSettingsModel():
        return $default(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SongLyricSettingsModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongLyricSettingsModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @Id(assignable: true) int id,
            bool showChords,
            bool showMusicalNotes,
            int? accidentals,
            int transposition,
            ToOne<SongLyric> songLyric)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SongLyricSettingsModel() when $default != null:
        return $default(_that.id, _that.showChords, _that.showMusicalNotes,
            _that.accidentals, _that.transposition, _that.songLyric);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @Id(assignable: true) int id,
            bool showChords,
            bool showMusicalNotes,
            int? accidentals,
            int transposition,
            ToOne<SongLyric> songLyric)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongLyricSettingsModel():
        return $default(_that.id, _that.showChords, _that.showMusicalNotes,
            _that.accidentals, _that.transposition, _that.songLyric);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @Id(assignable: true) int id,
            bool showChords,
            bool showMusicalNotes,
            int? accidentals,
            int transposition,
            ToOne<SongLyric> songLyric)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SongLyricSettingsModel() when $default != null:
        return $default(_that.id, _that.showChords, _that.showMusicalNotes,
            _that.accidentals, _that.transposition, _that.songLyric);
      case _:
        return null;
    }
  }
}

/// @nodoc

@Entity(realClass: SongLyricSettingsModel)
class _SongLyricSettingsModel extends SongLyricSettingsModel {
  const _SongLyricSettingsModel(
      {@Id(assignable: true) required this.id,
      required this.showChords,
      required this.showMusicalNotes,
      this.accidentals,
      required this.transposition,
      required this.songLyric})
      : super._();

  @override
  @Id(assignable: true)
  final int id;
  @override
  final bool showChords;
  @override
  final bool showMusicalNotes;
  @override
  final int? accidentals;
  @override
  final int transposition;
  @override
  final ToOne<SongLyric> songLyric;

  /// Create a copy of SongLyricSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SongLyricSettingsModelCopyWith<_SongLyricSettingsModel> get copyWith =>
      __$SongLyricSettingsModelCopyWithImpl<_SongLyricSettingsModel>(
          this, _$identity);

  @override
  String toString() {
    return 'SongLyricSettingsModel(id: $id, showChords: $showChords, showMusicalNotes: $showMusicalNotes, accidentals: $accidentals, transposition: $transposition, songLyric: $songLyric)';
  }
}

/// @nodoc
abstract mixin class _$SongLyricSettingsModelCopyWith<$Res>
    implements $SongLyricSettingsModelCopyWith<$Res> {
  factory _$SongLyricSettingsModelCopyWith(_SongLyricSettingsModel value,
          $Res Function(_SongLyricSettingsModel) _then) =
      __$SongLyricSettingsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      bool showChords,
      bool showMusicalNotes,
      int? accidentals,
      int transposition,
      ToOne<SongLyric> songLyric});
}

/// @nodoc
class __$SongLyricSettingsModelCopyWithImpl<$Res>
    implements _$SongLyricSettingsModelCopyWith<$Res> {
  __$SongLyricSettingsModelCopyWithImpl(this._self, this._then);

  final _SongLyricSettingsModel _self;
  final $Res Function(_SongLyricSettingsModel) _then;

  /// Create a copy of SongLyricSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? showChords = null,
    Object? showMusicalNotes = null,
    Object? accidentals = freezed,
    Object? transposition = null,
    Object? songLyric = null,
  }) {
    return _then(_SongLyricSettingsModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      showChords: null == showChords
          ? _self.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      showMusicalNotes: null == showMusicalNotes
          ? _self.showMusicalNotes
          : showMusicalNotes // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: freezed == accidentals
          ? _self.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int?,
      transposition: null == transposition
          ? _self.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _self.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
    ));
  }
}

// dart format on
