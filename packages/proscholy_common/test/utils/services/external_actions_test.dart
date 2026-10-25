import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/utils/services/external_actions.dart';

import '../../utils.dart';

void main() {
  Future<void> openFile(WidgetTester tester, String? content) async {
    final appDependencies = await tester.runAsync(createAppDependencies);

    ExternalActionsService.instance.initialize();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDependenciesProvider.overrideWithValue(appDependencies!)],
        child: MaterialApp(navigatorKey: ExternalActionsService.instance.navigatorKey, home: const Scaffold()),
      ),
    );

    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'proscholyCommon/openedFile',
      const StandardMethodCodec().encodeMethodCall(MethodCall('onOpenedFile', content)),
      (_) {},
    );
    await tester.pumpAndSettle();
  }

  testWidgets('received playlist can be added', (tester) async {
    await openFile(tester, '{"name": "Mše", "records": []}');

    expect(find.text('Přidat sdílený playlist'), findsOneWidget);
  });

  testWidgets('received file that is not json', (tester) async {
    await openFile(tester, 'not json');

    expect(find.text('Chyba při importu playlistu.'), findsOneWidget);
  });

  // app can be opened with any json file
  testWidgets('received json that is not playlist', (tester) async {
    await openFile(tester, '[{"name": "Weapon"}]');

    expect(find.text('Chyba při importu playlistu.'), findsOneWidget);
  });

  // Android sends empty text for files that are too big to be playlist
  testWidgets('received file that is too big', (tester) async {
    await openFile(tester, '');

    expect(find.text('Chyba při importu playlistu.'), findsOneWidget);
  });

  testWidgets('file that could not be read is ignored', (tester) async {
    await openFile(tester, null);

    expect(find.byType(Dialog), findsNothing);
  });
}
