import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

// in ms per pixel
const autoScrollSpeeds = [120, 90, 72, 60, 54, 45, 39, 36, 33, 30, 27, 24];

const defaultGlobalSettings = GlobalSettings(
  seedColor: 0xFF673AB7, // Colors.deepPurlple
  fontSizeScale: 1,
  showChords: true,
  showMusicalNotes: true,
  accidentals: 0,
  autoScrollSpeedIndex: 6,
);

@freezed
class GlobalSettings with _$GlobalSettings {
  const factory GlobalSettings({
    bool? darkModeEnabled,
    required int seedColor,
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

  factory SongLyricSettingsModel.defaultFromGlobalSettings(GlobalSettings globalSettings) {
    return SongLyricSettingsModel(
      id: 0,
      showChords: globalSettings.showChords,
      showMusicalNotes: globalSettings.showMusicalNotes,
      accidentals: 0,
      transposition: 0,
    );
  }
}
