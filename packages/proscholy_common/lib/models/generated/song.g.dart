// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Song _$SongFromJson(Map<String, dynamic> json) => _Song(
      id: int.parse(json['id'] as String),
      name: json['name'] as String,
      songLyrics: _songLyricsFromJson(json['song_lyrics'] as List?),
    );
