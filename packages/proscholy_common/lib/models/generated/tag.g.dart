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
