// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Tag _$$_TagFromJson(Map<String, dynamic> json) => _$_Tag(
      id: int.parse(json['id'] as String),
      name: json['name'] as String,
      dbType: TagType.rawValueFromString(json['type_enum'] as String),
    );
