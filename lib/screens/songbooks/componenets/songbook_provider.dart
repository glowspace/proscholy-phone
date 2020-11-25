import 'package:flutter/material.dart';
import 'package:zpevnik/models/songbook.dart';

class SongbookProvider extends InheritedWidget {
  final Songbook songbook;

  const SongbookProvider({Widget child, this.songbook}) : super(child: child);

  @override
  bool updateShouldNotify(SongbookProvider oldWidget) => songbook != oldWidget.songbook;

  static SongbookProvider of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
}
