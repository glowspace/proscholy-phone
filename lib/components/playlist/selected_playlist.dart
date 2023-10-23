import 'package:flutter/material.dart';
import 'package:zpevnik/models/playlist.dart';

class SelectedPlaylist extends InheritedWidget {
  final ValueNotifier<Playlist> playlistNotifier;

  const SelectedPlaylist({super.key, required super.child, required this.playlistNotifier});

  @override
  bool updateShouldNotify(SelectedPlaylist oldWidget) {
    return playlistNotifier != oldWidget.playlistNotifier;
  }

  static ValueNotifier<Playlist>? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SelectedPlaylist>()?.playlistNotifier;
  }
}
