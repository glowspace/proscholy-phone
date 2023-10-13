// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songbook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongbookImpl _$$SongbookImplFromJson(Map<String, dynamic> json) =>
    _$SongbookImpl(
      id: int.parse(json['id'] as String),
      name: json['name'] as String,
      shortcut: json['shortcut'] as String? ?? '',
      color: json['color'] as String?,
      colorText: json['color_text'] as String?,
      isPrivate: json['is_private'] as bool,
      isPinned: json['is_pinned'] as bool?,
      records: _songbookRecordsFromJson(json['records'] as List?),
    );
