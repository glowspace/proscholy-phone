// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_External _$$_ExternalFromJson(Map<String, dynamic> json) => _$_External(
      id: int.parse(json['id'] as String),
      publicName: json['public_name'] as String,
      mediaId: json['media_id'] as String?,
      url: json['url'] as String?,
      dbMediaType: MediaType.rawValueFromString(json['media_type'] as String?),
    );
