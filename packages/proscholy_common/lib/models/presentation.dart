import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/presentation.freezed.dart';
part 'generated/presentation.g.dart';

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

enum PresentationRotation { none, left90, right90, upsideDown }

@Freezed(equal: true, toJson: true)
sealed class PresentationData with _$PresentationData {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.none)
  const factory PresentationData({
    int? songLyricId,
    @Default(false) bool isCustomText,
    required String name,
    required String text,
    required PresentationSettings settings,
  }) = _PresentationData;

  factory PresentationData.fromJson(Map<String, Object?> json) => _$PresentationDataFromJson(json);
}

@Freezed(equal: true, toJson: true)
sealed class PresentationSettings with _$PresentationSettings {
  // stored in shared preferences with these keys
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.none)
  const factory PresentationSettings({
    required bool darkMode,
    required bool showName,
    required bool allCapital,
    required bool isVisible,
    PresentationAlignment? alignment,
    PresentationRotation? rotation,
  }) = _PresentationSettings;

  factory PresentationSettings.fromJson(Map<String, Object?> json) => _$PresentationSettingsFromJson(json);
}
