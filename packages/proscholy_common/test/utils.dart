import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

var _storeCounter = 0;

TestDefaultBinaryMessenger get _messenger => TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger;

// data in the same format as API response and `assets/data.json` of the apps
Map<String, dynamic> readTestData() => jsonDecode(File('test/data/data.json').readAsStringSync())['data'];

SongLyric createSongLyric({int id = 1, String name = 'Píseň', String? lyrics}) {
  return SongLyric(
    id: id,
    displayId: '$id',
    displayName: name,
    name: name,
    lyrics: lyrics,
    lang: 'cs',
    langDescription: 'Čeština',
    dbType: 0,
    hasChords: false,
    isArrangement: false,
    song: ToOne(),
    settings: ToOne(),
    authors: ToMany(),
    tags: ToMany(),
    externals: ToMany(),
    songbookRecords: ToMany(),
    playlistRecords: ToMany(),
  );
}

// opens new empty in-memory store, requires objectbox library installed on host (see `init_test.sh`)
Future<Store> openTestStore() async {
  final store = await openStore(directory: 'memory:test_${_storeCounter++}');

  addTearDown(store.close);

  return store;
}

// opens new empty in-memory database that can be used as `ftsDatabase`
Future<Database> openTestFtsDatabase() async {
  sqfliteFfiInit();

  final database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

  addTearDown(database.close);

  return database;
}

Future<AppDependencies> createAppDependencies({Map<String, Object> preferences = const {}}) async {
  SharedPreferences.setMockInitialValues(preferences);

  return AppDependencies(
    sharedPreferences: await SharedPreferences.getInstance(),
    store: await openTestStore(),
    ftsDatabase: await openTestFtsDatabase(),
    packageInfo: PackageInfo(appName: 'Zpěvník', packageName: 'test', version: '1.0.0', buildNumber: '1'),
  );
}

ProviderContainer createContainer(AppDependencies appDependencies, {List<Override> overrides = const []}) {
  return ProviderContainer.test(overrides: [appDependenciesProvider.overrideWithValue(appDependencies), ...overrides]);
}

// replaces documents directory from `path_provider` with new temporary directory
Future<Directory> mockDocumentsDirectory() async {
  final directory = await Directory.systemTemp.createTemp('proscholy_test_');

  _messenger.setMockMethodCallHandler(_pathProviderChannel, (_) async => directory.path);

  addTearDown(() {
    _messenger.setMockMethodCallHandler(_pathProviderChannel, null);
    directory.deleteSync(recursive: true);
  });

  return directory;
}

// makes `rootBundle` return `bytes` for asset with `key`
void mockAsset(String key, List<int> bytes) {
  _messenger.setMockMessageHandler('flutter/assets', (message) async {
    if (utf8.decode(message!.buffer.asUint8List()) != key) return null;

    return ByteData.sublistView(Uint8List.fromList(bytes));
  });

  addTearDown(() {
    _messenger.setMockMessageHandler('flutter/assets', null);
    rootBundle.evict(key);
  });
}

// retries `check` until it passes, for work that the tested code starts, but does not await
Future<void> eventually(FutureOr<void> Function() check, {Duration timeout = const Duration(seconds: 5)}) async {
  final end = DateTime.now().add(timeout);

  while (true) {
    try {
      return await check();
    } on TestFailure {
      if (DateTime.now().isAfter(end)) rethrow;

      await Future.delayed(const Duration(milliseconds: 20));
    }
  }
}
