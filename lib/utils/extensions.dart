import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart' hide red, green, blue;

extension PlatformExtension on TargetPlatform {
  bool get isAndroid => this == TargetPlatform.android;
  bool get isIos => this == TargetPlatform.iOS;
}

extension BrightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;
}

extension AsyncSnapshotExtension on AsyncSnapshot {
  bool get isDone => connectionState == ConnectionState.done;
}

extension HexColor on Color {
  static Color? fromHex(String? hexColor) {
    if (hexColor == null) return null;

    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) hexColor = "FF$hexColor";

    return Color(int.parse(hexColor, radix: 16));
  }

  String get hex {
    return '#${red.toRadixString(16)}${green.toRadixString(16)}${blue.toRadixString(16)}';
  }
}

extension MediaQueryExtension on MediaQueryData {
  bool get isTablet => size.width > kTabletSizeBreakpoint && size.height > kTabletSizeBreakpoint;
  bool get isLandscape => orientation == Orientation.landscape;
}
