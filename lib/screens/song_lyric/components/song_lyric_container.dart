import 'package:flutter/material.dart';
import 'package:zpevnik/models/songLyric.dart';

class SongLyricContainer extends InheritedWidget {
  final SongLyric songLyric;

  SongLyricContainer({Widget child, this.songLyric}) : super(child: child);

  @override
  bool updateShouldNotify(SongLyricContainer oldWidget) => songLyric != oldWidget.songLyric;

  static SongLyricContainer of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
}
