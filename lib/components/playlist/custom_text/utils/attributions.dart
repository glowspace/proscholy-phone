import 'dart:ui';

import 'package:super_editor/super_editor.dart';

class ColorAttribution implements Attribution {
  final Color color;

  ColorAttribution({required this.color});

  @override
  String get id => 'color';

  @override
  bool canMergeWith(Attribution other) => this == other;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is ColorAttribution && color == other.color);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '[ColorAttribution]: $color';
}

class FontSizeAttribution implements Attribution {
  final double size;

  FontSizeAttribution(this.size);

  @override
  String get id => 'font_size';

  @override
  bool canMergeWith(Attribution other) => this == other;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FontSizeAttribution && size == other.size);

  @override
  int get hashCode => size.hashCode;

  @override
  String toString() => '[FontSizeAttribution]: $size';
}
