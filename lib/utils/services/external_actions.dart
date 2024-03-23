import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpevnik/components/playlist/dialogs.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/services/spotlight.dart';

// this helper class will handle opening app from spotlight on iOS and receiving shared playlist
class ExternalActionsService {
  final navigatorKey = GlobalKey<NavigatorState>();

  final channel = const MethodChannel('opened_file');

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

    if (context == null) return;

    try {
      showAcceptReceivedPlaylistDialog(context, jsonDecode(playlistData));
    } on FormatException {
      showAlertDialog(
        context: context,
        title: 'Chyba při importu playlistu.',
        message: 'Importovaný playlist se nepodařilo načíst, zkontrolujte prosím, že je soubor ve správném formátu.',
        actions: [const AlertDialogAction(key: '', label: 'Ok')],
      );
    }
  }

  void _handleSpotlight(String? route) {
    if (route == null) return;

    navigatorKey.currentContext?.push(route);
  }
}
