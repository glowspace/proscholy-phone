import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/custom/back_button.dart';
import 'package:proscholy_common/utils/services/window.dart';

import '../utils.dart';

void main() {
  setUpAll(mockFirebase);

  testWidgets('app bars are below window controls of iPadOS', (tester) async {
    final appDependencies = (await tester.runAsync(() async {
      final appDependencies = await createAppDependencies();

      await storeTestData(appDependencies);

      return appDependencies;
    }))!;

    await pumpApp(tester, appDependencies, route: '/song_lyric?id=1');

    final topWithoutWindowControls = tester.getTopLeft(find.byType(CustomBackButton)).dy;

    // the window was resized, so window controls appeared
    WindowService.instance.windowControlsHeight.value = 43;
    addTearDown(() => WindowService.instance.windowControlsHeight.value = 0);
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(CustomBackButton)).dy, topWithoutWindowControls + 43);
  });
}
