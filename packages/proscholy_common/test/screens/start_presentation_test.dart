import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/screens/start_presentation_screen.dart';
import 'package:proscholy_common/utils/services/external_actions.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  testWidgets('screen closed before external display is checked', (tester) async {
    final appDependencies = await tester.runAsync(createAppDependencies);

    await pumpApp(tester, appDependencies!);

    final isConnected = Completer<bool>();

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('proscholyCommon/presentation'),
      (_) => isConnected.future,
    );

    ExternalActionsService.instance.navigatorKey.currentState!.pushNamed('/display/present');
    await tester.pumpAndSettle();

    expect(find.byType(StartPresentationScreen), findsOneWidget);

    ExternalActionsService.instance.navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();

    isConnected.complete(true);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
