import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/author.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song.dart';
import 'package:proscholy_common/models/song_lyric.dart';

import '../utils.dart';

void main() {
  final json = readTestData()[SongLyric.fieldKey] as List;

  group('from json', () {
    test('fields', () {
      final songLyric = SongLyric.fromJson(json[0]);

      expect(songLyric.id, 1);
      expect(songLyric.name, 'Ať srdce mé tebe vídá');
      expect(songLyric.secondaryName1, 'Otwórz me oczy');
      expect(songLyric.secondaryName2, isNull);
      expect(songLyric.lang, 'cs');
      expect(songLyric.langDescription, 'čeština');
      expect(songLyric.type, SongLyricType.translation);
      expect(songLyric.hasChords, isTrue);
      expect(songLyric.isArrangement, isFalse);
      expect(songLyric.song.targetId, 2560);
      expect(songLyric.authors.map((author) => author.id), [31, 32]);
      expect(songLyric.tags.map((tag) => tag.id), [16, 9]);
      expect(songLyric.externals.map((external) => external.id), [1, 861]);
      expect(songLyric.songbookRecords.map((songbookRecord) => songbookRecord.id), [3, 4001, 5001]);
    });

    test('type', () {
      expect(SongLyric.fromJson(json[1]).type, SongLyricType.original);
      expect(
        SongLyric.fromJson({...json[1], 'type_enum': 'AUTHORIZED_TRANSLATION'}).type,
        SongLyricType.authorizedTranslation,
      );
    });

    test('display id and name depend on target', () {
      final songLyric = SongLyric.fromJson(json[0]);

      if (isEZ) {
        expect(songLyric.displayId, '12');
        expect(songLyric.displayName, 'Ať mé srdce tebe vídá');
      } else if (isEK) {
        expect(songLyric.displayId, '7A');
        expect(songLyric.displayName, 'Ať srdce mé tebe vídá');
      } else {
        expect(songLyric.displayId, '1');
        expect(songLyric.displayName, 'Ať srdce mé tebe vídá');
      }
    });

    test('display name falls back to name', () {
      final songLyric = SongLyric.fromJson(json[1]);

      expect(songLyric.displayName, isEK ? 'Bože, chválí tě' : 'Bože, chválí tebe');
    });
  });

  group('getters', () {
    test('lyrics, files and recordings', () {
      final songLyric = SongLyric.fromJson(json[0]);

      expect(songLyric.hasLyrics, isTrue);
      expect(songLyric.hasFiles, isTrue);
      expect(songLyric.files.map((file) => file.id), [861]);
      expect(songLyric.hasRecordings, isTrue);
      expect(songLyric.shouldAppearToUser, isTrue);

      final withoutLyrics = createSongLyric(lyrics: '');

      expect(withoutLyrics.hasLyrics, isFalse);
      expect(withoutLyrics.shouldAppearToUser, isFalse);
    });

    test('default accidentals', () {
      expect(SongLyric.fromJson(json[0]).defaultAccidentals, 0);
      expect(SongLyric.fromJson(json[1]).defaultAccidentals, 1);
    });

    test('authors text of original', () {
      SongLyric withAuthors(List<String> names) => createSongLyric().copyWith(
        dbType: 0,
        authors: ToMany(
          items: [for (final (i, name) in names.indexed) Author(id: i, name: name)],
        ),
      );

      expect(withAuthors([]).authorsText, 'Autor neznámý');
      expect(withAuthors(['Jan']).authorsText, 'Autor: Jan');
      expect(withAuthors(['Jan', 'Eva']).authorsText, 'Autoři: Jan, Eva');
    });

    test('authors text of translation', () {
      final original =
          createSongLyric(
            id: 2,
            name: 'Original',
          ).copyWith(
            dbType: 0,
            authors: ToMany(items: [const Author(id: 1, name: 'Jan')]),
          );
      final song = Song(
        id: 1,
        songLyrics: ToMany(items: [original]),
      );
      final translation = createSongLyric().copyWith(dbType: 2, song: ToOne(target: song));

      expect(translation.authorsText, 'Originál: Original\nAutor: Jan, Autor překladu neznámý');
    });

    test('equality is by id', () {
      expect(createSongLyric(id: 1, name: 'a'), createSongLyric(id: 1, name: 'b'));
      expect(createSongLyric(id: 1), isNot(createSongLyric(id: 2)));
    });
  });

  group('externals', () {
    final externals = SongLyric.fromJson(json[0]).externals;

    test('media and content type', () {
      expect(externals[0].mediaType, MediaType.youtube);
      expect(externals[1].mediaType, MediaType.pdf);
      expect(externals[1].contentType, ContentType.score);
    });

    test('name', () {
      expect(externals[0].name, 'Schola brněnské mládeže (SBM)');
      expect(externals[1].name, 'at-srdce-me-tebe-vida.pdf');
    });

    test('media type from string', () {
      expect(MediaType.fromRawValue(MediaType.rawValueFromString('spotify')), MediaType.spotify);
      expect(MediaType.fromRawValue(MediaType.rawValueFromString('soundcloud')), MediaType.soundcloud);
      expect(MediaType.fromRawValue(MediaType.rawValueFromString('file/mp3')), MediaType.mp3);
      expect(MediaType.fromRawValue(MediaType.rawValueFromString(null)), MediaType.unsupported);
    });
  });
}
