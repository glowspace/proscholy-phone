// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NewsItem _$$_NewsItemFromJson(Map<String, dynamic> json) => _$_NewsItem(
      id: int.parse(json['id'] as String),
      text: json['text'] as String,
      link: json['link'] as String,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );
