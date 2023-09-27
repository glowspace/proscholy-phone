import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

// in ms per pixel
const autoScrollSpeeds = [40, 30, 24, 20, 17, 15, 13, 12, 11, 10, 9, 8];

const defaultGlobalSettings = GlobalSettings(
  primaryColor: 0xFF673AB7, // Colors.deepPurlple
  fontSizeScale: 1,
  showChords: true,
  showMusicalNotes: true,
  accidentals: 0,
  autoScrollSpeedIndex: 6,
);
const defaultSongLyricSettings = SongLyricSettingsModel(
  id: 0,
  showChords: true,
  showMusicalNotes: true,
  accidentals: 0,
  transposition: 0,
);

@freezed
class GlobalSettings with _$GlobalSettings {
  const factory GlobalSettings({
    bool? darkModeEnabled,
    required int primaryColor,
    required double fontSizeScale,
    required bool showChords,
    required bool showMusicalNotes,
    required int accidentals,
    required int autoScrollSpeedIndex,
  }) = _GlobalSettings;

  factory GlobalSettings.fromJson(Map<String, Object?> json) => _$GlobalSettingsFromJson(json);
}

@freezed
class SongLyricSettingsModel with _$SongLyricSettingsModel implements Identifiable {
  @Entity(realClass: SongLyricSettingsModel)
  const factory SongLyricSettingsModel({
    @Id(assignable: true) required int id,
    required bool showChords,
    required bool showMusicalNotes,
    required int accidentals,
    required int transposition,
  }) = _SongLyricSettingsModel;
}
