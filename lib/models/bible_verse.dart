import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/playlist_record.dart';

part 'bible_verse.freezed.dart';

@freezed
class BibleVerse with _$BibleVerse implements Identifiable {
  @Entity(realClass: BibleVerse)
  const factory BibleVerse({
    @Id(assignable: true) required int id,
    required int book,
    required int chapter,
    required int startVerse,
    int? endVerse,
    required String text,
    @Backlink() required ToMany<PlaylistRecord> playlistRecords,
  }) = _BibleVerse;
}
