import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric.dart';
import 'package:proscholy_common/components/song_lyric/utils/auto_scroll.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/svgs.dart';

import '../../utils.dart';

void main() {
  setUpAll(mockFirebase);

  testWidgets('shows music notes above lyrics', (tester) async {
    final appDependencies = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();

      await storeTestData(appDependencies);

      return appDependencies;
    }))!;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDependenciesProvider.overrideWithValue(appDependencies),
          svgProvider(1).overrideWithValue(
            '<svg xmlns="http://www.w3.org/2000/svg" width="600px" height="150px" viewBox="0 0 1200 300">'
            '<rect width="1200" height="300"/></svg>',
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SongLyricWidget(
                songLyric: appDependencies.store.box<SongLyric>().get(1)!,
                autoScrollController: AutoScrollController(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final musicNotes = tester.getRect(find.byWidgetPredicate((widget) => widget is ScalableImageWidget).first);

    // fits the available width, not the screen
    expect(musicNotes.width, 300);
    expect(musicNotes.height, 75);
    expect(
      tester.getTopLeft(find.textContaining('srdce mé tebe zná', findRichText: true)).dy,
      greaterThanOrEqualTo(musicNotes.bottom),
    );
  });
}
