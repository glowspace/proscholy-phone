import 'package:flutter/foundation.dart';

const defaultPresentationSettings = PresentationSettings(128, false, true, false, false);

@immutable
class PresentationSettings {
  final int fontSize;
  final bool showBackground;
  final bool darkMode;
  final bool showName;
  final bool allCapital;

  const PresentationSettings(this.fontSize, this.showBackground, this.darkMode, this.showName, this.allCapital);

  factory PresentationSettings.fromJson(Map<String, dynamic> json) {
    return PresentationSettings(
      json['font_size'],
      json['show_background'],
      json['dark_mode'],
      json['show_name'],
      json['all_capital'],
    );
  }

  PresentationSettings copyWith({
    int? fontSize,
    bool? showBackground,
    bool? darkMode,
    bool? showName,
    bool? allCapital,
  }) {
    return PresentationSettings(
      fontSize ?? this.fontSize,
      showBackground ?? this.showBackground,
      darkMode ?? this.darkMode,
      showName ?? this.showName,
      allCapital ?? this.allCapital,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'font_size': fontSize,
      'show_background': showBackground,
      'dark_mode': darkMode,
      'show_name': showName,
      'all_capital': allCapital,
    };
  }
}
