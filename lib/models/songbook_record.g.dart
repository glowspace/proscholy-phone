// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songbook_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongbookRecordImpl _$$SongbookRecordImplFromJson(Map<String, dynamic> json) =>
    _$SongbookRecordImpl(
      id: int.parse(json['id'] as String),
      number: json['number'] as String,
      songLyric: _songLyricFromJson(json['song_lyric'] as Map<String, dynamic>),
      songbook: _songbookFromJson(json['songbook'] as Map<String, dynamic>),
    );
