import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:zpevnik/models/spotlight_item.dart';

final spotlightSongLyricRE = RegExp(r'^song_lyric_(\d+)$');

class SpotlightService {
  final methodChannel = const MethodChannel('spotlight');

  const SpotlightService._();

  static SpotlightService instance = const SpotlightService._();

  Future<String?> getInitialRoute() async {
    if (!Platform.isIOS) return null;

    final identifier = await methodChannel.invokeMethod<String>('getInitiallyOpenedItemIdentifier');

    return _parseSongLyricId(identifier);
  }

  Future<void> indexItems(List<SpotlightItem> items) async {
    if (!Platform.isIOS) return;

    return methodChannel.invokeMethod('indexItems', jsonEncode(items));
  }

  Future<void> deindexItems(List<String> identifiers) async {
    if (!Platform.isIOS) return;

    return methodChannel.invokeMethod('deindexItems', identifiers);
  }

  void setMethodCallHandler(Function(String?) callHandler) {
    if (!Platform.isIOS) return;

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
