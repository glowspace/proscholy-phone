import 'package:flutter/material.dart';

extension BrightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
}

extension AsyncSnapshotExtension on AsyncSnapshot {
  bool get isDone => connectionState == ConnectionState.done;
}
