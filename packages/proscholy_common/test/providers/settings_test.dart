import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/presentation.dart';
import 'package:proscholy_common/models/settings.dart';
import 'package:proscholy_common/providers/presentation.dart';
import 'package:proscholy_common/providers/settings.dart';

import '../utils.dart';

void main() {
  group('global settings', () {
    test('default settings', () async {
      final container = createContainer(await createAppDependencies());

      expect(container.read(settingsProvider), defaultGlobalSettings);
    });

    test('changes are persisted', () async {
      final appDependencies = await createAppDependencies();

      final container = createContainer(appDependencies);
      container.listen(settingsProvider, (_, _) {});
      container.read(settingsProvider.notifier).changeShowChords(false);
      container.read(settingsProvider.notifier).changeDarkModeEnabled(true);

      final settings = createContainer(appDependencies).read(settingsProvider);

      expect(settings.showChords, isFalse);
      expect(settings.darkModeEnabled, isTrue);
    });

    // keys must not change, otherwise saved settings would be lost
    test('settings saved by previous versions are loaded', () async {
      final appDependencies = await createAppDependencies(
        preferences: {
          'settings':
              '{"darkModeEnabled":true,"seedColor":4284955319,"fontSizeScale":1.5,"showChords":false,'
              '"showMusicalNotes":true,"accidentals":1,"autoScrollSpeedIndex":3}',
        },
      );

      final settings = createContainer(appDependencies).read(settingsProvider);

      expect(settings.darkModeEnabled, isTrue);
      expect(settings.fontSizeScale, 1.5);
      expect(settings.autoScrollSpeedIndex, 3);
    });

    test('font size scale is limited', () async {
      final container = createContainer(await createAppDependencies());
      container.listen(settingsProvider, (_, _) {});

      container.read(settingsProvider.notifier).changeFontSizeScale(100);
      expect(container.read(settingsProvider).fontSizeScale, kMaximumFontSizeScale);

      container.read(settingsProvider.notifier).changeFontSizeScale(0);
      expect(container.read(settingsProvider).fontSizeScale, kMinimumFontSizeScale);
    });

    test('auto scroll speed index stays within speeds', () async {
      final appDependencies = await createAppDependencies(
        preferences: {
          'settings':
              '{"seedColor":4284955319,"fontSizeScale":1.0,"showChords":true,"showMusicalNotes":true,"accidentals":0,'
              '"autoScrollSpeedIndex":13}',
        },
      );

      final container = createContainer(appDependencies);
      container.listen(settingsProvider, (_, _) {});
      final notifier = container.read(settingsProvider.notifier);

      expect(container.read(settingsProvider).autoScrollSpeedIndex, autoScrollSpeeds.length - 1);

      notifier.increaseAutoScrollSpeedIndex();
      expect(container.read(settingsProvider).autoScrollSpeedIndex, autoScrollSpeeds.length - 1);

      for (var i = 0; i < autoScrollSpeeds.length; i++) {
        notifier.decreaseAutoScrollSpeedIndex();
      }
      expect(container.read(settingsProvider).autoScrollSpeedIndex, 0);
    });
  });

  group('song lyric settings', () {
    test('defaults come from global settings', () async {
      final appDependencies = await createAppDependencies();
      final container = createContainer(appDependencies);
      container.listen(settingsProvider, (_, _) {});
      container.read(settingsProvider.notifier).changeShowChords(false);

      final songLyricSettings = container.read(songLyricSettingsProvider(1));

      expect(songLyricSettings.showChords, isFalse);
      expect(songLyricSettings.transposition, 0);
      expect(songLyricSettings.songLyric.targetId, 1);
      expect(appDependencies.store.box<SongLyricSettingsModel>().isEmpty(), isTrue);
    });

    test('transposition stays within octave', () async {
      final container = createContainer(await createAppDependencies());
      container.listen(songLyricSettingsProvider(1), (_, _) {});
      final notifier = container.read(songLyricSettingsProvider(1).notifier);

      notifier.changeTransposition(11);
      expect(container.read(songLyricSettingsProvider(1)).transposition, 11);

      notifier.changeTransposition(1);
      expect(container.read(songLyricSettingsProvider(1)).transposition, 0);

      notifier.changeTransposition(-1);
      expect(container.read(songLyricSettingsProvider(1)).transposition, -1);

      notifier.changeTransposition(-11);
      expect(container.read(songLyricSettingsProvider(1)).transposition, 0);
    });

    test('changes are persisted', () async {
      final appDependencies = await createAppDependencies();

      final container = createContainer(appDependencies);
      container.listen(songLyricSettingsProvider(1), (_, _) {});
      container.read(songLyricSettingsProvider(1).notifier).changeTransposition(2);
      container.read(songLyricSettingsProvider(1).notifier).changeAccidentals(1);

      final songLyricSettings = createContainer(appDependencies).read(songLyricSettingsProvider(1));

      expect(songLyricSettings.transposition, 2);
      expect(songLyricSettings.accidentals, 1);
      expect(createContainer(appDependencies).read(songLyricSettingsProvider(2)).transposition, 0);
    });
  });

  // keys must not change, otherwise saved settings would be lost
  test('presentation settings saved by previous versions are loaded', () async {
    final appDependencies = await createAppDependencies(
      preferences: {
        'presentation_settings':
            '{"darkMode":false,"showName":false,"allCapital":true,"isVisible":true,"alignment":"top","rotation":"left90"}',
      },
    );

    final settings = PresentationProvider(appDependencies.sharedPreferences).settings;

    expect(settings.darkMode, isFalse);
    expect(settings.allCapital, isTrue);
    expect(settings.rotation, PresentationRotation.left90);
  });
}
