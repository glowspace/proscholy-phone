// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../presentation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PresentationData {
  int? get songLyricId;
  bool get isCustomText;
  String get name;
  String get text;
  PresentationSettings get settings;

  /// Create a copy of PresentationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PresentationDataCopyWith<PresentationData> get copyWith =>
      _$PresentationDataCopyWithImpl<PresentationData>(
          this as PresentationData, _$identity);

  /// Serializes this PresentationData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PresentationData &&
            (identical(other.songLyricId, songLyricId) ||
                other.songLyricId == songLyricId) &&
            (identical(other.isCustomText, isCustomText) ||
                other.isCustomText == isCustomText) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, songLyricId, isCustomText, name, text, settings);

  @override
  String toString() {
    return 'PresentationData(songLyricId: $songLyricId, isCustomText: $isCustomText, name: $name, text: $text, settings: $settings)';
  }
}

/// @nodoc
abstract mixin class $PresentationDataCopyWith<$Res> {
  factory $PresentationDataCopyWith(
          PresentationData value, $Res Function(PresentationData) _then) =
      _$PresentationDataCopyWithImpl;
  @useResult
  $Res call(
      {int? songLyricId,
      bool isCustomText,
      String name,
      String text,
      PresentationSettings settings});

  $PresentationSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$PresentationDataCopyWithImpl<$Res>
    implements $PresentationDataCopyWith<$Res> {
  _$PresentationDataCopyWithImpl(this._self, this._then);

  final PresentationData _self;
  final $Res Function(PresentationData) _then;

  /// Create a copy of PresentationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyricId = freezed,
    Object? isCustomText = null,
    Object? name = null,
    Object? text = null,
    Object? settings = null,
  }) {
    return _then(_self.copyWith(
      songLyricId: freezed == songLyricId
          ? _self.songLyricId
          : songLyricId // ignore: cast_nullable_to_non_nullable
              as int?,
      isCustomText: null == isCustomText
          ? _self.isCustomText
          : isCustomText // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as PresentationSettings,
    ));
  }

  /// Create a copy of PresentationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PresentationSettingsCopyWith<$Res> get settings {
    return $PresentationSettingsCopyWith<$Res>(_self.settings, (value) {
      return _then(_self.copyWith(settings: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PresentationData].
extension PresentationDataPatterns on PresentationData {
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
    TResult Function(_PresentationData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresentationData() when $default != null:
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
    TResult Function(_PresentationData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresentationData():
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
    TResult? Function(_PresentationData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresentationData() when $default != null:
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
    TResult Function(int? songLyricId, bool isCustomText, String name,
            String text, PresentationSettings settings)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresentationData() when $default != null:
        return $default(_that.songLyricId, _that.isCustomText, _that.name,
            _that.text, _that.settings);
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
    TResult Function(int? songLyricId, bool isCustomText, String name,
            String text, PresentationSettings settings)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresentationData():
        return $default(_that.songLyricId, _that.isCustomText, _that.name,
            _that.text, _that.settings);
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
    TResult? Function(int? songLyricId, bool isCustomText, String name,
            String text, PresentationSettings settings)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresentationData() when $default != null:
        return $default(_that.songLyricId, _that.isCustomText, _that.name,
            _that.text, _that.settings);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PresentationData implements PresentationData {
  const _PresentationData(
      {this.songLyricId,
      this.isCustomText = false,
      required this.name,
      required this.text,
      required this.settings});
  factory _PresentationData.fromJson(Map<String, dynamic> json) =>
      _$PresentationDataFromJson(json);

  @override
  final int? songLyricId;
  @override
  @JsonKey()
  final bool isCustomText;
  @override
  final String name;
  @override
  final String text;
  @override
  final PresentationSettings settings;

  /// Create a copy of PresentationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PresentationDataCopyWith<_PresentationData> get copyWith =>
      __$PresentationDataCopyWithImpl<_PresentationData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PresentationDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PresentationData &&
            (identical(other.songLyricId, songLyricId) ||
                other.songLyricId == songLyricId) &&
            (identical(other.isCustomText, isCustomText) ||
                other.isCustomText == isCustomText) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, songLyricId, isCustomText, name, text, settings);

  @override
  String toString() {
    return 'PresentationData(songLyricId: $songLyricId, isCustomText: $isCustomText, name: $name, text: $text, settings: $settings)';
  }
}

/// @nodoc
abstract mixin class _$PresentationDataCopyWith<$Res>
    implements $PresentationDataCopyWith<$Res> {
  factory _$PresentationDataCopyWith(
          _PresentationData value, $Res Function(_PresentationData) _then) =
      __$PresentationDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? songLyricId,
      bool isCustomText,
      String name,
      String text,
      PresentationSettings settings});

  @override
  $PresentationSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$PresentationDataCopyWithImpl<$Res>
    implements _$PresentationDataCopyWith<$Res> {
  __$PresentationDataCopyWithImpl(this._self, this._then);

  final _PresentationData _self;
  final $Res Function(_PresentationData) _then;

  /// Create a copy of PresentationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? songLyricId = freezed,
    Object? isCustomText = null,
    Object? name = null,
    Object? text = null,
    Object? settings = null,
  }) {
    return _then(_PresentationData(
      songLyricId: freezed == songLyricId
          ? _self.songLyricId
          : songLyricId // ignore: cast_nullable_to_non_nullable
              as int?,
      isCustomText: null == isCustomText
          ? _self.isCustomText
          : isCustomText // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as PresentationSettings,
    ));
  }

  /// Create a copy of PresentationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PresentationSettingsCopyWith<$Res> get settings {
    return $PresentationSettingsCopyWith<$Res>(_self.settings, (value) {
      return _then(_self.copyWith(settings: value));
    });
  }
}

/// @nodoc
mixin _$PresentationSettings {
  bool get darkMode;
  bool get showName;
  bool get allCapital;
  bool get isVisible;
  PresentationAlignment? get alignment;

  /// Create a copy of PresentationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PresentationSettingsCopyWith<PresentationSettings> get copyWith =>
      _$PresentationSettingsCopyWithImpl<PresentationSettings>(
          this as PresentationSettings, _$identity);

  /// Serializes this PresentationSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PresentationSettings &&
            (identical(other.darkMode, darkMode) ||
                other.darkMode == darkMode) &&
            (identical(other.showName, showName) ||
                other.showName == showName) &&
            (identical(other.allCapital, allCapital) ||
                other.allCapital == allCapital) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.alignment, alignment) ||
                other.alignment == alignment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, darkMode, showName, allCapital, isVisible, alignment);

  @override
  String toString() {
    return 'PresentationSettings(darkMode: $darkMode, showName: $showName, allCapital: $allCapital, isVisible: $isVisible, alignment: $alignment)';
  }
}

