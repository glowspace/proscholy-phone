import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/providers/presentation.dart';

import '../utils.dart';

void main() {
  const channel = MethodChannel('proscholyCommon/presentation');

  test('presentation stops when external display is disconnected', () async {
    final messenger = TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      channel,
      (call) async => call.method == 'isExternalScreenConnected' ? true : null,
    );
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

    final presentation = PresentationProvider((await createAppDependencies()).sharedPreferences);

    presentation.start();
    await pumpEventQueue();

    expect(presentation.isPresenting, isTrue);
    expect(presentation.isPresentingLocally, isFalse);

    await messenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(const MethodCall('onExternalDisplayDisconnected')),
      (_) {},
    );

    expect(presentation.isPresenting, isFalse);
  });
}
