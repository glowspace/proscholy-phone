// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songbook_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SongbookRecord _$$_SongbookRecordFromJson(Map<String, dynamic> json) =>
    _$_SongbookRecord(
      id: int.parse(json['id'] as String),
      number: json['number'] as String,
      songLyric: songLyricFromJson(json['song_lyric'] as Map<String, dynamic>),
      songbook: songbookFromJson(json['songbook'] as Map<String, dynamic>),
    );
