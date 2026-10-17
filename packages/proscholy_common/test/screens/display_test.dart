import 'dart:io';

import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:proscholy_common/components/selected_displayable_item_arguments.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/models/utils.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/providers/utils.dart';
import 'package:proscholy_common/routing/arguments.dart';
import 'package:proscholy_common/screens/display.dart';

import '../utils.dart';

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

void main() {
  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();

    FirebaseAnalyticsPlatform.instance = _FakeFirebaseAnalyticsPlatform();
  });

  // tablet shows list of items next to display screen and both share selected item
  testWidgets('closed display screen does not react to change of selected item', (tester) async {
    final (appDependencies, songLyrics) = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();
      final data = readTestData();

      await parseAndStoreData(appDependencies.store, data);

      final songLyrics = await storeSongLyrics(
        appDependencies.store,
        readJsonList(data[SongLyric.fieldKey], mapper: SongLyric.fromJson),
      );

      return (appDependencies, songLyrics);
    }))!;

    final selectedNotifier = ValueNotifier(DisplayScreenArguments(items: songLyrics));

    Future<void> pumpTablet(Widget child) {
      return tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDependenciesProvider.overrideWithValue(appDependencies),
            svgsProvider.overrideWith(_FakeSvgs.new),
          ],
          retry: (_, _) => null,
          child: MaterialApp(
            home: SelectedDisplayableItemArguments(displayableItemArgumentsNotifier: selectedNotifier, child: child),
          ),
        ),
      );
    }

    await pumpTablet(DisplayScreen(items: songLyrics));
    await tester.pump(const Duration(seconds: 1));

    // display screen is closed
    await pumpTablet(const SizedBox());

    selectedNotifier.value = DisplayScreenArguments(items: songLyrics, initialIndex: 1);
    await tester.pump(const Duration(seconds: 1));
  });
}
