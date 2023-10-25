import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:zpevnik/models/spotlight_item.dart';

final spotlightSongLyricRE = RegExp(r'^song_lyric_(\d+)$');

class SpotlightService {
  final methodChannel = const MethodChannel('spotlight');

  const SpotlightService._();

  static SpotlightService instance = const SpotlightService._();

  Future<String?> getInitialRoute() async {
    final identifier = await methodChannel.invokeMethod<String>('getInitiallyOpenedItemIdentifier');

    return _parseSongLyricId(identifier);
  }

  Future<void> indexItems(List<SpotlightItem> items) => methodChannel.invokeMethod('indexItems', jsonEncode(items));

  Future<void> deindexItems(List<String> identifiers) => methodChannel.invokeMethod('deindexItems', identifiers);

  void setMethodCallHandler(Function(String?) callHandler) {
    methodChannel.setMethodCallHandler((call) => callHandler(_parseSongLyricId(call.arguments)));
  }

  String? _parseSongLyricId(String? identifier) {
    if (identifier == null) return null;

    final songLyricMatch = spotlightSongLyricRE.firstMatch(identifier);

    final songLyricId = songLyricMatch?.group(1);

    if (songLyricId != null) return '/song_lyric?id=$songLyricId';

    return null;
  }
}
