import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart' hide Store;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:proscholy_common/models/author.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/news_item.dart';
import 'package:proscholy_common/models/playlist.dart';
import 'package:proscholy_common/models/playlist_record.dart';
import 'package:proscholy_common/models/settings.dart';
import 'package:proscholy_common/models/song.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/models/songbook_record.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/playlists.dart';
import 'package:proscholy_common/providers/settings.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/providers/update.dart';
import 'package:proscholy_common/utils/api_client.dart';
import 'package:proscholy_common/utils/data.dart';

import '../utils.dart';

class _MockClient extends Mock implements ApiClient {}

class _FakeSvgs extends Svgs {
  @override
  Map<String, FileSystemEntity> build() => {};

  @override
  Future<void> storeSvgs(List<int> bytes) async {}
}

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

// same as reported by users, server responded with status code 500
final _serverError = OperationException(
  linkException: ServerException(
    parsedResponse: const Response(response: {'message': 'Server Error'}, context: Context()),
  ),
);

// request could not be sent, e.g. without internet
final _connectionError = OperationException(
  linkException: ServerException(originalException: http.ClientException('Failed host lookup')),
);

// relations of all stored song lyrics, songbooks and playlists
Map<String, Object?> _relations(Store store) {
  List<int> ids(Iterable<Object> objects) => [for (final object in objects) (object as dynamic).id as int]..sort();

  return {
    for (final songLyric in store.box<SongLyric>().getAll())
      'song lyric ${songLyric.id}': {
        'song': songLyric.song.targetId,
        'authors': ids(songLyric.authors),
        'tags': ids(songLyric.tags),
        'externals': ids(songLyric.externals),
        'songbook records': ids(songLyric.songbookRecords),
        'playlist records': ids(songLyric.playlistRecords),
      },
    for (final songbook in store.box<Songbook>().getAll()) 'songbook ${songbook.id}': ids(songbook.records),
    for (final playlist in store.box<Playlist>().getAll()) 'playlist ${playlist.id}': ids(playlist.records),
    for (final record in store.box<SongbookRecord>().getAll())
      'songbook record ${record.id}': [record.songLyric.targetId, record.songbook.targetId, record.number],
    for (final external in store.box<External>().getAll()) 'external ${external.id}': external.songLyric.targetId,
    for (final settings in store.box<SongLyricSettingsModel>().getAll())
      'settings ${settings.id}': [settings.songLyric.targetId, settings.transposition],
  };
}

