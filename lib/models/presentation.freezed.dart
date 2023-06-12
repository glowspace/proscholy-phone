// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'presentation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PresentationData _$PresentationDataFromJson(Map<String, dynamic> json) {
  return _PresentationData.fromJson(json);
}

/// @nodoc
mixin _$PresentationData {
  int get songLyricId => throw _privateConstructorUsedError;
  String get songLyricName => throw _privateConstructorUsedError;
  String get lyrics => throw _privateConstructorUsedError;
  PresentationSettings get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PresentationDataCopyWith<PresentationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresentationDataCopyWith<$Res> {
  factory $PresentationDataCopyWith(
          PresentationData value, $Res Function(PresentationData) then) =
      _$PresentationDataCopyWithImpl<$Res, PresentationData>;
  @useResult
  $Res call(
      {int songLyricId,
      String songLyricName,
      String lyrics,
      PresentationSettings settings});

  $PresentationSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$PresentationDataCopyWithImpl<$Res, $Val extends PresentationData>
    implements $PresentationDataCopyWith<$Res> {
  _$PresentationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyricId = null,
    Object? songLyricName = null,
    Object? lyrics = null,
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      songLyricId: null == songLyricId
          ? _value.songLyricId
          : songLyricId // ignore: cast_nullable_to_non_nullable
              as int,
      songLyricName: null == songLyricName
          ? _value.songLyricName
          : songLyricName // ignore: cast_nullable_to_non_nullable
              as String,
      lyrics: null == lyrics
          ? _value.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as PresentationSettings,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PresentationSettingsCopyWith<$Res> get settings {
    return $PresentationSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PresentationDataCopyWith<$Res>
    implements $PresentationDataCopyWith<$Res> {
  factory _$$_PresentationDataCopyWith(
          _$_PresentationData value, $Res Function(_$_PresentationData) then) =
      __$$_PresentationDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int songLyricId,
      String songLyricName,
      String lyrics,
      PresentationSettings settings});

  @override
  $PresentationSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$_PresentationDataCopyWithImpl<$Res>
    extends _$PresentationDataCopyWithImpl<$Res, _$_PresentationData>
    implements _$$_PresentationDataCopyWith<$Res> {
  __$$_PresentationDataCopyWithImpl(
      _$_PresentationData _value, $Res Function(_$_PresentationData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyricId = null,
    Object? songLyricName = null,
    Object? lyrics = null,
    Object? settings = null,
  }) {
    return _then(_$_PresentationData(
      songLyricId: null == songLyricId
          ? _value.songLyricId
          : songLyricId // ignore: cast_nullable_to_non_nullable
              as int,
      songLyricName: null == songLyricName
          ? _value.songLyricName
          : songLyricName // ignore: cast_nullable_to_non_nullable
              as String,
      lyrics: null == lyrics
          ? _value.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as PresentationSettings,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PresentationData implements _PresentationData {
  const _$_PresentationData(
      {required this.songLyricId,
      required this.songLyricName,
      required this.lyrics,
      required this.settings});

  factory _$_PresentationData.fromJson(Map<String, dynamic> json) =>
      _$$_PresentationDataFromJson(json);

  @override
  final int songLyricId;
  @override
  final String songLyricName;
  @override
  final String lyrics;
  @override
  final PresentationSettings settings;

  @override
  String toString() {
    return 'PresentationData(songLyricId: $songLyricId, songLyricName: $songLyricName, lyrics: $lyrics, settings: $settings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PresentationData &&
            (identical(other.songLyricId, songLyricId) ||
                other.songLyricId == songLyricId) &&
            (identical(other.songLyricName, songLyricName) ||
                other.songLyricName == songLyricName) &&
            (identical(other.lyrics, lyrics) || other.lyrics == lyrics) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, songLyricId, songLyricName, lyrics, settings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PresentationDataCopyWith<_$_PresentationData> get copyWith =>
      __$$_PresentationDataCopyWithImpl<_$_PresentationData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PresentationDataToJson(
      this,
    );
  }
}

abstract class _PresentationData implements PresentationData {
  const factory _PresentationData(
      {required final int songLyricId,
      required final String songLyricName,
      required final String lyrics,
      required final PresentationSettings settings}) = _$_PresentationData;

  factory _PresentationData.fromJson(Map<String, dynamic> json) =
      _$_PresentationData.fromJson;

  @override
  int get songLyricId;
  @override
  String get songLyricName;
  @override
  String get lyrics;
  @override
  PresentationSettings get settings;
  @override
  @JsonKey(ignore: true)
  _$$_PresentationDataCopyWith<_$_PresentationData> get copyWith =>
      throw _privateConstructorUsedError;
}

PresentationSettings _$PresentationSettingsFromJson(Map<String, dynamic> json) {
  return _PresentationSettings.fromJson(json);
}

/// @nodoc
mixin _$PresentationSettings {
  bool get showBackground => throw _privateConstructorUsedError;
  bool get darkMode => throw _privateConstructorUsedError;
  bool get showName => throw _privateConstructorUsedError;
  bool get allCapital => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PresentationSettingsCopyWith<PresentationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresentationSettingsCopyWith<$Res> {
  factory $PresentationSettingsCopyWith(PresentationSettings value,
          $Res Function(PresentationSettings) then) =
      _$PresentationSettingsCopyWithImpl<$Res, PresentationSettings>;
  @useResult
  $Res call(
      {bool showBackground, bool darkMode, bool showName, bool allCapital});
}

/// @nodoc
class _$PresentationSettingsCopyWithImpl<$Res,
        $Val extends PresentationSettings>
    implements $PresentationSettingsCopyWith<$Res> {
  _$PresentationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showBackground = null,
    Object? darkMode = null,
    Object? showName = null,
    Object? allCapital = null,
  }) {
    return _then(_value.copyWith(
      showBackground: null == showBackground
          ? _value.showBackground
          : showBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      darkMode: null == darkMode
          ? _value.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showName: null == showName
          ? _value.showName
          : showName // ignore: cast_nullable_to_non_nullable
              as bool,
      allCapital: null == allCapital
          ? _value.allCapital
          : allCapital // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PresentationSettingsCopyWith<$Res>
    implements $PresentationSettingsCopyWith<$Res> {
  factory _$$_PresentationSettingsCopyWith(_$_PresentationSettings value,
          $Res Function(_$_PresentationSettings) then) =
      __$$_PresentationSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool showBackground, bool darkMode, bool showName, bool allCapital});
}

/// @nodoc
class __$$_PresentationSettingsCopyWithImpl<$Res>
    extends _$PresentationSettingsCopyWithImpl<$Res, _$_PresentationSettings>
    implements _$$_PresentationSettingsCopyWith<$Res> {
  __$$_PresentationSettingsCopyWithImpl(_$_PresentationSettings _value,
      $Res Function(_$_PresentationSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showBackground = null,
    Object? darkMode = null,
    Object? showName = null,
    Object? allCapital = null,
  }) {
    return _then(_$_PresentationSettings(
      showBackground: null == showBackground
          ? _value.showBackground
          : showBackground // ignore: cast_nullable_to_non_nullable
              as bool,
      darkMode: null == darkMode
          ? _value.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showName: null == showName
          ? _value.showName
          : showName // ignore: cast_nullable_to_non_nullable
              as bool,
      allCapital: null == allCapital
          ? _value.allCapital
          : allCapital // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PresentationSettings implements _PresentationSettings {
  const _$_PresentationSettings(
      {required this.showBackground,
      required this.darkMode,
      required this.showName,
      required this.allCapital});

  factory _$_PresentationSettings.fromJson(Map<String, dynamic> json) =>
      _$$_PresentationSettingsFromJson(json);

  @override
  final bool showBackground;
  @override
  final bool darkMode;
  @override
  final bool showName;
  @override
  final bool allCapital;

  @override
  String toString() {
    return 'PresentationSettings(showBackground: $showBackground, darkMode: $darkMode, showName: $showName, allCapital: $allCapital)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PresentationSettings &&
            (identical(other.showBackground, showBackground) ||
                other.showBackground == showBackground) &&
            (identical(other.darkMode, darkMode) ||
                other.darkMode == darkMode) &&
            (identical(other.showName, showName) ||
                other.showName == showName) &&
            (identical(other.allCapital, allCapital) ||
                other.allCapital == allCapital));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, showBackground, darkMode, showName, allCapital);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PresentationSettingsCopyWith<_$_PresentationSettings> get copyWith =>
      __$$_PresentationSettingsCopyWithImpl<_$_PresentationSettings>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PresentationSettingsToJson(
      this,
    );
  }
}

abstract class _PresentationSettings implements PresentationSettings {
  const factory _PresentationSettings(
      {required final bool showBackground,
      required final bool darkMode,
      required final bool showName,
      required final bool allCapital}) = _$_PresentationSettings;

  factory _PresentationSettings.fromJson(Map<String, dynamic> json) =
      _$_PresentationSettings.fromJson;

  @override
  bool get showBackground;
  @override
  bool get darkMode;
  @override
  bool get showName;
  @override
  bool get allCapital;
  @override
  @JsonKey(ignore: true)
  _$$_PresentationSettingsCopyWith<_$_PresentationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
