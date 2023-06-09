import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

const defaultGlobalSettings = GlobalSettings(fontSizeScale: 1, showChords: true, accidentals: 0);

@freezed
class GlobalSettings with _$GlobalSettings {
  const factory GlobalSettings({
    bool? darkModeEnabled,
    required double fontSizeScale,
    required bool showChords,
    required int accidentals,
  }) = _GlobalSettings;

  factory GlobalSettings.fromJson(Map<String, Object?> json) => _$GlobalSettingsFromJson(json);
}

@freezed
class SongLyricSettings with _$SongLyricSettings {
  const factory SongLyricSettings({
    bool? showChords,
    int? accidentals,
    int? transposition,
  }) = _SongLyricSettings;
}
