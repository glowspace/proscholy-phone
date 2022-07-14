// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/songbook_record.dart';

@Entity()
class Songbook {
  @Id(assignable: true)
  final int id;

  final String name;
  final String shortcut;

  final String? color;
  final String? colorText;

  final bool isPrivate;

  @Backlink()
  final songbookRecords = ToMany<SongbookRecord>();

  Songbook(
    this.id,
    this.name,
    this.shortcut,
    this.color,
    this.colorText,
    this.isPrivate,
  );

  factory Songbook.fromJson(Map<String, dynamic> json) {
    return Songbook(
      int.parse(json['id'] as String),
      json['name'] as String,
      json['shortcut'] as String? ?? '',
      json['color'] as String?,
      json['color_text'] as String?,
      json['is_private'] as bool,
    );
  }

  static List<Songbook> fromMapList(Map<String, dynamic> json) {
    return (json['songbooks'] as List).map((json) => Songbook.fromJson(json)).toList();
  }

  static List<Songbook> load(Store store) {
    final query = store.box<Songbook>().query(Songbook_.isPrivate.equals(false));
    query.order(Songbook_.name);

    return query.build().find();
  }

  @override
  String toString() => 'Songbook(id: $id, name: $name)';
}
