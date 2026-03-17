import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/tag.dart';

const List<TagType> kSupportedTagTypes = isZPS
    ? [
        TagType.liturgyPart,
        TagType.liturgyPeriod,
        TagType.sacredOccasion,
        TagType.generic,
        TagType.saints,
        TagType.songbook,
        TagType.playlist,
        TagType.language,
      ]
    : [];

extension TagTypeView on TagType {
  String get title => switch (this) {
        TagType.liturgyPart => 'Mše svatá',
        TagType.liturgyPeriod => 'Liturgický rok',
        TagType.sacredOccasion => 'Svátosti a pobožnosti',
        TagType.generic => 'K příležitostem',
        TagType.saints => 'Ke svatým',
        TagType.songbook => 'Zpěvníky',
        TagType.playlist => 'Playlisty',
        TagType.language => 'Jazyky',
        _ => '',
      };
}

extension TagView on Tag {
  bool get isSupported => kSupportedTagTypes.contains(type);
}
