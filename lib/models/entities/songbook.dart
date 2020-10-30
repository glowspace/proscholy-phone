import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/songbook_record.dart';
import 'package:zpevnik/utils/beans.dart';

class SongbookEntity {
  @PrimaryKey()
  final int id;

  final String name;
  final String shortcut;

  @Column(isNullable: true)
  final String color;

  final bool isPrivate;

  @HasMany(SongbookRecordBean)
  List<SongbookRecord> records;

  SongbookEntity({
    this.id,
    this.name,
    this.shortcut,
    this.color,
    this.isPrivate,
  });

  factory SongbookEntity.fromJson(Map<String, dynamic> json) => SongbookEntity(
        id: int.parse(json['id']),
        name: json['name'],
        shortcut: json['shortcut'],
        color: json['color'],
        isPrivate: json['is_private'],
      );
}
