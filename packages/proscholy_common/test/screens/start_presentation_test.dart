import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/utils/services/external_actions.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  testWidgets('external display connected while screen is open is detected', (tester) async {
    final appDependencies = await tester.runAsync(createAppDependencies);

    await pumpApp(tester, appDependencies!);

    late MockStreamHandlerEventSink externalDisplay;

    tester.binding.defaultBinaryMessenger.setMockStreamHandler(
      const EventChannel('proscholyCommon/presentation/externalDisplay'),
      MockStreamHandler.inline(
        onListen: (_, events) {
          externalDisplay = events;
          externalDisplay.success(false);
        },
      ),
    );

    ExternalActionsService.instance.navigatorKey.currentState!.pushNamed('/display/present');
    await tester.pumpAndSettle();

    expect(find.textContaining('Nebyl detekován žádný externí displej'), findsOneWidget);

    externalDisplay.success(true);
    await tester.pumpAndSettle();

    expect(find.textContaining('Nebyl detekován žádný externí displej'), findsNothing);
    expect(find.text('Světlé písmo'), findsOneWidget);

    externalDisplay.success(false);
    await tester.pumpAndSettle();

    expect(find.textContaining('Nebyl detekován žádný externí displej'), findsOneWidget);
  });

  testWidgets('settings can be scrolled on small phone with large text', (tester) async {
    final appDependencies = await tester.runAsync(createAppDependencies);

    await pumpApp(tester, appDependencies!, route: '/display/present');

    // iPhone 12 mini with one of the larger accessibility text sizes, without external display
    tester.view.physicalSize = const Size(1125, 2436);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();

    // the settings scroll below the notice that no external display is connected, so nothing overflows
    await tester.ensureVisible(find.text('Otočení obrazu'));
    await tester.pumpAndSettle();

    expect(tester.state<ScrollableState>(find.byType(Scrollable).last).position.pixels, greaterThan(0));
  });
}
