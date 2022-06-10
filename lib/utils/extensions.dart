import 'package:flutter/material.dart';

extension AsyncSnapshotExtension on AsyncSnapshot {
  bool get isDone => connectionState == ConnectionState.done;
}
