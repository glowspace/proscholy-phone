import 'package:flutter/material.dart';

double computeTextWidth(String? text, {TextStyle? textStyle, double scaleFactor = 1.0}) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: textStyle),
    maxLines: 1,
    textScaleFactor: scaleFactor,
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();

  return textPainter.size.width;
}
