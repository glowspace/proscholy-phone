import 'package:zpevnik/models/model.dart' as model;

final RegExp _youtubeNameRE = RegExp(r'youtube \(([^|]+\|\s?)?(.+)\)');

// wrapper around External db model for easier field access
class External {
  final model.External entity;

  External(this.entity);

  // TODO: check if this is needed
  // External.clone(External external) : entity = external.entity;

  static Future<List<External>> get externals async {
    final entities = await model.External().select().toList();

    return entities.map((entity) => External(entity)).toList();
  }

  int get id => entity.id ?? 0;
  int get songLyricId => entity.song_lyricsId ?? 0;
  String get name {
    String name = entity.public_name ?? '';

    if (isYoutubeVideo) name = _youtubeNameRE.firstMatch(name)?.group(2) ?? name;

    return name;
  }

  String get mediaType => entity.media_type ?? '';
  String get mediaId => entity.media_id ?? '';

  bool get isYoutubeVideo => mediaType == 'youtube';
}
