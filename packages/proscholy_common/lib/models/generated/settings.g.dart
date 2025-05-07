// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GlobalSettings _$GlobalSettingsFromJson(Map<String, dynamic> json) =>
    _GlobalSettings(
      darkModeEnabled: json['darkModeEnabled'] as bool?,
      seedColor: (json['seedColor'] as num).toInt(),
      fontSizeScale: (json['fontSizeScale'] as num).toDouble(),
      showChords: json['showChords'] as bool,
      showMusicalNotes: json['showMusicalNotes'] as bool,
      accidentals: (json['accidentals'] as num).toInt(),
      autoScrollSpeedIndex: (json['autoScrollSpeedIndex'] as num).toInt(),
    );

Map<String, dynamic> _$GlobalSettingsToJson(_GlobalSettings instance) =>
    <String, dynamic>{
      'darkModeEnabled': instance.darkModeEnabled,
      'seedColor': instance.seedColor,
      'fontSizeScale': instance.fontSizeScale,
      'showChords': instance.showChords,
      'showMusicalNotes': instance.showMusicalNotes,
      'accidentals': instance.accidentals,
      'autoScrollSpeedIndex': instance.autoScrollSpeedIndex,
    };
