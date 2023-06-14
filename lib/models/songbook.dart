import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/songbook_record.dart';

part 'songbook.freezed.dart';
part 'songbook.g.dart';

// prioritized songbook shortcuts in sorting
const prioritized = {'H1': 0, 'H2': 1, 'K': 2, 'Kan': 3};

@Freezed(toJson: false)
class Songbook with _$Songbook implements Comparable<Songbook>, Identifiable, SongsList {
  static const String fieldKey = 'songbooks';

  const Songbook._();

  @Entity(realClass: Songbook)
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory Songbook({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String name,
    @JsonKey(defaultValue: '') required String shortcut,
    String? color,
    String? colorText,
    required bool isPrivate,
    @Deprecated('is handled independently on model') bool? isPinned,
    @Backlink() @JsonKey(fromJson: _songbookRecordsFromJson) required ToMany<SongbookRecord> records,
  }) = _Songbook;

  factory Songbook.fromJson(Map<String, Object?> json) => _$SongbookFromJson(json);

  @override
  int compareTo(Songbook other) {
    if (prioritized.containsKey(shortcut) && prioritized.containsKey(other.shortcut)) {
      return prioritized[shortcut]!.compareTo(prioritized[other.shortcut]!);
    } else if (prioritized.containsKey(shortcut)) {
      return -1;
    } else if (prioritized.containsKey(other.shortcut)) {
      return 1;
    }

    return name.compareTo(other.name);
  }
}

ToMany<SongbookRecord> _songbookRecordsFromJson(List<dynamic>? jsonList) => ToMany();
