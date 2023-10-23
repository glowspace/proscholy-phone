import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';

part 'external.freezed.dart';
part 'external.g.dart';

// `publicName` property of `External` is in this format "(NAME | AUTHOR_NAME)", this regex will extract only NAME from this
final RegExp _nameRe = RegExp(r'\(([^|]+\|\s?)?(.+)\)');

enum MediaType {
  soundcloud,
  spotify,
  youtube,
  mp3,
  pdf,
  jpg,
  unsupported;

  factory MediaType.fromRawValue(int rawValue) {
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
      case 5:
        return MediaType.jpg;
      default:
        return MediaType.unsupported;
    }
  }

  static int rawValueFromString(String? string) {
    switch (string) {
      case "spotify":
        return 0;
      case "soundcloud":
        return 1;
      case "youtube":
        return 2;
      case "file/mp3":
        return 3;
      case "file/pdf":
        return 4;
      case "file/jpg":
        return 5;
      default:
        return -1;
    }
  }
}

@Freezed(toJson: false)
class External with _$External implements Identifiable {
  static const String fieldKey = 'externals';

  const External._();

  @Entity(realClass: External)
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
  const factory External({
    @Id(assignable: true) @JsonKey(fromJson: int.parse) required int id,
    required String publicName,
    String? mediaId,
    String? url,
    @JsonKey(name: 'media_type', fromJson: MediaType.rawValueFromString) required int dbMediaType,
  }) = _External;

  factory External.fromJson(Map<String, Object?> json) => _$ExternalFromJson(json);

  String get name {
    final name = _nameRe.firstMatch(publicName)?.group(2) ?? publicName;

    switch (mediaType) {
      case MediaType.pdf:
        return mediaId ?? name;
      case MediaType.jpg:
        return mediaId ?? name;
      default:
        return name;
    }
  }

  MediaType get mediaType => MediaType.fromRawValue(dbMediaType);
}
