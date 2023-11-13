// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PresentationDataImpl _$$PresentationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PresentationDataImpl(
      songLyricId: json['songLyricId'] as int?,
      isCustomText: json['isCustomText'] as bool? ?? false,
      name: json['name'] as String,
      text: json['text'] as String,
      settings: PresentationSettings.fromJson(
          json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PresentationDataImplToJson(
        _$PresentationDataImpl instance) =>
    <String, dynamic>{
      'songLyricId': instance.songLyricId,
      'isCustomText': instance.isCustomText,
      'name': instance.name,
      'text': instance.text,
      'settings': instance.settings,
    };

_$PresentationSettingsImpl _$$PresentationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PresentationSettingsImpl(
      darkMode: json['darkMode'] as bool,
      showName: json['showName'] as bool,
      allCapital: json['allCapital'] as bool,
      isVisible: json['isVisible'] as bool,
      alignment: $enumDecodeNullable(
          _$PresentationAlignmentEnumMap, json['alignment']),
    );

Map<String, dynamic> _$$PresentationSettingsImplToJson(
        _$PresentationSettingsImpl instance) =>
    <String, dynamic>{
      'darkMode': instance.darkMode,
      'showName': instance.showName,
      'allCapital': instance.allCapital,
      'isVisible': instance.isVisible,
      'alignment': _$PresentationAlignmentEnumMap[instance.alignment],
    };

const _$PresentationAlignmentEnumMap = {
  PresentationAlignment.top: 'top',
  PresentationAlignment.center: 'center',
  PresentationAlignment.bottom: 'bottom',
};
