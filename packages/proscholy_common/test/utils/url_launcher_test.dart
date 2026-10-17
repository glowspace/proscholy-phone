import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:proscholy_common/utils/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _FailingUrlLauncher extends Fake with MockPlatformInterfaceMixin implements UrlLauncherPlatform {
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) {
    return Future.error(PlatformException(code: 'ACTIVITY_NOT_FOUND'));
  }
}

void main() {
  // for example there is no app that can open the link
  test('link that can not be opened', () async {
    UrlLauncherPlatform.instance = _FailingUrlLauncher();

    launch('https://glowspace.cz');

    await pumpEventQueue();
  });
}
