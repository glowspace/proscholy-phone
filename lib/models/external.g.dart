// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExternalImpl _$$ExternalImplFromJson(Map<String, dynamic> json) =>
    _$ExternalImpl(
      id: int.parse(json['id'] as String),
      publicName: json['public_name'] as String,
      mediaId: json['media_id'] as String?,
      url: json['url'] as String?,
      dbMediaType: MediaType.rawValueFromString(json['media_type'] as String?),
      songLyric: _songLyricFromJson(json['song_lyric']),
    );
