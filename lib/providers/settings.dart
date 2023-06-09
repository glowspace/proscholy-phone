import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/settings.dart';
import 'package:zpevnik/providers/app_dependencies.dart';

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

    ref.listenSelf((_, newValue) => prefs.setString(_settingsKey, jsonEncode(newValue)));

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
