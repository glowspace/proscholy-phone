// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongImpl _$$SongImplFromJson(Map<String, dynamic> json) => _$SongImpl(
      id: int.parse(json['id'] as String),
      name: json['name'] as String,
      songLyrics: _songLyricsFromJson(json['song_lyrics'] as List?),
    );
