import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/providers/home.dart';

import '../utils.dart';

void main() {
  test('reordered home sections are persisted', () async {
    final appDependencies = await createAppDependencies(
      preferences: {
        'home_screen_sections': ['0', '1', '2', '3'],
      },
    );

    final container = createContainer(appDependencies);
    container.listen(homeSectionSettingsProvider, (_, _) {});

    container.read(homeSectionSettingsProvider.notifier).reorder(0, 2);

    expect(container.read(homeSectionSettingsProvider), [
      HomeSection.recent,
      HomeSection.playlists,
      HomeSection.news,
      HomeSection.songbooks,
    ]);

    container.read(homeSectionSettingsProvider.notifier).reorder(3, 0);

    expect(createContainer(appDependencies).read(homeSectionSettingsProvider), [
      HomeSection.songbooks,
      HomeSection.recent,
      HomeSection.playlists,
      HomeSection.news,
    ]);
  });
}
