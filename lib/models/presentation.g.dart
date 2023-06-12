// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PresentationData _$$_PresentationDataFromJson(Map<String, dynamic> json) =>
    _$_PresentationData(
      songLyricId: json['songLyricId'] as int,
      songLyricName: json['songLyricName'] as String,
      lyrics: json['lyrics'] as String,
      settings: PresentationSettings.fromJson(
          json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PresentationDataToJson(_$_PresentationData instance) =>
    <String, dynamic>{
      'songLyricId': instance.songLyricId,
      'songLyricName': instance.songLyricName,
      'lyrics': instance.lyrics,
      'settings': instance.settings,
    };

_$_PresentationSettings _$$_PresentationSettingsFromJson(
        Map<String, dynamic> json) =>
    _$_PresentationSettings(
      showBackground: json['showBackground'] as bool,
      darkMode: json['darkMode'] as bool,
      showName: json['showName'] as bool,
      allCapital: json['allCapital'] as bool,
    );

Map<String, dynamic> _$$_PresentationSettingsToJson(
        _$_PresentationSettings instance) =>
    <String, dynamic>{
      'showBackground': instance.showBackground,
      'darkMode': instance.darkMode,
      'showName': instance.showName,
      'allCapital': instance.allCapital,
    };
