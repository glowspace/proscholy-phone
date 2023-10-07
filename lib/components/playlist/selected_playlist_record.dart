import 'package:flutter/material.dart';
import 'package:zpevnik/models/playlist_record.dart';

class SelectedPlaylistRecord extends InheritedWidget {
  final ValueNotifier<PlaylistRecord?> playlistRecordNotifier;

  const SelectedPlaylistRecord({super.key, required super.child, required this.playlistRecordNotifier});

  @override
  bool updateShouldNotify(SelectedPlaylistRecord oldWidget) {
    return playlistRecordNotifier != oldWidget.playlistRecordNotifier;
  }

  static ValueNotifier<PlaylistRecord?>? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SelectedPlaylistRecord>()?.playlistRecordNotifier;
  }
}
