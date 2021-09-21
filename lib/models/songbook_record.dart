import 'package:zpevnik/models/model.dart' as model;

// wrapper around SongbookRecord db model for easier field access
class SongbookRecord {
  final model.SongbookRecord entity;

  SongbookRecord(this.entity);

  int get id => entity.id ?? 0;
  int get songLyricId => entity.song_lyricsId ?? 0;
  int get songbookId => entity.songbooksId ?? 0;
  String get number => entity.number ?? '';
}
