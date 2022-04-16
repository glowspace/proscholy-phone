import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color? fromHex(String? hexColor) {
    if (hexColor == null) return null;

    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) hexColor = "FF" + hexColor;

    return Color(int.parse(hexColor, radix: 16));
  }

  String get hex {
    return '#${red.toRadixString(16)}${green.toRadixString(16)}${blue.toRadixString(16)}';
  }
}
