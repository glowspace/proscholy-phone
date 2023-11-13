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
  int? get songLyricId => throw _privateConstructorUsedError;
  bool get isCustomText => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
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
      {int? songLyricId,
      bool isCustomText,
      String name,
      String text,
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
    Object? songLyricId = freezed,
    Object? isCustomText = null,
    Object? name = null,
    Object? text = null,
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      songLyricId: freezed == songLyricId
          ? _value.songLyricId
          : songLyricId // ignore: cast_nullable_to_non_nullable
              as int?,
      isCustomText: null == isCustomText
          ? _value.isCustomText
          : isCustomText // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PresentationDataImplCopyWith<$Res>
    implements $PresentationDataCopyWith<$Res> {
  factory _$$PresentationDataImplCopyWith(_$PresentationDataImpl value,
          $Res Function(_$PresentationDataImpl) then) =
      __$$PresentationDataImplCopyWithImpl<$Res>;
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
class __$$PresentationDataImplCopyWithImpl<$Res>
    extends _$PresentationDataCopyWithImpl<$Res, _$PresentationDataImpl>
    implements _$$PresentationDataImplCopyWith<$Res> {
  __$$PresentationDataImplCopyWithImpl(_$PresentationDataImpl _value,
      $Res Function(_$PresentationDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songLyricId = freezed,
    Object? isCustomText = null,
    Object? name = null,
    Object? text = null,
    Object? settings = null,
  }) {
    return _then(_$PresentationDataImpl(
      songLyricId: freezed == songLyricId
          ? _value.songLyricId
          : songLyricId // ignore: cast_nullable_to_non_nullable
              as int?,
      isCustomText: null == isCustomText
          ? _value.isCustomText
          : isCustomText // ignore: cast_nullable_to_non_nullable
              as bool,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
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
class _$PresentationDataImpl implements _PresentationData {
  const _$PresentationDataImpl(
      {this.songLyricId,
      this.isCustomText = false,
      required this.name,
      required this.text,
      required this.settings});

  factory _$PresentationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresentationDataImplFromJson(json);

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

  @override
  String toString() {
    return 'PresentationData(songLyricId: $songLyricId, isCustomText: $isCustomText, name: $name, text: $text, settings: $settings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresentationDataImpl &&
            (identical(other.songLyricId, songLyricId) ||
                other.songLyricId == songLyricId) &&
            (identical(other.isCustomText, isCustomText) ||
                other.isCustomText == isCustomText) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, songLyricId, isCustomText, name, text, settings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PresentationDataImplCopyWith<_$PresentationDataImpl> get copyWith =>
      __$$PresentationDataImplCopyWithImpl<_$PresentationDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresentationDataImplToJson(
      this,
    );
  }
}

abstract class _PresentationData implements PresentationData {
  const factory _PresentationData(
      {final int? songLyricId,
      final bool isCustomText,
      required final String name,
      required final String text,
      required final PresentationSettings settings}) = _$PresentationDataImpl;

  factory _PresentationData.fromJson(Map<String, dynamic> json) =
      _$PresentationDataImpl.fromJson;

  @override
  int? get songLyricId;
  @override
  bool get isCustomText;
  @override
  String get name;
  @override
  String get text;
  @override
  PresentationSettings get settings;
  @override
  @JsonKey(ignore: true)
  _$$PresentationDataImplCopyWith<_$PresentationDataImpl> get copyWith =>
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
  bool get isVisible => throw _privateConstructorUsedError;
  PresentationAlignment? get alignment => throw _privateConstructorUsedError;

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
      {bool showBackground,
      bool darkMode,
      bool showName,
      bool allCapital,
      bool isVisible,
      PresentationAlignment? alignment});
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
    Object? isVisible = null,
    Object? alignment = freezed,
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
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      alignment: freezed == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as PresentationAlignment?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PresentationSettingsImplCopyWith<$Res>
    implements $PresentationSettingsCopyWith<$Res> {
  factory _$$PresentationSettingsImplCopyWith(_$PresentationSettingsImpl value,
          $Res Function(_$PresentationSettingsImpl) then) =
      __$$PresentationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool showBackground,
      bool darkMode,
      bool showName,
      bool allCapital,
      bool isVisible,
      PresentationAlignment? alignment});
}

/// @nodoc
class __$$PresentationSettingsImplCopyWithImpl<$Res>
    extends _$PresentationSettingsCopyWithImpl<$Res, _$PresentationSettingsImpl>
    implements _$$PresentationSettingsImplCopyWith<$Res> {
  __$$PresentationSettingsImplCopyWithImpl(_$PresentationSettingsImpl _value,
      $Res Function(_$PresentationSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showBackground = null,
    Object? darkMode = null,
    Object? showName = null,
    Object? allCapital = null,
    Object? isVisible = null,
    Object? alignment = freezed,
  }) {
    return _then(_$PresentationSettingsImpl(
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
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      alignment: freezed == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as PresentationAlignment?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PresentationSettingsImpl implements _PresentationSettings {
  const _$PresentationSettingsImpl(
      {required this.showBackground,
      required this.darkMode,
      required this.showName,
      required this.allCapital,
      required this.isVisible,
      this.alignment});

  factory _$PresentationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresentationSettingsImplFromJson(json);

  @override
  final bool showBackground;
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

  @override
  String toString() {
    return 'PresentationSettings(showBackground: $showBackground, darkMode: $darkMode, showName: $showName, allCapital: $allCapital, isVisible: $isVisible, alignment: $alignment)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresentationSettingsImpl &&
            (identical(other.showBackground, showBackground) ||
                other.showBackground == showBackground) &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, showBackground, darkMode,
      showName, allCapital, isVisible, alignment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PresentationSettingsImplCopyWith<_$PresentationSettingsImpl>
      get copyWith =>
          __$$PresentationSettingsImplCopyWithImpl<_$PresentationSettingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresentationSettingsImplToJson(
      this,
    );
  }
}

abstract class _PresentationSettings implements PresentationSettings {
  const factory _PresentationSettings(
      {required final bool showBackground,
      required final bool darkMode,
      required final bool showName,
      required final bool allCapital,
      required final bool isVisible,
      final PresentationAlignment? alignment}) = _$PresentationSettingsImpl;

  factory _PresentationSettings.fromJson(Map<String, dynamic> json) =
      _$PresentationSettingsImpl.fromJson;

  @override
  bool get showBackground;
  @override
  bool get darkMode;
  @override
  bool get showName;
  @override
  bool get allCapital;
  @override
  bool get isVisible;
  @override
  PresentationAlignment? get alignment;
  @override
  @JsonKey(ignore: true)
  _$$PresentationSettingsImplCopyWith<_$PresentationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
