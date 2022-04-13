import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/fullscreen.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/songbooks.dart';

enum ProviderType { data, fullScreen, playlist, songLyric, songbook }

extension ProviderTypeExtension on ProviderType {
  SingleChildWidget provider(BuildContext context) {
    switch (this) {
      case ProviderType.data:
        return ChangeNotifierProvider.value(value: context.read<DataProvider>());
      case ProviderType.fullScreen:
        return ChangeNotifierProvider.value(value: context.read<FullScreenProvider>());
      case ProviderType.playlist:
        return ChangeNotifierProvider.value(value: context.read<PlaylistsProvider>());
      case ProviderType.songLyric:
        return ChangeNotifierProvider.value(value: context.read<SongLyricsProvider>());
      case ProviderType.songbook:
        return ChangeNotifierProvider.value(value: context.read<SongbooksProvider>());
    }
  }
}

Route<dynamic> platformRouteBuilder(
  BuildContext context,
  Widget child, {
  List<ProviderType> types = const [],
  bool fullscreen = false,
}) {
  final providers = types.map((type) => type.provider(context)).toList();
  final builder = types.isEmpty ? (_) => child : (_) => MultiProvider(providers: providers, child: child);

  if (Platform.isIOS) {
    return CupertinoPageRoute(fullscreenDialog: fullscreen, builder: builder);
  } else {
    return MaterialPageRoute(fullscreenDialog: fullscreen, builder: builder);
  }
}
