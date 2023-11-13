import 'package:freezed_annotation/freezed_annotation.dart';

part 'presentation.freezed.dart';
part 'presentation.g.dart';

const defaultPresentationData = PresentationData(
  songLyricId: null,
  name: '',
  text: '',
  settings: defaultPresentationSettings,
);

const defaultPresentationSettings = PresentationSettings(
  darkMode: true,
  showName: false,
  allCapital: false,
  isVisible: true,
);

enum PresentationAlignment { top, center, bottom }

@freezed
class PresentationData with _$PresentationData {
  const factory PresentationData({
    int? songLyricId,
    @Default(false) bool isCustomText,
    required String name,
    required String text,
    required PresentationSettings settings,
  }) = _PresentationData;

  factory PresentationData.fromJson(Map<String, Object?> json) => _$PresentationDataFromJson(json);
}

@freezed
class PresentationSettings with _$PresentationSettings {
  const factory PresentationSettings({
    required bool darkMode,
    required bool showName,
    required bool allCapital,
    required bool isVisible,
    PresentationAlignment? alignment,
  }) = _PresentationSettings;

  factory PresentationSettings.fromJson(Map<String, Object?> json) => _$PresentationSettingsFromJson(json);
}
