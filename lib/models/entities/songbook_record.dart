import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:zpevnik/utils/beans.dart';

class SongbookRecord {
  @PrimaryKey()
  final int id;

  final String number;

  @BelongsTo(SongLyricBean)
  int songLyricId;

  @BelongsTo(SongbookBean)
  int songbookId;

  SongbookRecord({this.id, this.number});

  factory SongbookRecord.fromJson(Map<String, dynamic> json) => SongbookRecord(
        id: int.parse(json['id']),
        number: json['number'],
      )..songbookId = int.parse(json['songbook']['id']);
}
