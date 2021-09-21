import 'package:collection/collection.dart';
import 'package:zpevnik/models/model.dart' as model;
import 'package:zpevnik/models/songbook_record.dart';

// prioritized songbook shortcuts in sorting
const prioritized = {'K': 0, 'Kan': 1, 'H1': 2, 'H2': 3};

// wrapper around Songbook db model for easier field access
class Songbook extends Comparable {
  final model.Songbook entity;

  Songbook(this.entity);

  static Future<List<Songbook>> get songbooks async {
    final entities = await model.Songbook().select().is_private.not.equals(true).orderBy('name').toList();

    final songbooks = List<Songbook>.empty(growable: true);

    for (final entity in entities) {
      final songbook = Songbook(entity);

      await songbook._preloadRecords();

      songbooks.add(songbook);
    }

    return songbooks;
  }

  Future<void> _preloadRecords() async {
    _records = (await entity.getSongbookRecords()?.toList())?.map((record) => SongbookRecord(record)).toList();

    _records?.sort((first, second) => compareNatural(first.number, second.number));
  }

  int get id => entity.id ?? 0;
  String get name => entity.name ?? '';
  String get shortcut => entity.shortcut ?? '';
  bool get isPinned => entity.is_pinned ?? false;
  String? get color => entity.color;

  List<SongbookRecord>? _records;

  List<SongbookRecord> get records => _records ?? [];

  void toggleIsPinned() {
    entity.is_pinned = !isPinned;

    entity.save();
  }

  @override
  int compareTo(_other) {
    Songbook other = _other;

    if (isPinned && !other.isPinned) return -1;
    if (!isPinned && other.isPinned) return 1;

    final priority = prioritized[shortcut];
    final otherPriority = prioritized[other.shortcut];

    if (priority != null && otherPriority != null) return priority.compareTo(otherPriority);

    if (priority != null) return -1;
    if (otherPriority != null) return 1;

    return name.compareTo(other.name);
  }
}
