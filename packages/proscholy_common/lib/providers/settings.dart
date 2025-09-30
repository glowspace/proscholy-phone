import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/generated/objectbox.g.dart';
import 'package:proscholy_common/models/settings.dart';
import 'package:proscholy_common/providers/app_dependencies.dart';
import 'package:proscholy_common/providers/utils.dart';

part 'generated/settings.g.dart';

const String _settingsKey = 'settings';

@riverpod
class Settings extends _$Settings {
  @override
  GlobalSettings build() {
    final prefs = ref.read(appDependenciesProvider).sharedPreferences;
    final settingsData = prefs.getString(_settingsKey);

    listenSelf((_, next) => prefs.setString(_settingsKey, jsonEncode(next)));

    if (settingsData != null) return GlobalSettings.fromJson(jsonDecode(settingsData));

    return defaultGlobalSettings;
  }

  void changeDarkModeEnabled(bool? darkModeEnabled) => state = state.copyWith(darkModeEnabled: darkModeEnabled);

  void changeFontSizeScale(double fontSizeScale) {
    if (fontSizeScale < kMinimumFontSizeScale) {
      fontSizeScale = kMinimumFontSizeScale;
    } else if (fontSizeScale > kMaximumFontSizeScale) {
      fontSizeScale = kMaximumFontSizeScale;
    }

    state = state.copyWith(fontSizeScale: fontSizeScale);
  }

  void changeShowChords(bool showChords) => state = state.copyWith(showChords: showChords);

  void changeShowMusicalNotes(bool showMusicalNotes) => state = state.copyWith(showMusicalNotes: showMusicalNotes);

  void changeAccidentals(int accidentals) => state = state.copyWith(accidentals: accidentals);

  void decreaseAutoScrollSpeedIndex() => state = state.copyWith(autoScrollSpeedIndex: state.autoScrollSpeedIndex - 1);

  void increaseAutoScrollSpeedIndex() => state = state.copyWith(autoScrollSpeedIndex: state.autoScrollSpeedIndex + 1);

  void changeSeedColor(int color) => state = state.copyWith(seedColor: color);

  void reset() => state = defaultGlobalSettings;
}

@riverpod
class SongLyricSettings extends _$SongLyricSettings {
  SongLyricSettingsModel get _defaultSongLyricSettings =>
      SongLyricSettingsModel.defaultFromGlobalSettings(ref.read(settingsProvider));

  @override
  SongLyricSettingsModel build(int songLyricId) {
    if (songLyricId == 0) return _defaultSongLyricSettings;

    final box = ref.read(appDependenciesProvider).store.box<SongLyricSettingsModel>();

    final query = box.query(SongLyricSettingsModel_.songLyric.equals(songLyricId)).build();

    final songLyricSettings = query.findFirst();

    query.close();

    return songLyricSettings ?? _defaultSongLyricSettings.copyWith(songLyric: ToOne(targetId: songLyricId));
  }

  void changeShowChords(bool showChords) => _updateState(state.copyWith(showChords: showChords));

  void changeShowMusicalNotes(bool showMusicalNotes) =>
      _updateState(state.copyWith(showMusicalNotes: showMusicalNotes));

  void changeAccidentals(int accidentals) => _updateState(state.copyWith(accidentals: accidentals));

  void changeTransposition(int transposition) {
    transposition = state.transposition + transposition;
    if (transposition % 12 == 0) transposition = 0;

    _updateState(state.copyWith(transposition: transposition));
  }

  void reset() => _updateState(_defaultSongLyricSettings);

  void _updateState(SongLyricSettingsModel songLyricSettings) {
    final songLyricSettingsBox = ref.read(appDependenciesProvider).store.box<SongLyricSettingsModel>();

    if (songLyricSettings == _defaultSongLyricSettings && state != _defaultSongLyricSettings) {
      songLyricSettingsBox.remove(state.id);
    } else {
      // decide id for new objects
      if (songLyricSettings.id == 0) {
        songLyricSettings = songLyricSettings.copyWith(id: nextId(ref, SongLyricSettingsModel_.id));
      }

      songLyricSettingsBox.put(songLyricSettings);
    }

    state = songLyricSettings;
  }
}
