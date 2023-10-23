// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GlobalSettingsImpl _$$GlobalSettingsImplFromJson(Map<String, dynamic> json) =>
    _$GlobalSettingsImpl(
      darkModeEnabled: json['darkModeEnabled'] as bool?,
      seedColor: json['seedColor'] as int,
      fontSizeScale: (json['fontSizeScale'] as num).toDouble(),
      showChords: json['showChords'] as bool,
      showMusicalNotes: json['showMusicalNotes'] as bool,
      accidentals: json['accidentals'] as int,
      autoScrollSpeedIndex: json['autoScrollSpeedIndex'] as int,
    );

Map<String, dynamic> _$$GlobalSettingsImplToJson(
        _$GlobalSettingsImpl instance) =>
    <String, dynamic>{
      'darkModeEnabled': instance.darkModeEnabled,
      'seedColor': instance.seedColor,
      'fontSizeScale': instance.fontSizeScale,
      'showChords': instance.showChords,
      'showMusicalNotes': instance.showMusicalNotes,
      'accidentals': instance.accidentals,
      'autoScrollSpeedIndex': instance.autoScrollSpeedIndex,
    };
