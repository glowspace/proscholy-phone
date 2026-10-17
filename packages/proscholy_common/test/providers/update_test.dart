import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:proscholy_common/models/news_item.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/providers/update.dart';
import 'package:proscholy_common/utils/client.dart';

import '../utils.dart';

class _MockClient extends Mock implements Client {}

class _FakeSvgs extends Svgs {
  @override
  Map<String, FileSystemEntity> build() => {};

  @override
  Future<void> storeSvgs(List<int> bytes) async {}
}

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

void main() {
  setUpAll(() => registerFallbackValue(DateTime(0)));

  group('load initial', () {
    test('stores data from assets on first start', () async {
      await mockDocumentsDirectory();
      mockAsset('assets/data.json', jsonEncode({'data': readTestData()}));

      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});

      await loadInitial(appDependencies);

      expect(appDependencies.store.box<SongLyric>().getAll().map((songLyric) => songLyric.id), [1, 2]);
      expect(appDependencies.sharedPreferences.getString('current_version'), '1.0.0+1');
      expect(appDependencies.sharedPreferences.getString('last_update'), isNull);

      await eventually(() async {
        expect(await appDependencies.ftsDatabase.query('song_lyrics_search'), hasLength(2));
      });
    });

    test('does not store data again for same version', () async {
      await mockDocumentsDirectory();

      final appDependencies = await createAppDependencies(preferences: {'current_version': '1.0.0+1'});

      await loadInitial(appDependencies);

      expect(appDependencies.store.box<SongLyric>().isEmpty(), isTrue);
    });

    test('removes received playlist files', () async {
      final directory = await mockDocumentsDirectory();
      final playlistFile = File('${directory.path}/Playlist.proscholy')..writeAsStringSync('{}');
      final otherFile = File('${directory.path}/other.txt')..writeAsStringSync('');

      final appDependencies = await createAppDependencies(preferences: {'current_version': '1.0.0+1'});

      await loadInitial(appDependencies);

      await eventually(() => expect(playlistFile.existsSync(), isFalse));
      expect(otherFile.existsSync(), isTrue);
    });
  });

  group('update', () {
    late _MockClient client;
    late List<dynamic> songLyricsJson;

    ProviderContainer createUpdateContainer(AppDependencies appDependencies) {
      return createContainer(
        appDependencies,
        overrides: [graphQLClientProvider.overrideWithValue(client), svgsProvider.overrideWith(_FakeSvgs.new)],
      );
    }

    setUp(() async {
      await mockDocumentsDirectory();

      final data = readTestData();

      songLyricsJson = data[SongLyric.fieldKey];
      client = _MockClient();

      when(() => client.getNews()).thenAnswer(
        (_) async => {
          'news_items': [
            {'id': '1', 'text': 'Novinka', 'link': 'https://zpevnik.proscholy.cz', 'expires_at': null},
          ],
        },
      );
      when(() => client.getData()).thenAnswer(
        (_) async => {
          ...data,
          SongLyric.fieldKey: [
            for (final json in songLyricsJson) {'id': json['id']},
          ],
        },
      );
      when(() => client.getSvgs(any())).thenAnswer((_) async => []);
    });

    test('stores news and does not update during update period', () async {
      final appDependencies = await createAppDependencies(
        preferences: {'last_update': _dateFormat.format(DateTime.now().toUtc())},
      );

      createUpdateContainer(appDependencies).listen(updateProvider, (_, _) {});

      await untilCalled(() => client.getNews());
      await pumpEventQueue();

      expect(appDependencies.store.box<NewsItem>().getAll().map((newsItem) => newsItem.text), ['Novinka']);
      verifyNever(() => client.getData());
    });

    test('does not fail without connection', () async {
      when(() => client.getNews()).thenThrow(const SocketException('offline'));

      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});
      final states = <AsyncValue<UpdateStatus>>[];

      createUpdateContainer(appDependencies).listen(updateProvider, (_, state) => states.add(state));

      await untilCalled(() => client.getNews());
      await pumpEventQueue();

      expect(states.whereType<AsyncError>(), isEmpty);
      verifyNever(() => client.getData());
    });

    test('stores updated and missing song lyrics and removes deleted ones', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});
      final box = appDependencies.store.box<SongLyric>();

      // song lyric 99 is no longer on server
      box.put(createSongLyric(id: 99));

      when(() => client.getSongLyrics(any())).thenAnswer(
        (_) async => {
          SongLyric.fieldKey: [
            <String, dynamic>{...songLyricsJson[1], 'name': 'Bože, chválíme tebe'},
          ],
        },
      );
      when(() => client.getSongLyric(1)).thenAnswer((_) async => songLyricsJson[0]);
      when(() => client.getSongLyric(3)).thenAnswer((_) async => songLyricsJson[2]);

      final states = <UpdateStatus>[];
      final updated = Completer<List<SongLyric>>();

      createUpdateContainer(appDependencies).listen(updateProvider, (_, state) {
        switch (state) {
          case AsyncData(:final value):
            states.add(value);

            if (value is Updated) updated.complete(value.songLyrics);
          case AsyncError(:final error, :final stackTrace):
            updated.completeError(error, stackTrace);
          default:
        }
      });

      final updatedSongLyrics = await updated.future.timeout(const Duration(seconds: 5));

      expect(states.first, isA<Updating>());
      expect(updatedSongLyrics.map((songLyric) => songLyric.id), [2, 1]);
      expect(box.get(99), isNull);
      expect(box.get(1), isNotNull);
      expect(box.get(2)!.name, 'Bože, chválíme tebe');

      await eventually(() async {
        expect(await appDependencies.ftsDatabase.query('song_lyrics_search'), hasLength(2));
        expect(appDependencies.sharedPreferences.getString('last_update'), isNot('2026-01-01 00:00:00'));
      });
    });
  });
}