void main() {
  setUpAll(() => registerFallbackValue(DateTime(0)));

  group('load initial', () {
    test('stores data from assets on first start', () async {
      await mockDocumentsDirectory();
      mockAsset('assets/data.json', utf8.encode(jsonEncode({'data': readTestData()})));

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

  test('relations of removed song lyrics are removed', () async {
    await mockDocumentsDirectory();

    final appDependencies = await createAppDependencies(preferences: {'current_version': '1.0.0+1'});
    final store = appDependencies.store;
    final data = readTestData();

    await parseAndStoreData(store, data);
    await storeSongLyrics(store, readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson));

    store.box<PlaylistRecord>().put(
      PlaylistRecord(
        id: 1,
        rank: 0,
        songLyric: ToOne(targetId: 1),
        userText: ToOne(),
        biblePassage: ToOne(),
        playlist: ToOne(targetId: 1),
      ),
    );

    // removed during update, as it was removed on server
    store.box<SongLyric>().remove(1);

    await loadInitial(appDependencies);

    await eventually(() {
      expect(store.box<External>().isEmpty(), isTrue);
      expect(store.box<SongbookRecord>().getAll().map((songbookRecord) => songbookRecord.songLyric.targetId), [2, 2]);
    });
    expect(store.box<PlaylistRecord>().get(1), isNull);
  });

  test('playlist records without playlist are removed', () async {
    await mockDocumentsDirectory();

    final appDependencies = await createAppDependencies(preferences: {'current_version': '1.0.0+1'});
    final box = appDependencies.store.box<PlaylistRecord>();

    box.putMany([
      PlaylistRecord(
        id: 1,
        rank: 0,
        songLyric: ToOne(),
        userText: ToOne(targetId: 1),
        biblePassage: ToOne(),
        playlist: ToOne(targetId: 1),
      ),
      PlaylistRecord(
        id: 2,
        rank: 0,
        songLyric: ToOne(),
        userText: ToOne(targetId: 2),
        biblePassage: ToOne(),
        playlist: ToOne(),
      ),
    ]);

    await loadInitial(appDependencies);

    expect(box.getAll().map((playlistRecord) => playlistRecord.id), [1]);
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

    // runs update and returns all its statuses until it finishes
    Future<List<UpdateStatus>> runUpdate(AppDependencies appDependencies) {
      final states = <UpdateStatus>[];
      final finished = Completer<List<UpdateStatus>>();

      createUpdateContainer(appDependencies).listen(updateProvider, (_, state) {
        switch (state) {
          case AsyncData(:final value):
            states.add(value);

            if (value is Updated || value is UpdateInterrupted) finished.complete(states);
          case AsyncError(:final error, :final stackTrace):
            finished.completeError(error, stackTrace);
          default:
        }
      });

      return finished.future.timeout(const Duration(seconds: 5));
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
            for (final json in songLyricsJson) {'id': json['id'], 'is_arrangement': json['is_arrangement']},
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

      final states = await runUpdate(appDependencies);

      expect(states.first, isA<Updating>());
      expect((states.last as Updated).songLyrics.map((songLyric) => songLyric.id), [2, 1]);
      expect(box.get(99), isNull);
      expect(box.get(1), isNotNull);
      expect(box.get(2)!.name, 'Bože, chválíme tebe');

      expect(await appDependencies.ftsDatabase.query('song_lyrics_search'), hasLength(2));

      await eventually(
        () => expect(appDependencies.sharedPreferences.getString('last_update'), isNot('2026-01-01 00:00:00')),
      );
    });

    test('fetches lists of everything only once a day', () async {
      final appDependencies = await createAppDependencies(
        preferences: {
          'last_update': '2026-01-01 00:00:00',
          'last_full_update': _dateFormat.format(DateTime.now().toUtc()),
        },
      );
      final box = appDependencies.store.box<SongLyric>();

      // song lyric 99 would be removed by full update
      box.put(createSongLyric(id: 99));

      when(() => client.getSongbooks()).thenAnswer((_) async => {Songbook.fieldKey: readTestData()[Songbook.fieldKey]});
      when(() => client.getSongLyrics(any())).thenAnswer(
        (_) async => {
          SongLyric.fieldKey: [
            <String, dynamic>{
              ...songLyricsJson[1],
              'authors_pivot': [
                {
                  'pivot': {
                    'author': {'id': '99', 'name': 'Nový autor'},
                  },
                },
              ],
            },
          ],
        },
      );

      await runUpdate(appDependencies);

      verifyNever(() => client.getData());
      expect(box.get(99), isNotNull);
      expect(box.get(2)!.songbookRecords, isNotEmpty);
      // new authors are searchable before the next full update
      expect(appDependencies.store.box<Author>().get(99)!.name, 'Nový autor');
      expect(await appDependencies.ftsDatabase.query('song_lyrics_search', where: 'rowid = 2'), [
        containsPair('authors', 'Nový autor'),
      ]);
    });

    test('songbook removed on server is removed with its records before the next full update', () async {
      final appDependencies = await createAppDependencies(
        preferences: {
          'last_update': '2026-01-01 00:00:00',
          'last_full_update': _dateFormat.format(DateTime.now().toUtc()),
        },
      );
      final store = appDependencies.store;

      await storeTestData(appDependencies);

      store.box<Songbook>().put(Songbook(id: 99, name: 'Zpěvník', shortcut: 'Z', isPrivate: false, records: ToMany()));
      store.box<SongbookRecord>().put(
        SongbookRecord(id: 99, number: '1', songLyric: ToOne(targetId: 1), songbook: ToOne(targetId: 99)),
      );

      when(() => client.getSongbooks()).thenAnswer((_) async => {Songbook.fieldKey: readTestData()[Songbook.fieldKey]});
      when(() => client.getSongLyrics(any())).thenAnswer((_) async => {SongLyric.fieldKey: []});

      await runUpdate(appDependencies);

      verifyNever(() => client.getData());
      expect(store.box<Songbook>().get(99), isNull);
      expect(store.box<SongbookRecord>().get(99), isNull);
      expect(store.box<SongLyric>().get(1)!.songbookRecords, hasLength(3));
    });

    test('update requested by user is full and starts right away', () async {
      final now = _dateFormat.format(DateTime.now().toUtc());
      final appDependencies = await createAppDependencies(
        preferences: {'last_update': now, 'last_full_update': now},
      );
      final container = createUpdateContainer(appDependencies);
      final states = <UpdateStatus>[];

      when(() => client.getSongLyrics(any())).thenAnswer((_) async => {SongLyric.fieldKey: []});

      container.listen(updateProvider, (_, state) {
        if (state.value case final status?) states.add(status);
      });
      await pumpEventQueue();

      expect(states, isEmpty);

      container.read(updateRequestsProvider.notifier).request();

      await eventually(() => expect(states, contains(isA<Updated>())));
      verify(() => client.getData()).called(1);
    });

    test('keeps relations of song lyrics and user data', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});
      final store = appDependencies.store;

      await storeTestData(appDependencies);

      final container = createUpdateContainer(appDependencies);
      final playlists = container.read(playlistsProvider.notifier);
      final playlist = playlists.addPlaylist(Playlist.empty('Mše'));

      container.read(playlistProvider(playlist.id).notifier).addSongLyric(store.box<SongLyric>().get(1)!);
      container.read(playlistProvider(playlist.id).notifier).addSongLyric(store.box<SongLyric>().get(2)!);
      playlists.toggleFavorite(store.box<SongLyric>().get(1)!);
      container.read(songLyricSettingsProvider(1).notifier).changeTransposition(2);

      final relations = _relations(store);

      expect(relations['song lyric 1'], {
        'song': isNot(0),
        'authors': hasLength(2),
        'tags': hasLength(2),
        'externals': hasLength(2),
        'songbook records': hasLength(3),
        'playlist records': hasLength(2),
      });
      expect(relations.keys, contains(startsWith('settings')));

      when(
        () => client.getSongLyrics(any()),
      ).thenAnswer((_) async => {SongLyric.fieldKey: songLyricsJson.sublist(1, 2)});

      await runUpdate(appDependencies);

      expect(_relations(store), relations);
    });

    test('removes authors, songs, songbooks and tags removed on server', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});
      final store = appDependencies.store;

      await storeTestData(appDependencies);

      store.box<Author>().put(const Author(id: 99, name: 'Autor'));
      store.box<Song>().put(Song(id: 99, songLyrics: ToMany()));
      store.box<Tag>().put(const Tag(id: 99, name: 'Štítek', dbType: 0, songLyricsCount: 1));
      store.box<Songbook>().put(Songbook(id: 99, name: 'Zpěvník', shortcut: 'Z', isPrivate: false, records: ToMany()));
      store.box<SongbookRecord>().put(
        SongbookRecord(id: 99, number: '1', songLyric: ToOne(targetId: 1), songbook: ToOne(targetId: 99)),
      );

      when(() => client.getSongLyrics(any())).thenAnswer((_) async => {SongLyric.fieldKey: []});

      await runUpdate(appDependencies);

      expect(store.box<Author>().get(99), isNull);
      expect(store.box<Song>().get(99), isNull);
      expect(store.box<Tag>().get(99), isNull);
      expect(store.box<Songbook>().get(99), isNull);
      expect(store.box<SongbookRecord>().get(99), isNull);
      expect(store.box<SongLyric>().get(1)!.songbookRecords, hasLength(3));
    });

    // more likely an error on server, everything would be removed otherwise
    test('empty lists from server do not remove anything', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});
      final store = appDependencies.store;

      await storeTestData(appDependencies);

      when(() => client.getData()).thenAnswer(
        (_) async => {
          Author.fieldKey: [],
          Song.fieldKey: [],
          Songbook.fieldKey: [],
          'tags_enum': [],
          SongLyric.fieldKey: [
            for (final json in songLyricsJson) {'id': json['id'], 'is_arrangement': json['is_arrangement']},
          ],
        },
      );
      when(() => client.getSongLyrics(any())).thenAnswer((_) async => {SongLyric.fieldKey: []});

      await runUpdate(appDependencies);

      expect(store.box<Author>().count(), 2);
      expect(store.box<Songbook>().count(), 3);
      expect(store.box<SongbookRecord>().count(), 5);
      expect(store.box<Tag>().count(), 2);
    });

    test('empty list of song lyrics from server does not remove them from playlists', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});
      final store = appDependencies.store;

      await storeTestData(appDependencies);

      createUpdateContainer(
        appDependencies,
      ).read(playlistsProvider.notifier).toggleFavorite(store.box<SongLyric>().get(1)!);

      when(() => client.getData()).thenAnswer((_) async => {...readTestData(), SongLyric.fieldKey: []});
      when(() => client.getSongLyrics(any())).thenAnswer((_) async => {SongLyric.fieldKey: []});

      await runUpdate(appDependencies);

      expect(store.box<SongLyric>().count(), 2);
      expect(store.box<PlaylistRecord>().getAll().map((playlistRecord) => playlistRecord.songLyric.targetId), [1]);
    });

    test('does not fetch arrangements and keeps the ones stored by older versions', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});

      appDependencies.store.box<SongLyric>().put(createSongLyric(id: 3));

      when(() => client.getSongLyrics(any())).thenAnswer(
        (_) async => {SongLyric.fieldKey: songLyricsJson.sublist(0, 2)},
      );

      await runUpdate(appDependencies);

      verifyNever(() => client.getSongLyric(any()));
      expect(appDependencies.store.box<SongLyric>().get(3), isNotNull);
    });

    test('removes records of shared playlist with song lyrics that are not on server', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});

      when(() => client.getData()).thenAnswer(
        (_) async => {
          ...readTestData(),
          SongLyric.fieldKey: [
            {'id': '1', 'is_arrangement': false},
            {'id': '3', 'is_arrangement': true},
            {'id': '5', 'is_arrangement': false},
          ],
        },
      );
      when(() => client.getSongLyrics(any())).thenAnswer((_) async => {SongLyric.fieldKey: []});
      when(() => client.getSongLyric(1)).thenAnswer((_) async => songLyricsJson[0]);
      when(() => client.getSongLyric(5)).thenAnswer((_) => Future.error(_serverError));

      // arrangement 3 and song lyric 99, which isn't on server, will never be stored, while song lyric 5 can be
      // downloaded during next update
      final playlist = createContainer(appDependencies).read(playlistsProvider.notifier).acceptPlaylist({
        'records': [
          {
            'rank': 0,
            'song_lyric': {'id': 1},
          },
          {
            'rank': 1,
            'song_lyric': {'id': 3},
          },
          {
            'rank': 2,
            'song_lyric': {'id': 5},
          },
          {
            'rank': 3,
            'song_lyric': {'id': 99},
          },
          {
            'rank': 4,
            'custom_text': {'name': 'Ohlášky', 'content': 'text'},
          },
        ],
      }, 'Přijatý');

      await runUpdate(appDependencies);

      final query = appDependencies.store
          .box<PlaylistRecord>()
          .query(PlaylistRecord_.playlist.equals(playlist.id))
          .build();

      expect(query.find().map((playlistRecord) => playlistRecord.songLyric.targetId), [1, 5, 0]);

      query.close();
    });

    test('song lyric that failed to download does not fail update', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});

      when(() => client.getData()).thenAnswer(
        (_) async => {
          ...readTestData(),
          SongLyric.fieldKey: [
            {'id': '1', 'is_arrangement': false},
            {'id': '5', 'is_arrangement': false},
          ],
        },
      );
      when(() => client.getSongLyrics(any())).thenAnswer((_) async => {SongLyric.fieldKey: []});
      when(() => client.getSongLyric(1)).thenAnswer((_) async => songLyricsJson[0]);
      when(() => client.getSongLyric(5)).thenAnswer((_) => Future.error(_serverError));

      final states = await runUpdate(appDependencies);

      expect((states.last as Updated).songLyrics.map((songLyric) => songLyric.id), [1]);

      await eventually(
        () => expect(appDependencies.sharedPreferences.getString('last_update'), isNot('2026-01-01 00:00:00')),
      );
    });

    test('connection error interrupts update without showing error', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});

      when(() => client.getData()).thenAnswer((_) => Future.error(_connectionError));

      final states = await runUpdate(appDependencies);

      expect(states, [isA<Updating>(), isA<UpdateInterrupted>()]);
      expect(appDependencies.sharedPreferences.getString('last_update'), '2026-01-01 00:00:00');
    });

    test('interrupted update leaves no relations of removed song lyrics', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});
      final store = appDependencies.store;
      final data = readTestData();

      await parseAndStoreData(store, data);
      await storeSongLyrics(store, readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson));

      // song lyric 2 was removed on server, connection is lost before updated song lyrics are downloaded
      when(() => client.getData()).thenAnswer(
        (_) async => {
          ...data,
          SongLyric.fieldKey: [
            {'id': '1', 'is_arrangement': false},
          ],
        },
      );
      when(() => client.getSongLyrics(any())).thenAnswer((_) => Future.error(_connectionError));

      final states = await runUpdate(appDependencies);

      expect(states.last, isA<UpdateInterrupted>());
      expect(store.box<SongLyric>().get(2), isNull);
      expect(store.box<SongbookRecord>().getAll().map((songbookRecord) => songbookRecord.songLyric.targetId), [
        1,
        1,
        1,
      ]);
      expect(store.box<External>().getAll().map((external) => external.songLyric.targetId), isNot(contains(0)));
    });

    test('server errors are shown and update is not retried', () async {
      final appDependencies = await createAppDependencies(preferences: {'last_update': '2026-01-01 00:00:00'});

      when(() => client.getData()).thenAnswer((_) => Future.error(_serverError));

      await expectLater(runUpdate(appDependencies), throwsA(_serverError));

      // automatic retry would happen after 200 ms
      await Future.delayed(const Duration(milliseconds: 500));

      verify(() => client.getData()).called(1);
    });
  });
}
