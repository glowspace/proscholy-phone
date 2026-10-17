import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/internet_connection.dart';
import 'package:proscholy_common/providers/search.dart';
import 'package:proscholy_common/providers/settings.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/providers/update.dart';
import 'package:proscholy_common/routing/navigator_observer.dart';
import 'package:proscholy_common/routing/router.dart';
import 'package:proscholy_common/theme.dart';
import 'package:proscholy_common/utils/data.dart';
import 'package:proscholy_common/utils/services/external_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
const _openedFileChannel = MethodChannel('proscholyCommon/openedFile');
const _presentationChannel = MethodChannel('proscholyCommon/presentation');
const _wakelockChannel = 'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle';

// logo is in assets of the apps, so transparent 1x1 png is used in tests
const _logoAsset = 'assets/images/logos/logo.png';
final _emptyImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

var _storeCounter = 0;

class _FakeFirebaseAnalyticsPlatform extends Fake with MockPlatformInterfaceMixin implements FirebaseAnalyticsPlatform {
  @override
  FirebaseAnalyticsPlatform delegateFor({required FirebaseApp app, Map<String, dynamic>? webOptions}) => this;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) async {}
}

class _FakeSvgs extends Svgs {
  @override
  Map<String, FileSystemEntity> build() => {};
}

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

// stores data from `readTestData` and indexes it for searching, returns stored song lyrics
Future<List<SongLyric>> storeTestData(AppDependencies appDependencies) async {
  final data = readTestData();

  await parseAndStoreData(appDependencies.store, data);

  final songLyrics = await storeSongLyrics(
    appDependencies.store,
    readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson),
  );

  await SearchedSongLyrics.update(appDependencies.ftsDatabase, songLyrics);

  return songLyrics;
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

// pumps until `condition` is true, for real async work started by widgets, e.g. database queries
Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final end = DateTime.now().add(timeout);

  while (!condition() && DateTime.now().isBefore(end)) {
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 20)));
    await tester.pump();
  }
}

// makes `FirebaseAnalytics.instance` usable in tests, call it in `setUpAll`
Future<void> mockFirebase() async {
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();

  FirebaseAnalyticsPlatform.instance = _FakeFirebaseAnalyticsPlatform();
}

// pumps app with the same routes as the apps have, starting at `route`
// app is offline, so no requests are made, and native services report that nothing was opened or connected
Future<void> pumpApp(
  WidgetTester tester,
  AppDependencies appDependencies, {
  String route = '/',
  List<Override> overrides = const [],
}) async {
  _messenger.setMockMethodCallHandler(_openedFileChannel, (_) async => null);
  _messenger.setMockMethodCallHandler(_presentationChannel, (_) async => null);
  _messenger.setMockMessageHandler(
    _wakelockChannel,
    (_) async => const StandardMessageCodec().encodeMessage(<Object?>[null]),
  );
  _messenger.setMockMessageHandler('flutter/assets', (message) async {
    if (utf8.decode(message!.buffer.asUint8List()) == _logoAsset) return ByteData.sublistView(_emptyImage);

    return _messenger.delegate.send('flutter/assets', message);
  });

  addTearDown(() {
    _messenger.setMockMethodCallHandler(_openedFileChannel, null);
    _messenger.setMockMethodCallHandler(_presentationChannel, null);
    _messenger.setMockMessageHandler(_wakelockChannel, null);
    _messenger.setMockMessageHandler('flutter/assets', null);
  });

  // size of common phone, labels in test font are wider than with real fonts, so they might not fit on wider screens
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;

  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDependenciesProvider.overrideWithValue(appDependencies),
        updateProvider.overrideWith((ref) => const Stream.empty()),
        internetConnectionProvider.overrideWith((ref) => throw const SocketException('offline in tests')),
        svgsProvider.overrideWith(_FakeSvgs.new),
        ...overrides,
      ],
      retry: (_, _) => null,
      child: Consumer(
        builder: (context, ref, _) => MaterialApp(
          navigatorKey: ExternalActionsService.instance.navigatorKey,
          theme: AppTheme.light(Color(ref.watch(settingsProvider).seedColor)),
          initialRoute: route,
          onGenerateInitialRoutes: AppRouter.generateInitialRoutes,
          onGenerateRoute: AppRouter.generateRoute,
          navigatorObservers: [ref.read(appNavigatorObserverProvider)],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
