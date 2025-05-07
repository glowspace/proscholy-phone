// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../songbook_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SongbookRecord _$SongbookRecordFromJson(Map<String, dynamic> json) =>
    _SongbookRecord(
      id: int.parse(json['id'] as String),
      number: json['number'] as String,
      songLyric: _songLyricFromJson(json['song_lyric'] as Map<String, dynamic>),
      songbook: _songbookFromJson(json['songbook'] as Map<String, dynamic>),
    );
