// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PresentationDataImpl _$$PresentationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PresentationDataImpl(
      songLyricId: json['songLyricId'] as int,
      songLyricName: json['songLyricName'] as String,
      lyrics: json['lyrics'] as String,
      settings: PresentationSettings.fromJson(
          json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PresentationDataImplToJson(
        _$PresentationDataImpl instance) =>
    <String, dynamic>{
      'songLyricId': instance.songLyricId,
      'songLyricName': instance.songLyricName,
      'lyrics': instance.lyrics,
      'settings': instance.settings,
    };

_$PresentationSettingsImpl _$$PresentationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PresentationSettingsImpl(
      showBackground: json['showBackground'] as bool,
      darkMode: json['darkMode'] as bool,
      showName: json['showName'] as bool,
      allCapital: json['allCapital'] as bool,
    );

Map<String, dynamic> _$$PresentationSettingsImplToJson(
        _$PresentationSettingsImpl instance) =>
    <String, dynamic>{
      'showBackground': instance.showBackground,
      'darkMode': instance.darkMode,
      'showName': instance.showName,
      'allCapital': instance.allCapital,
    };
