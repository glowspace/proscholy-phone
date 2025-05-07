// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../songbook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Songbook _$SongbookFromJson(Map<String, dynamic> json) => _Songbook(
      id: int.parse(json['id'] as String),
      name: json['name'] as String,
      shortcut: json['shortcut'] as String? ?? '',
      color: json['color'] as String?,
      colorText: json['color_text'] as String?,
      isPrivate: json['is_private'] as bool,
      isPinned: json['is_pinned'] as bool?,
      records: _songbookRecordsFromJson(json['records'] as List?),
    );
