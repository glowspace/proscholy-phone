import 'package:zpevnik/models/model.dart' as model;

// wrapper around PlaylistRecord db model for easier field access
class PlaylistRecord {
  final model.PlaylistRecord entity;

  PlaylistRecord(this.entity);

  static Future<PlaylistRecord> create(int songLyricId, int playlistId, int rank) async {
    final entity = model.PlaylistRecord(song_lyricsId: songLyricId, playlistsId: playlistId, rank: rank);

    entity.id = await entity.save();

    return PlaylistRecord(entity);
  }

  static Future<List<PlaylistRecord>> get playlistRecords async {
    final entities = await model.PlaylistRecord().select().toList();

    return entities.map((entity) => PlaylistRecord(entity)).toList();
  }

  int get id => entity.id ?? 0;
  int get playlistId => entity.playlistsId ?? 0;
  int get songLyricId => entity.song_lyricsId ?? 0;
  int get rank => entity.rank ?? 0;

  set rank(int value) {
    entity.rank = value;
    entity.upsert();
  }
}
