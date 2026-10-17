import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proscholy_common/components/playlist/dialog_extensions.dart';
import 'package:proscholy_common/utils/extensions.dart';
import 'package:proscholy_common/utils/services/spotlight.dart';

// this helper class will handle opening app from spotlight on iOS and receiving shared playlist
class ExternalActionsService {
  final navigatorKey = GlobalKey<NavigatorState>();

  final channel = const MethodChannel('proscholyCommon/openedFile');

  ExternalActionsService._();

  static ExternalActionsService instance = ExternalActionsService._();

  void initialize() {
    SpotlightService.instance.setMethodCallHandler(_handleSpotlight);

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

    // on Android all opened links are handled here too, their content is null
    if (context == null || playlistData is! String) return;

    final playlist = _decodePlaylist(playlistData);

    if (playlist == null) {
      showAlertDialog(
        context: context,
        title: 'Chyba při importu playlistu.',
        message: 'Importovaný playlist se nepodařilo načíst, zkontrolujte prosím, že je soubor ve správném formátu.',
        actions: [const AlertDialogAction(key: '', label: 'Ok')],
      );
    } else {
      PlaylistDialogsExtension.acceptPlaylistWithDialog(context, playlist);
    }
  }

  // app can be opened with any json file, so it is necessary to check that it is playlist
  Map<String, dynamic>? _decodePlaylist(String playlistData) {
    try {
      final playlist = jsonDecode(playlistData);

      if (playlist is Map<String, dynamic> && playlist['records'] is List) return playlist;
    } on FormatException {
      // not a json
    }

    return null;
  }

  void _handleSpotlight(String? route) {
    if (route == null) return;

    navigatorKey.currentContext?.push(route);
  }
}
