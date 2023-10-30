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
  int get seedColor => throw _privateConstructorUsedError;
  double get fontSizeScale => throw _privateConstructorUsedError;
  bool get showChords => throw _privateConstructorUsedError;
  bool get showMusicalNotes => throw _privateConstructorUsedError;
  int get accidentals => throw _privateConstructorUsedError;
  int get autoScrollSpeedIndex => throw _privateConstructorUsedError;

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
      int seedColor,
      double fontSizeScale,
      bool showChords,
      bool showMusicalNotes,
      int accidentals,
      int autoScrollSpeedIndex});
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
    Object? seedColor = null,
    Object? fontSizeScale = null,
    Object? showChords = null,
    Object? showMusicalNotes = null,
    Object? accidentals = null,
    Object? autoScrollSpeedIndex = null,
  }) {
    return _then(_value.copyWith(
      darkModeEnabled: freezed == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      seedColor: null == seedColor
          ? _value.seedColor
          : seedColor // ignore: cast_nullable_to_non_nullable
              as int,
      fontSizeScale: null == fontSizeScale
          ? _value.fontSizeScale
          : fontSizeScale // ignore: cast_nullable_to_non_nullable
              as double,
      showChords: null == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      showMusicalNotes: null == showMusicalNotes
          ? _value.showMusicalNotes
          : showMusicalNotes // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
      autoScrollSpeedIndex: null == autoScrollSpeedIndex
          ? _value.autoScrollSpeedIndex
          : autoScrollSpeedIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlobalSettingsImplCopyWith<$Res>
    implements $GlobalSettingsCopyWith<$Res> {
  factory _$$GlobalSettingsImplCopyWith(_$GlobalSettingsImpl value,
          $Res Function(_$GlobalSettingsImpl) then) =
      __$$GlobalSettingsImplCopyWithImpl<$Res>;
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
class __$$GlobalSettingsImplCopyWithImpl<$Res>
    extends _$GlobalSettingsCopyWithImpl<$Res, _$GlobalSettingsImpl>
    implements _$$GlobalSettingsImplCopyWith<$Res> {
  __$$GlobalSettingsImplCopyWithImpl(
      _$GlobalSettingsImpl _value, $Res Function(_$GlobalSettingsImpl) _then)
      : super(_value, _then);

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
    return _then(_$GlobalSettingsImpl(
      darkModeEnabled: freezed == darkModeEnabled
          ? _value.darkModeEnabled
          : darkModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      seedColor: null == seedColor
          ? _value.seedColor
          : seedColor // ignore: cast_nullable_to_non_nullable
              as int,
      fontSizeScale: null == fontSizeScale
          ? _value.fontSizeScale
          : fontSizeScale // ignore: cast_nullable_to_non_nullable
              as double,
      showChords: null == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      showMusicalNotes: null == showMusicalNotes
          ? _value.showMusicalNotes
          : showMusicalNotes // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
      autoScrollSpeedIndex: null == autoScrollSpeedIndex
          ? _value.autoScrollSpeedIndex
          : autoScrollSpeedIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GlobalSettingsImpl implements _GlobalSettings {
  const _$GlobalSettingsImpl(
      {this.darkModeEnabled,
      required this.seedColor,
      required this.fontSizeScale,
      required this.showChords,
      required this.showMusicalNotes,
      required this.accidentals,
      required this.autoScrollSpeedIndex});

  factory _$GlobalSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlobalSettingsImplFromJson(json);

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

  @override
  String toString() {
    return 'GlobalSettings(darkModeEnabled: $darkModeEnabled, seedColor: $seedColor, fontSizeScale: $fontSizeScale, showChords: $showChords, showMusicalNotes: $showMusicalNotes, accidentals: $accidentals, autoScrollSpeedIndex: $autoScrollSpeedIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalSettingsImpl &&
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

  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalSettingsImplCopyWith<_$GlobalSettingsImpl> get copyWith =>
      __$$GlobalSettingsImplCopyWithImpl<_$GlobalSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlobalSettingsImplToJson(
      this,
    );
  }
}

abstract class _GlobalSettings implements GlobalSettings {
  const factory _GlobalSettings(
      {final bool? darkModeEnabled,
      required final int seedColor,
      required final double fontSizeScale,
      required final bool showChords,
      required final bool showMusicalNotes,
      required final int accidentals,
      required final int autoScrollSpeedIndex}) = _$GlobalSettingsImpl;

  factory _GlobalSettings.fromJson(Map<String, dynamic> json) =
      _$GlobalSettingsImpl.fromJson;

  @override
  bool? get darkModeEnabled;
  @override
  int get seedColor;
  @override
  double get fontSizeScale;
  @override
  bool get showChords;
  @override
  bool get showMusicalNotes;
  @override
  int get accidentals;
  @override
  int get autoScrollSpeedIndex;
  @override
  @JsonKey(ignore: true)
  _$$GlobalSettingsImplCopyWith<_$GlobalSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SongLyricSettingsModel {
  @Id(assignable: true)
  int get id => throw _privateConstructorUsedError;
  bool get showChords => throw _privateConstructorUsedError;
  bool get showMusicalNotes => throw _privateConstructorUsedError;
  int get accidentals => throw _privateConstructorUsedError;
  int get transposition => throw _privateConstructorUsedError;
  ToOne<SongLyric> get songLyric => throw _privateConstructorUsedError;

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
      bool showMusicalNotes,
      int accidentals,
      int transposition,
      ToOne<SongLyric> songLyric});
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
    Object? showMusicalNotes = null,
    Object? accidentals = null,
    Object? transposition = null,
    Object? songLyric = null,
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
      showMusicalNotes: null == showMusicalNotes
          ? _value.showMusicalNotes
          : showMusicalNotes // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
      transposition: null == transposition
          ? _value.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _value.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongLyricSettingsModelImplCopyWith<$Res>
    implements $SongLyricSettingsModelCopyWith<$Res> {
  factory _$$SongLyricSettingsModelImplCopyWith(
          _$SongLyricSettingsModelImpl value,
          $Res Function(_$SongLyricSettingsModelImpl) then) =
      __$$SongLyricSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int id,
      bool showChords,
      bool showMusicalNotes,
      int accidentals,
      int transposition,
      ToOne<SongLyric> songLyric});
}

/// @nodoc
class __$$SongLyricSettingsModelImplCopyWithImpl<$Res>
    extends _$SongLyricSettingsModelCopyWithImpl<$Res,
        _$SongLyricSettingsModelImpl>
    implements _$$SongLyricSettingsModelImplCopyWith<$Res> {
  __$$SongLyricSettingsModelImplCopyWithImpl(
      _$SongLyricSettingsModelImpl _value,
      $Res Function(_$SongLyricSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? showChords = null,
    Object? showMusicalNotes = null,
    Object? accidentals = null,
    Object? transposition = null,
    Object? songLyric = null,
  }) {
    return _then(_$SongLyricSettingsModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      showChords: null == showChords
          ? _value.showChords
          : showChords // ignore: cast_nullable_to_non_nullable
              as bool,
      showMusicalNotes: null == showMusicalNotes
          ? _value.showMusicalNotes
          : showMusicalNotes // ignore: cast_nullable_to_non_nullable
              as bool,
      accidentals: null == accidentals
          ? _value.accidentals
          : accidentals // ignore: cast_nullable_to_non_nullable
              as int,
      transposition: null == transposition
          ? _value.transposition
          : transposition // ignore: cast_nullable_to_non_nullable
              as int,
      songLyric: null == songLyric
          ? _value.songLyric
          : songLyric // ignore: cast_nullable_to_non_nullable
              as ToOne<SongLyric>,
    ));
  }
}

/// @nodoc

@Entity(realClass: SongLyricSettingsModel)
class _$SongLyricSettingsModelImpl extends _SongLyricSettingsModel {
  const _$SongLyricSettingsModelImpl(
      {@Id(assignable: true) required this.id,
      required this.showChords,
      required this.showMusicalNotes,
      required this.accidentals,
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
  final int accidentals;
  @override
  final int transposition;
  @override
  final ToOne<SongLyric> songLyric;

  @override
  String toString() {
    return 'SongLyricSettingsModel(id: $id, showChords: $showChords, showMusicalNotes: $showMusicalNotes, accidentals: $accidentals, transposition: $transposition, songLyric: $songLyric)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongLyricSettingsModelImplCopyWith<_$SongLyricSettingsModelImpl>
      get copyWith => __$$SongLyricSettingsModelImplCopyWithImpl<
          _$SongLyricSettingsModelImpl>(this, _$identity);
}

abstract class _SongLyricSettingsModel extends SongLyricSettingsModel {
  const factory _SongLyricSettingsModel(
          {@Id(assignable: true) required final int id,
          required final bool showChords,
          required final bool showMusicalNotes,
          required final int accidentals,
          required final int transposition,
          required final ToOne<SongLyric> songLyric}) =
      _$SongLyricSettingsModelImpl;
  const _SongLyricSettingsModel._() : super._();

  @override
  @Id(assignable: true)
  int get id;
  @override
  bool get showChords;
  @override
  bool get showMusicalNotes;
  @override
  int get accidentals;
  @override
  int get transposition;
  @override
  ToOne<SongLyric> get songLyric;
  @override
  @JsonKey(ignore: true)
  _$$SongLyricSettingsModelImplCopyWith<_$SongLyricSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
