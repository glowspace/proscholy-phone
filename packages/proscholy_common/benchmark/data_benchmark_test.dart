// benchmarks of storing, updating and searching data of the app, `../<app>/assets/data.json` is used as data
// flutter test benchmark/data_benchmark_test.dart --dart-define=ZPEVNIK_TARGET=ZPS
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:proscholy_common/components/song_lyric/utils/parser.dart';
import 'package:proscholy_common/models/external.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/songbook_record.dart';
import 'package:proscholy_common/models/tag.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/providers/song_lyrics.dart';
import 'package:proscholy_common/providers/songbooks.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/providers/tags.dart';
import 'package:proscholy_common/utils/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'utils.dart';

class _FakeSvgs extends Svgs {
  @override
  Map<String, FileSystemEntity> build() => {};
}

// waits for result of search, it is notified only when it differs from previous one
Future<SearchedSongLyricsResult> _search(ProviderContainer container, String text) {
  final completer = Completer<SearchedSongLyricsResult>();
  final subscription = container.listen(searchedSongLyricsProvider, (_, result) {
    if (!completer.isCompleted) completer.complete(result);
  });

  container.read(searchTextProvider.notifier).change(text);

  return completer.future.whenComplete(subscription.close);
}

void main() {
  final benchmark = Benchmark('data');

  late Directory directory;
  late Store store;
  late Database ftsDatabase;
  late Map<String, dynamic> data;
  late List<SongLyric> storedSongLyrics;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('proscholy_benchmark_');
    store = await openStore(directory: '${directory.path}/store');

    sqfliteFfiInit();
    ftsDatabase = await databaseFactoryFfi.openDatabase('${directory.path}/fts.db');
  });

  tearDownAll(() async {
    benchmark.save();

    store.close();
    await ftsDatabase.close();
    directory.deleteSync(recursive: true);
  });

  test('loading data of the app on first start', () async {
    final jsonString = await benchmark.measure(
      'read data.json',
      appDataFile.readAsString,
      info: {'bytes': appDataFile.lengthSync()},
    );

    data = await benchmark.measure('decode data.json', () async => jsonDecode(jsonString)['data']);

    await benchmark.measure('store authors, songs, songbooks and tags', () => parseAndStoreData(store, data));

    final songLyrics = await benchmark.measure(
      'parse song lyrics',
      () async => readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson),
      info: {'count': data[SongLyric.fieldKey].length},
    );

    storedSongLyrics = await benchmark.measure(
      'store song lyrics into empty store',
      () => storeSongLyrics(store, songLyrics),
    );

    benchmark.results.last.addAll({
      'externals': store.box<External>().count(),
      'songbook records': store.box<SongbookRecord>().count(),
    });

    await benchmark.measure('build search index', () => SearchedSongLyrics.update(ftsDatabase, storedSongLyrics));
  });

  test('loading data of new version of the app', () async {
    final songLyrics = readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson);

    await benchmark.measure('store authors, songs, songbooks and tags again', () => parseAndStoreData(store, data));
    await benchmark.measure('store song lyrics again', () => storeSongLyrics(store, songLyrics));
  });

  test('update', () async {
    final updatedSongLyrics = readJsonList(
      (data[SongLyric.fieldKey] as List).take(200).toList(),
      mapper: SongLyric.fromJson,
    );

    await benchmark.measure('remove authors, songs, songbooks and tags removed on server', () async {
      removeMissingData(store, data);
    });

    final storedUpdatedSongLyrics = await benchmark.measure(
      'store 200 updated song lyrics',
      () => storeSongLyrics(store, updatedSongLyrics),
    );

    await benchmark.measure(
      'update search index with 200 song lyrics',
      () => SearchedSongLyrics.update(ftsDatabase, storedUpdatedSongLyrics),
    );
  });

  test('lyrics parser', () async {
    final songLyrics = storedSongLyrics.where((songLyric) => songLyric.lyrics?.isNotEmpty ?? false).toList();

    var slowest = 0.0;

    await benchmark.measure('parse lyrics of all song lyrics', () async {
      for (final songLyric in songLyrics) {
        final stopwatch = Stopwatch()..start();
        final parser = SongLyricsParser(songLyric);

        while (parser.nextToken != null) {}

        if (stopwatch.elapsedMicroseconds / 1000 > slowest) slowest = stopwatch.elapsedMicroseconds / 1000;
      }
    });

    benchmark.results.last.addAll({'count': songLyrics.length, 'slowest_ms': slowest});
  });

  test('providers and search', () async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});

    final container = ProviderContainer(
      overrides: [
        appDependenciesProvider.overrideWithValue(
          AppDependencies(
            sharedPreferences: await SharedPreferences.getInstance(),
            store: store,
            ftsDatabase: ftsDatabase,
            packageInfo: PackageInfo(appName: 'Zpěvník', packageName: 'benchmark', version: '1.0.0', buildNumber: '1'),
          ),
        ),
        svgsProvider.overrideWith(_FakeSvgs.new),
      ],
    );

    addTearDown(container.dispose);

    // keeps search providers alive between searches
    container.listen(searchedSongLyricsProvider, (_, _) {});

    await benchmark.measureRepeated('provider of all song lyrics', () async {
      container.invalidate(songLyricsProvider);
      container.read(songLyricsProvider);
    }, runs: 10);

    await benchmark.measureRepeated('provider of language tags', () async {
      container.invalidate(tagsProvider(TagType.language));
      container.read(tagsProvider(TagType.language));
    }, runs: 10);

    await benchmark.measureRepeated('provider of songbooks', () async {
      container.invalidate(songbooksProvider);
      container.read(songbooksProvider);
    }, runs: 10);

    for (final text in ['bože', 'ave maria', 'pane', 'chval', '1', '123']) {
      final result = await _search(container, text);

      await benchmark.measureRepeated(
        'search "$text"',
        () => _search(container, text),
        before: () => _search(container, ''),
        runs: 10,
        info: {'results': result.songLyrics?.length ?? 0},
      );
    }
  });
}
