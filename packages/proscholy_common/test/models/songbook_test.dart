import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/models/songbook_record.dart';

import '../utils.dart';

Songbook _songbook(String name, String shortcut) {
  return Songbook(id: name.hashCode, name: name, shortcut: shortcut, isPrivate: false, records: ToMany());
}

void main() {
  test('from json', () {
    final songbooks = [for (final json in readTestData()[Songbook.fieldKey]) Songbook.fromJson(json)];

    expect(songbooks.map((songbook) => songbook.id), [9, 58, 63]);
    expect(songbooks[0].name, 'Chvalozpěvy 3');
    expect(songbooks[0].shortcut, '3Ch');
    expect(songbooks[0].color, '#1a237e');
    expect(songbooks[0].colorText, '#ffffff');
    expect(songbooks[0].isPrivate, isFalse);
    expect(songbooks[2].color, '');
    expect(songbooks[2].colorText, isNull);
  });

  test('prioritized songbooks are sorted first', () {
    final songbooks = [
      _songbook('A', 'A'),
      _songbook('Kancionál', 'Kan'),
      _songbook('Hosana 2', 'H2'),
      _songbook('B', 'B'),
      _songbook('Hosana 1', 'H1'),
      _songbook('Cesta', 'CSMOv'),
    ]..sort();

    expect(songbooks.map((songbook) => songbook.shortcut), ['CSMOv', 'H1', 'H2', 'Kan', 'A', 'B']);
  });

  test('songbook records are sorted naturally by number', () {
    SongbookRecord record(String number) {
      return SongbookRecord(id: number.hashCode, number: number, songLyric: ToOne(), songbook: ToOne());
    }

    final records = [record('10'), record('2'), record('2a'), record('1')]..sort();

    expect(records.map((record) => record.number), ['1', '2', '2a', '10']);
  });
}