/// @nodoc
abstract mixin class $PresentationSettingsCopyWith<$Res> {
  factory $PresentationSettingsCopyWith(PresentationSettings value,
          $Res Function(PresentationSettings) _then) =
      _$PresentationSettingsCopyWithImpl;
  @useResult
  $Res call(
      {bool darkMode,
      bool showName,
      bool allCapital,
      bool isVisible,
      PresentationAlignment? alignment});
}

/// @nodoc
class _$PresentationSettingsCopyWithImpl<$Res>
    implements $PresentationSettingsCopyWith<$Res> {
  _$PresentationSettingsCopyWithImpl(this._self, this._then);

  final PresentationSettings _self;
  final $Res Function(PresentationSettings) _then;

  /// Create a copy of PresentationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? darkMode = null,
    Object? showName = null,
    Object? allCapital = null,
    Object? isVisible = null,
    Object? alignment = freezed,
  }) {
    return _then(_self.copyWith(
      darkMode: null == darkMode
          ? _self.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showName: null == showName
          ? _self.showName
          : showName // ignore: cast_nullable_to_non_nullable
              as bool,
      allCapital: null == allCapital
          ? _self.allCapital
          : allCapital // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _self.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      alignment: freezed == alignment
          ? _self.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as PresentationAlignment?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PresentationSettings].
extension PresentationSettingsPatterns on PresentationSettings {
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
    TResult Function(_PresentationSettings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresentationSettings() when $default != null:
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
    TResult Function(_PresentationSettings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresentationSettings():
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
    TResult? Function(_PresentationSettings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresentationSettings() when $default != null:
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
    TResult Function(bool darkMode, bool showName, bool allCapital,
            bool isVisible, PresentationAlignment? alignment)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresentationSettings() when $default != null:
        return $default(_that.darkMode, _that.showName, _that.allCapital,
            _that.isVisible, _that.alignment);
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
    TResult Function(bool darkMode, bool showName, bool allCapital,
            bool isVisible, PresentationAlignment? alignment)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresentationSettings():
        return $default(_that.darkMode, _that.showName, _that.allCapital,
            _that.isVisible, _that.alignment);
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
    TResult? Function(bool darkMode, bool showName, bool allCapital,
            bool isVisible, PresentationAlignment? alignment)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresentationSettings() when $default != null:
        return $default(_that.darkMode, _that.showName, _that.allCapital,
            _that.isVisible, _that.alignment);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PresentationSettings implements PresentationSettings {
  const _PresentationSettings(
      {required this.darkMode,
      required this.showName,
      required this.allCapital,
      required this.isVisible,
      this.alignment});
  factory _PresentationSettings.fromJson(Map<String, dynamic> json) =>
      _$PresentationSettingsFromJson(json);

  @override
  final bool darkMode;
  @override
  final bool showName;
  @override
  final bool allCapital;
  @override
  final bool isVisible;
  @override
  final PresentationAlignment? alignment;

  /// Create a copy of PresentationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PresentationSettingsCopyWith<_PresentationSettings> get copyWith =>
      __$PresentationSettingsCopyWithImpl<_PresentationSettings>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PresentationSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PresentationSettings &&
            (identical(other.darkMode, darkMode) ||
                other.darkMode == darkMode) &&
            (identical(other.showName, showName) ||
                other.showName == showName) &&
            (identical(other.allCapital, allCapital) ||
                other.allCapital == allCapital) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.alignment, alignment) ||
                other.alignment == alignment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, darkMode, showName, allCapital, isVisible, alignment);

  @override
  String toString() {
    return 'PresentationSettings(darkMode: $darkMode, showName: $showName, allCapital: $allCapital, isVisible: $isVisible, alignment: $alignment)';
  }
}

/// @nodoc
abstract mixin class _$PresentationSettingsCopyWith<$Res>
    implements $PresentationSettingsCopyWith<$Res> {
  factory _$PresentationSettingsCopyWith(_PresentationSettings value,
          $Res Function(_PresentationSettings) _then) =
      __$PresentationSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool darkMode,
      bool showName,
      bool allCapital,
      bool isVisible,
      PresentationAlignment? alignment});
}

/// @nodoc
class __$PresentationSettingsCopyWithImpl<$Res>
    implements _$PresentationSettingsCopyWith<$Res> {
  __$PresentationSettingsCopyWithImpl(this._self, this._then);

  final _PresentationSettings _self;
  final $Res Function(_PresentationSettings) _then;

  /// Create a copy of PresentationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? darkMode = null,
    Object? showName = null,
    Object? allCapital = null,
    Object? isVisible = null,
    Object? alignment = freezed,
  }) {
    return _then(_PresentationSettings(
      darkMode: null == darkMode
          ? _self.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showName: null == showName
          ? _self.showName
          : showName // ignore: cast_nullable_to_non_nullable
              as bool,
      allCapital: null == allCapital
          ? _self.allCapital
          : allCapital // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _self.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      alignment: freezed == alignment
          ? _self.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as PresentationAlignment?,
    ));
  }
}

// dart format on
