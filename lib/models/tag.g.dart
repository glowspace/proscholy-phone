// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagImpl _$$TagImplFromJson(Map<String, dynamic> json) => _$TagImpl(
      id: int.parse(json['id'] as String),
      name: json['name'] as String,
      dbType: TagType.rawValueFromString(json['type_enum'] as String),
    );
