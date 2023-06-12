import 'package:freezed_annotation/freezed_annotation.dart';

part 'presentation.freezed.dart';
part 'presentation.g.dart';

const defaultPresentationData = PresentationData(
  songLyricId: 0,
  songLyricName: '',
  lyrics: '',
  settings: defaultPresentationSettings,
);

const defaultPresentationSettings = PresentationSettings(
  showBackground: false,
  darkMode: true,
  showName: false,
  allCapital: false,
);

@freezed
class PresentationData with _$PresentationData {
  const factory PresentationData({
    required int songLyricId,
    required String songLyricName,
    required String lyrics,
    required PresentationSettings settings,
  }) = _PresentationData;

  factory PresentationData.fromJson(Map<String, Object?> json) => _$PresentationDataFromJson(json);
}

@freezed
class PresentationSettings with _$PresentationSettings {
  const factory PresentationSettings({
    required bool showBackground,
    required bool darkMode,
    required bool showName,
    required bool allCapital,
  }) = _PresentationSettings;

  factory PresentationSettings.fromJson(Map<String, Object?> json) => _$PresentationSettingsFromJson(json);
}
