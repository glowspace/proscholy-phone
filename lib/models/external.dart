import 'package:zpevnik/models/model.dart' as model;

final RegExp _youtubeNameRE = RegExp(r'youtube \(([^|]+\|\s?)?(.+)\)');

// wrapper around External db model for easier field access
class External {
  final model.External entity;

  External(this.entity);

  External.clone(External external) : entity = external.entity;

  int get id => entity.id ?? 0;
  String get name {
    String name = entity.public_name ?? '';

    if (isYoutube) name = _youtubeNameRE.firstMatch(name)?.group(2) ?? name;

    return name;
  }

  String get mediaType => entity.media_type ?? '';
  String get mediaId => entity.media_id ?? '';

  bool get isYoutube => mediaType == 'youtube';
}
