// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
      id: int.parse(json['id'] as String),
      name: json['name'] as String,
      dbType: TagType.rawValueFromString(json['type_enum'] as String),
      songLyricsCount: (json['song_lyrics_count'] as num).toInt(),
    );

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type_enum': instance.dbType,
      'song_lyrics_count': instance.songLyricsCount,
    };
