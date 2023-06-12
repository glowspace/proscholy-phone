import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/settings.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/app_dependencies.dart';
import 'package:zpevnik/providers/util.dart';

part 'settings.g.dart';

// TODO: these keys are only used to preserve settings from older versions, remove them after some time
const String _darkModeKey = 'dark_mode_key';
const String _fontSizeScaleScaleKey = 'font_size_scale';
const String _showChordsKey = 'show_chords';
const String _accidentalsKey = 'accidentals';

const String _settingsKey = 'settings';

@riverpod
class Settings extends _$Settings {
  @override
  GlobalSettings build() {
    final prefs = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.sharedPreferences));
    final settingsData = prefs.getString(_settingsKey);

    ref.listenSelf((_, next) => prefs.setString(_settingsKey, jsonEncode(next)));

    if (settingsData != null) return GlobalSettings.fromJson(jsonDecode(settingsData));

    // TODO: copyWith is only used to preserve settings from older versions, remove it after some time
    return defaultGlobalSettings.copyWith(
      darkModeEnabled: prefs.getBool(_darkModeKey),
      fontSizeScale: prefs.getDouble(_fontSizeScaleScaleKey) ?? 1.0,
      showChords: prefs.getBool(_showChordsKey) ?? true,
      accidentals: prefs.getInt(_accidentalsKey) ?? 1,
    );
  }

  void changeDarkModeEnabled(bool? darkModeEnabled) => state = state.copyWith(darkModeEnabled: darkModeEnabled);

  void changeFontSizeScale(double fontSizeScale) => state = state.copyWith(fontSizeScale: fontSizeScale);

  void changeShowChords(bool showChords) => state = state.copyWith(showChords: showChords);

  void changeAccidentals(int accidentals) => state = state.copyWith(accidentals: accidentals);
}

@riverpod
class SongLyricSettings extends _$SongLyricSettings {
  // TODO: support individual settings also for playlist records
  @override
  SongLyricSettingsModel build(SongLyric songLyric) {
    ref.listenSelf((previous, next) {
      if (previous == null || previous == next) return;

      songLyric.settings.target = next == defaultSongLyricSettings ? null : next;

      ref
          .read(appDependenciesProvider.select((appDependencies) => appDependencies.store))
          .box<SongLyric>()
          .put(songLyric);
    });

    return songLyric.settings.target ?? defaultSongLyricSettings;
  }

  void changeShowChords(bool showChords) => _updateState(state.copyWith(showChords: showChords));

  void changeAccidentals(int accidentals) => _updateState(state.copyWith(accidentals: accidentals));

  void changeTransposition(int transposition) =>
      _updateState(state.copyWith(transposition: state.transposition + transposition));

  void reset() => _updateState(defaultSongLyricSettings);

  void _updateState(SongLyricSettingsModel songLyricSettings) {
    final songLyricSettingsBox = ref
        .read(appDependenciesProvider.select((appDependencies) => appDependencies.store))
        .box<SongLyricSettingsModel>();

    if (songLyricSettings == defaultSongLyricSettings) {
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
