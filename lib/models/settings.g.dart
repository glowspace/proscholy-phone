// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GlobalSettings _$$_GlobalSettingsFromJson(Map<String, dynamic> json) =>
    _$_GlobalSettings(
      darkModeEnabled: json['darkModeEnabled'] as bool?,
      seedColor: json['seedColor'] as int,
      fontSizeScale: (json['fontSizeScale'] as num).toDouble(),
      showChords: json['showChords'] as bool,
      showMusicalNotes: json['showMusicalNotes'] as bool,
      accidentals: json['accidentals'] as int,
      autoScrollSpeedIndex: json['autoScrollSpeedIndex'] as int,
    );

Map<String, dynamic> _$$_GlobalSettingsToJson(_$_GlobalSettings instance) =>
    <String, dynamic>{
      'darkModeEnabled': instance.darkModeEnabled,
      'seedColor': instance.seedColor,
      'fontSizeScale': instance.fontSizeScale,
      'showChords': instance.showChords,
      'showMusicalNotes': instance.showMusicalNotes,
      'accidentals': instance.accidentals,
      'autoScrollSpeedIndex': instance.autoScrollSpeedIndex,
    };
