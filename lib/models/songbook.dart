// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/songbook_record.dart';

// prioritized songbook shortcuts in sorting
const prioritized = {'H1': 0, 'H2': 1, 'K': 2, 'Kan': 3};

@Entity()
class Songbook implements Comparable<Songbook> {
  @Id(assignable: true)
  final int id;

  final String name;
  final String shortcut;

  final String? color;
  final String? colorText;

  final bool isPrivate;
  bool isPinned = false;

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
    return store.box<Songbook>().query(Songbook_.isPrivate.equals(false)).build().find();
  }

  @override
  String toString() => 'Songbook(id: $id, name: $name)';

  @override
  int compareTo(Songbook other) {
    if (prioritized.containsKey(shortcut) && prioritized.containsKey(other.shortcut)) {
      return prioritized[shortcut]!.compareTo(prioritized[other.shortcut]!);
    } else if (prioritized.containsKey(shortcut)) {
      return -1;
    } else if (prioritized.containsKey(other.shortcut)) {
      return 1;
    }

    if (isPinned && !other.isPinned) {
      return -1;
    } else if (!isPinned && other.isPinned) {
      return 1;
    }

    return name.compareTo(other.name);
  }
}
