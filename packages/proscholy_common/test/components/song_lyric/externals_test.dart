import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/song_lyric/externals/externals.dart';
import 'package:proscholy_common/components/song_lyric/externals/externals_wrapper.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/display_screen_status.dart';
import 'package:proscholy_common/providers/internet_connection.dart';

import '../../utils.dart';

void main() {
  // tablet shows list next to display screen
  testWidgets('recordings fit next to list', (tester) async {
    final appDependencies = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();

      await storeTestData(appDependencies);

      return appDependencies;
    }))!;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDependenciesProvider.overrideWithValue(appDependencies),
          internetConnectionProvider.overrideWith((ref) => throw const SocketException('offline in tests')),
        ],
        child: MaterialApp(
          home: Row(
            children: [
              const SizedBox(width: 300),
              Expanded(
                child: ExternalsWrapper(
                  songLyric: appDependencies.store.box<SongLyric>().get(1),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    ProviderScope.containerOf(
      tester.element(find.byType(ExternalsWrapper)),
    ).read(displayScreenStatusProvider.notifier).showExternals();
    await tester.pumpAndSettle();

    final recordings = tester.getRect(find.byType(ExternalsWidget));

    expect(recordings.left, 300);
    expect(recordings.right, tester.getSize(find.byType(Row)).width);
  });
}
