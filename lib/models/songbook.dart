import 'package:objectbox/objectbox.dart';
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

  @override
  String toString() => 'Songbook(id: $id, name: $name)';
}


// import 'package:zpevnik/models/model.dart' as model;
// import 'package:zpevnik/models/songbook_record.dart';

// // prioritized songbook shortcuts in sorting
// const prioritized = {'K': 0, 'Kan': 1, 'H1': 2, 'H2': 3};

// // wrapper around Songbook db model for easier field access
// class Songbook extends Comparable<Songbook> {
//   final model.Songbook entity;

//   Songbook(this.entity);

//   static Future<List<Songbook>> get songbooks async {
//     final entities = await model.Songbook().select().is_private.not.equals(true).orderBy('name').toList();

//     return entities.map((entity) => Songbook(entity)).toList();
//   }

//   final List<SongbookRecord> records = [];

//   int get id => entity.id ?? 0;
//   String get name => entity.name ?? '';
//   String get shortcut => entity.shortcut ?? '';
//   bool get isPinned => entity.is_pinned ?? false;
//   String? get color => entity.color;
//   String? get colorText => entity.color_text;

//   void toggleIsPinned() {
//     entity.is_pinned = !isPinned;

//     entity.save();
//   }

//   @override
//   int compareTo(Songbook other) {
//     if (isPinned && !other.isPinned) return -1;
//     if (!isPinned && other.isPinned) return 1;

//     final priority = prioritized[shortcut];
//     final otherPriority = prioritized[other.shortcut];

//     if (priority != null && otherPriority != null) return priority.compareTo(otherPriority);

//     if (priority != null) return -1;
//     if (otherPriority != null) return 1;

//     return name.compareTo(other.name);
//   }
// }
