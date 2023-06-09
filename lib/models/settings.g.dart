// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GlobalSettings _$$_GlobalSettingsFromJson(Map<String, dynamic> json) =>
    _$_GlobalSettings(
      darkModeEnabled: json['darkModeEnabled'] as bool?,
      fontSizeScale: (json['fontSizeScale'] as num).toDouble(),
      showChords: json['showChords'] as bool,
      accidentals: json['accidentals'] as int,
    );

Map<String, dynamic> _$$_GlobalSettingsToJson(_$_GlobalSettings instance) =>
    <String, dynamic>{
      'darkModeEnabled': instance.darkModeEnabled,
      'fontSizeScale': instance.fontSizeScale,
      'showChords': instance.showChords,
      'accidentals': instance.accidentals,
    };
