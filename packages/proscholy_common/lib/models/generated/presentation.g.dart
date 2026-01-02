// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../presentation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PresentationData _$PresentationDataFromJson(Map<String, dynamic> json) =>
    _PresentationData(
      songLyricId: (json['songLyricId'] as num?)?.toInt(),
      isCustomText: json['isCustomText'] as bool? ?? false,
      name: json['name'] as String,
      text: json['text'] as String,
      settings: PresentationSettings.fromJson(
          json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PresentationDataToJson(_PresentationData instance) =>
    <String, dynamic>{
      'songLyricId': instance.songLyricId,
      'isCustomText': instance.isCustomText,
      'name': instance.name,
      'text': instance.text,
      'settings': instance.settings,
    };

_PresentationSettings _$PresentationSettingsFromJson(
        Map<String, dynamic> json) =>
    _PresentationSettings(
      darkMode: json['darkMode'] as bool,
      showName: json['showName'] as bool,
      allCapital: json['allCapital'] as bool,
      isVisible: json['isVisible'] as bool,
      alignment: $enumDecodeNullable(
          _$PresentationAlignmentEnumMap, json['alignment']),
      rotation:
          $enumDecodeNullable(_$PresentationRotationEnumMap, json['rotation']),
    );

Map<String, dynamic> _$PresentationSettingsToJson(
        _PresentationSettings instance) =>
    <String, dynamic>{
      'darkMode': instance.darkMode,
      'showName': instance.showName,
      'allCapital': instance.allCapital,
      'isVisible': instance.isVisible,
      'alignment': _$PresentationAlignmentEnumMap[instance.alignment],
      'rotation': _$PresentationRotationEnumMap[instance.rotation],
    };

const _$PresentationAlignmentEnumMap = {
  PresentationAlignment.top: 'top',
  PresentationAlignment.center: 'center',
  PresentationAlignment.bottom: 'bottom',
};

const _$PresentationRotationEnumMap = {
  PresentationRotation.none: 'none',
  PresentationRotation.left90: 'left90',
  PresentationRotation.right90: 'right90',
  PresentationRotation.upsideDown: 'upsideDown',
};
