import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/providers/update.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  // e.g. editors want to see their changes right away
  testWidgets('update can be requested', (tester) async {
    await pumpApp(tester, (await tester.runAsync(createAppDependencies))!, route: '/settings');

    await tester.ensureVisible(find.text('Aktualizovat písně'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Aktualizováno'), findsOneWidget);

    await tester.tap(find.text('Aktualizovat písně'));
    await tester.pump();

    expect(ProviderScope.containerOf(tester.element(find.byType(MaterialApp))).read(updateRequestsProvider), 1);
  });
}
