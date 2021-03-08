import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/models/entities/entity.dart';
import 'package:zpevnik/models/entities/songbook_record.dart';
import 'package:zpevnik/utils/beans.dart';

class SongbookEntity implements Entity {
  @PrimaryKey()
  final int id;

  final String name;
  final String shortcut;

  @Column(isNullable: true)
  final String color;

  @Column(isNullable: true)
  final String colorText;

  final bool isPrivate;

  bool isPinned;

  @HasMany(SongbookRecordBean)
  List<SongbookRecord> records;

  SongbookEntity({
    this.id,
    this.name,
    this.shortcut,
    this.color,
    this.colorText,
    this.isPrivate,
    this.isPinned,
  });

  factory SongbookEntity.fromJson(Map<String, dynamic> json) => SongbookEntity(
        id: int.parse(json['id']),
        name: json['name'],
        shortcut: json['shortcut'],
        color: json['color'],
        colorText: json['color_text'],
        isPrivate: json['is_private'],
        isPinned: false,
      );
}
