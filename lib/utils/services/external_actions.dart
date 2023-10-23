import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_spotlight/flutter_core_spotlight.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/utils/extensions.dart';

final spotlightSongLyricRE = RegExp(r'^song_lyric_(\d+)$');

// this helper class will handle opening app from spotlight on iOS and receiving shared playlist
class ExternalActionsService {
  final navigatorKey = GlobalKey<NavigatorState>();

  final channel = const MethodChannel('opened_file');

  ExternalActionsService._();

  static ExternalActionsService instance = ExternalActionsService._();

  void initialize() {
    FlutterCoreSpotlight.instance.configure(
      onSearchableItemSelected: (userActivity) => _handleSpotlight(userActivity?.uniqueIdentifier),
    );

    channel.setMethodCallHandler(_handleOpenedFile);
  }

  void handleInitiallyOpenedFile() async {
    final playlistData = await channel.invokeMethod<String?>('getInitiallyOpenedFile');

    if (playlistData != null) _handleReceivedPlaylist(playlistData);
  }

  Future<void> _handleOpenedFile(MethodCall methodCall) async {
    if (methodCall.method == 'onOpenedFile') _handleReceivedPlaylist(methodCall.arguments);
  }

  void _handleReceivedPlaylist(dynamic playlistData) {
    final context = navigatorKey.currentContext;

    if (context == null) return;

    showAcceptReceivedPlaylistDialog(context, jsonDecode(playlistData));
  }

  void _handleSpotlight(String? identifier) {
    if (identifier == null) return;

    final songLyricMatch = spotlightSongLyricRE.firstMatch(identifier);

    if (songLyricMatch != null) navigatorKey.currentContext?.push('/song_lyric?id=${songLyricMatch.group(1)!}');
  }
}
