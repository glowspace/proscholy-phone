import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/model.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

const defaultGlobalSettings = GlobalSettings(fontSizeScale: 1, showChords: true, accidentals: 1);
const defaultSongLyricSettings = SongLyricSettingsModel(id: 0, showChords: true, accidentals: 1, transposition: 0);

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
class SongLyricSettingsModel with _$SongLyricSettingsModel implements Identifiable {
  @Entity(realClass: SongLyricSettingsModel)
  const factory SongLyricSettingsModel({
    @Id(assignable: true) required int id,
    required bool showChords,
    required int accidentals,
    required int transposition,
  }) = _SongLyricSettingsModel;
}
