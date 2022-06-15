import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/song_lyric.dart';

final RegExp _nameAuthorRE = RegExp(r'\(([^|]+\|\s?)?(.+)\)');

enum MediaType {
  soundcloud,
  spotify,
  youtube,
  mp3,
  pdf,
  unsupported,
}

extension MediaTypeExtension on MediaType {
  static MediaType fromString(String? string) {
    switch (string) {
      case "spotify":
        return MediaType.spotify;
      case "soundcloud":
        return MediaType.soundcloud;
      case "youtube":
        return MediaType.youtube;
      case "file/mp3":
        return MediaType.mp3;
      case "file/pdf":
        return MediaType.pdf;
      default:
        return MediaType.unsupported;
    }
  }

  static MediaType fromRawValue(int rawValue) {
    switch (rawValue) {
      case 0:
        return MediaType.spotify;
      case 1:
        return MediaType.soundcloud;
      case 2:
        return MediaType.youtube;
      case 3:
        return MediaType.mp3;
      case 4:
        return MediaType.pdf;
      default:
        return MediaType.unsupported;
    }
  }

  int get rawValue {
    switch (this) {
      case MediaType.spotify:
        return 0;
      case MediaType.soundcloud:
        return 1;
      case MediaType.youtube:
        return 2;
      case MediaType.mp3:
        return 3;
      case MediaType.pdf:
        return 4;
      default:
        return 5;
    }
  }
}

@Entity()
class External {
  @Id(assignable: true)
  final int id;

  final String? publicName;
  final String? mediaId;

  final String? url;

  final int dbMediaType;

  final songLyric = ToOne<SongLyric>();

  External(
    this.id,
    this.publicName,
    this.mediaId,
    this.url,
    this.dbMediaType,
  );

  factory External.fromJson(Map<String, dynamic> json, int songLyricId) {
    return External(
      int.parse(json['id'] as String),
      json['public_name'] as String?,
      json['media_id'] as String?,
      json['url'] as String?,
      MediaTypeExtension.fromString(json['media_type'] as String?).rawValue,
    );
  }

  static List<External> fromMapList(Map<String, dynamic> json, int songLyricId) {
    return (json['externals'] as List).map((json) => External.fromJson(json, songLyricId)).toList();
  }

  String get name {
    final name = publicName ?? '';

    switch (type) {
      case MediaType.youtube:
        return _nameAuthorRE.firstMatch(name)?.group(2) ?? name;
      case MediaType.pdf:
        return mediaId ?? _nameAuthorRE.firstMatch(name)?.group(2) ?? name;
      default:
        return name;
    }
  }

  MediaType get type => MediaTypeExtension.fromRawValue(dbMediaType);

  @override
  String toString() => 'External(id: $id, name: $name)';
}
