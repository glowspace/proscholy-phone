import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/models/tag.dart';

import '../utils.dart';

void main() {
  test('from json', () {
    final tags = [for (final json in readTestData()['tags_enum']) Tag.fromJson(json)];

    expect(tags.map((tag) => tag.id), [9, 16]);
    expect(tags.map((tag) => tag.type), [TagType.liturgyPart, TagType.sacredOccasion]);
    expect(tags[0].name, 'závěr');
    expect(tags[0].songLyricsCount, 425);
  });

  test('type from string', () {
    for (final type in TagType.values.where((type) => type != TagType.unknown)) {
      expect(TagType.fromRawValue(type.rawValue), type);
    }

    expect(TagType.fromRawValue(TagType.rawValueFromString('LITURGY_DAY')), TagType.liturgyDay);
    expect(TagType.fromRawValue(TagType.rawValueFromString('SOMETHING_NEW')), TagType.unknown);
  });

  test('songbook tag does not collide with API tags', () {
    final songbook = Songbook(id: 9, name: 'Chvalozpěvy 3', shortcut: '3Ch', isPrivate: false, records: ToMany());
    final tag = Tag.fromSongbook(songbook);

    expect(tag.id, kSongbookTagIdOffset - 9);
    expect(tag.type, TagType.songbook);
    expect(tag.name, 'Chvalozpěvy 3');
  });
}
