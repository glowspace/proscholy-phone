import 'package:flutter/foundation.dart';

@immutable
class PresentationSettings {
  final double fontSizeScale;
  final bool showName;
  final bool allCapital;

  const PresentationSettings(this.fontSizeScale, this.showName, this.allCapital);

  PresentationSettings copyWith({double? fontSizeScale, bool? showName, bool? allCapital}) {
    return PresentationSettings(
      fontSizeScale ?? this.fontSizeScale,
      showName ?? this.showName,
      allCapital ?? this.allCapital,
    );
  }
}
