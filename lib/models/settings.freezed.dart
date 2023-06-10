// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GlobalSettings _$GlobalSettingsFromJson(Map<String, dynamic> json) {
  return _GlobalSettings.fromJson(json);
}

/// @nodoc
mixin _$GlobalSettings {
  bool? get darkModeEnabled => throw _privateConstructorUsedError;
  double get fontSizeScale => throw _privateConstructorUsedError;
  bool get showChords => throw _privateConstructorUsedError;
  int get accidentals => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GlobalSettingsCopyWith<GlobalSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalSettingsCopyWith<$Res> {
  factory $GlobalSettingsCopyWith(
          GlobalSettings value, $Res Function(GlobalSettings) then) =
      _$GlobalSettingsCopyWithImpl<$Res, GlobalSettings>;
  @useResult
  $Res call(
      {bool? darkModeEnabled,
      double fontSizeScale,
      bool showChords,
      int accidentals});
}

/// @nodoc
class _$GlobalSettingsCopyWithImpl<$Res, $Val extends GlobalSettings>
    implements $GlobalSettingsCopyWith<$Res> {
  _$GlobalSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? darkModeEnabled = freezed,
    Object? fontSizeScale = null,
    Object? showChords = null,
    Object? accidentals = null,
  }) {
    return _then(_value.copyWith(
      darkModeEnabled: freezed == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      fontSizeScale: null == fontSizeScale
          ? _value.fontSizeScale
          : fontSizeScale // ignore: cast_nullable_to_non_nullable
              as double,
      showChords: null == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GlobalSettingsCopyWith<$Res>
    implements $GlobalSettingsCopyWith<$Res> {
  factory _$$_GlobalSettingsCopyWith(
          _$_GlobalSettings value, $Res Function(_$_GlobalSettings) then) =
      __$$_GlobalSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? darkModeEnabled,
      double fontSizeScale,
      bool showChords,
      int accidentals});
}

/// @nodoc
class __$$_GlobalSettingsCopyWithImpl<$Res>
    extends _$GlobalSettingsCopyWithImpl<$Res, _$_GlobalSettings>
    implements _$$_GlobalSettingsCopyWith<$Res> {
  __$$_GlobalSettingsCopyWithImpl(
      _$_GlobalSettings _value, $Res Function(_$_GlobalSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? darkModeEnabled = freezed,
    Object? fontSizeScale = null,
    Object? showChords = null,
    Object? accidentals = null,
  }) {
    return _then(_$_GlobalSettings(
      darkModeEnabled: freezed == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      fontSizeScale: null == fontSizeScale
          ? _value.fontSizeScale
          : fontSizeScale // ignore: cast_nullable_to_non_nullable
              as double,
      showChords: null == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GlobalSettings implements _GlobalSettings {
  const _$_GlobalSettings(
      {this.darkModeEnabled,
      required this.fontSizeScale,
      required this.showChords,
      required this.accidentals});

  factory _$_GlobalSettings.fromJson(Map<String, dynamic> json) =>
      _$$_GlobalSettingsFromJson(json);

  @override
  final bool? darkModeEnabled;
  @override
  final double fontSizeScale;
  @override
  final bool showChords;
  @override
  final int accidentals;

  @override
  String toString() {
    return 'GlobalSettings(darkModeEnabled: $darkModeEnabled, fontSizeScale: $fontSizeScale, showChords: $showChords, accidentals: $accidentals)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GlobalSettings &&
            (identical(other.darkModeEnabled, darkModeEnabled) ||
                other.darkModeEnabled == darkModeEnabled) &&
            (identical(other.fontSizeScale, fontSizeScale) ||
                other.fontSizeScale == fontSizeScale) &&
            (identical(other.showChords, showChords) ||
                other.showChords == showChords) &&
            (identical(other.accidentals, accidentals) ||
                other.accidentals == accidentals));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, darkModeEnabled, fontSizeScale, showChords, accidentals);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GlobalSettingsCopyWith<_$_GlobalSettings> get copyWith =>
      __$$_GlobalSettingsCopyWithImpl<_$_GlobalSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GlobalSettingsToJson(
      this,
    );
  }
}

abstract class _GlobalSettings implements GlobalSettings {
  const factory _GlobalSettings(
      {final bool? darkModeEnabled,
      required final double fontSizeScale,
      required final bool showChords,
      required final int accidentals}) = _$_GlobalSettings;

  factory _GlobalSettings.fromJson(Map<String, dynamic> json) =
      _$_GlobalSettings.fromJson;

  @override
  bool? get darkModeEnabled;
  @override
  double get fontSizeScale;
  @override
  bool get showChords;
  @override
  int get accidentals;
  @override
  @JsonKey(ignore: true)
  _$$_GlobalSettingsCopyWith<_$_GlobalSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SongLyricSettingsModel {
  @Id(assignable: true)
  int get id => throw _privateConstructorUsedError;
  bool get showChords => throw _privateConstructorUsedError;
  int get accidentals => throw _privateConstructorUsedError;
  int get transposition => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongLyricSettingsModelCopyWith<SongLyricSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongLyricSettingsModelCopyWith<$Res> {
  factory $SongLyricSettingsModelCopyWith(SongLyricSettingsModel value,
          $Res Function(SongLyricSettingsModel) then) =
      _$SongLyricSettingsModelCopyWithImpl<$Res, SongLyricSettingsModel>;
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      bool showChords,
      int accidentals,
      int transposition});
}

/// @nodoc
class _$SongLyricSettingsModelCopyWithImpl<$Res,
        $Val extends SongLyricSettingsModel>
    implements $SongLyricSettingsModelCopyWith<$Res> {
  _$SongLyricSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? showChords = null,
    Object? accidentals = null,
    Object? transposition = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      showChords: null == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
      transposition: null == transposition
          ? _value.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SongLyricSettingsModelCopyWith<$Res>
    implements $SongLyricSettingsModelCopyWith<$Res> {
  factory _$$_SongLyricSettingsModelCopyWith(_$_SongLyricSettingsModel value,
          $Res Function(_$_SongLyricSettingsModel) then) =
      __$$_SongLyricSettingsModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      bool showChords,
      int accidentals,
      int transposition});
}

/// @nodoc
class __$$_SongLyricSettingsModelCopyWithImpl<$Res>
    extends _$SongLyricSettingsModelCopyWithImpl<$Res,
        _$_SongLyricSettingsModel>
    implements _$$_SongLyricSettingsModelCopyWith<$Res> {
  __$$_SongLyricSettingsModelCopyWithImpl(_$_SongLyricSettingsModel _value,
      $Res Function(_$_SongLyricSettingsModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? showChords = null,
    Object? accidentals = null,
    Object? transposition = null,
  }) {
    return _then(_$_SongLyricSettingsModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      showChords: null == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
      transposition: null == transposition
          ? _value.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@Entity(realClass: SongLyricSettingsModel)
class _$_SongLyricSettingsModel implements _SongLyricSettingsModel {
  const _$_SongLyricSettingsModel(
      {@Id(assignable: true) required this.id,
      required this.showChords,
      required this.accidentals,
      required this.transposition});

  @override
  @Id(assignable: true)
  final int id;
  @override
  final bool showChords;
  @override
  final int accidentals;
  @override
  final int transposition;

  @override
  String toString() {
    return 'SongLyricSettingsModel(id: $id, showChords: $showChords, accidentals: $accidentals, transposition: $transposition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SongLyricSettingsModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.showChords, showChords) ||
                other.showChords == showChords) &&
            (identical(other.accidentals, accidentals) ||
                other.accidentals == accidentals) &&
            (identical(other.transposition, transposition) ||
                other.transposition == transposition));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, showChords, accidentals, transposition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SongLyricSettingsModelCopyWith<_$_SongLyricSettingsModel> get copyWith =>
      __$$_SongLyricSettingsModelCopyWithImpl<_$_SongLyricSettingsModel>(
          this, _$identity);
}

abstract class _SongLyricSettingsModel implements SongLyricSettingsModel {
  const factory _SongLyricSettingsModel(
      {@Id(assignable: true) required final int id,
      required final bool showChords,
      required final int accidentals,
      required final int transposition}) = _$_SongLyricSettingsModel;

  @override
  @Id(assignable: true)
  int get id;
  @override
  bool get showChords;
  @override
  int get accidentals;
  @override
  int get transposition;
  @override
  @JsonKey(ignore: true)
  _$$_SongLyricSettingsModelCopyWith<_$_SongLyricSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}
