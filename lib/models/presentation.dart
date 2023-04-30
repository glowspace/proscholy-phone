import 'package:flutter/foundation.dart';

const defaultPresentationData = PresentationData(0, '', '', defaultPresentationSettings);
const defaultPresentationSettings = PresentationSettings(false, true, false, false);

@immutable
class PresentationData {
  final int songLyricId;
  final String songLyricName;
  final String lyrics;

  final PresentationSettings settings;

  const PresentationData(this.songLyricId, this.songLyricName, this.lyrics, this.settings);

  factory PresentationData.fromJson(Map<String, dynamic> json) {
    return PresentationData(
      json['song_lyric_id'],
      json['song_lyric_name'],
      json['lyrics'],
      PresentationSettings.fromJson(json['settings']),
    );
  }

  PresentationData copyWith({
    int? songLyricId,
    String? songLyricName,
    String? lyrics,
    PresentationSettings? settings,
  }) {
    return PresentationData(
      songLyricId ?? this.songLyricId,
      songLyricName ?? this.songLyricName,
      lyrics ?? this.lyrics,
      settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'song_lyric_id': songLyricId,
      'song_lyric_name': songLyricName,
      'lyrics': lyrics,
      'settings': settings.toJson(),
    };
  }
}

@immutable
class PresentationSettings {
  final bool showBackground;
  final bool darkMode;
  final bool showName;
  final bool allCapital;

  const PresentationSettings(this.showBackground, this.darkMode, this.showName, this.allCapital);

  factory PresentationSettings.fromJson(Map<String, dynamic> json) {
    return PresentationSettings(
      json['show_background'],
      json['dark_mode'],
      json['show_name'],
      json['all_capital'],
    );
  }

  PresentationSettings copyWith({
    bool? showBackground,
    bool? darkMode,
    bool? showName,
    bool? allCapital,
  }) {
    return PresentationSettings(
      showBackground ?? this.showBackground,
      darkMode ?? this.darkMode,
      showName ?? this.showName,
      allCapital ?? this.allCapital,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_background': showBackground,
      'dark_mode': darkMode,
      'show_name': showName,
      'all_capital': allCapital,
    };
  }
}
