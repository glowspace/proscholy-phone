import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_core_spotlight/flutter_core_spotlight.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';

final spotlightSongLyricRE = RegExp(r'^song_lyric_(\d+)$');
final uniLinkSongLyricRE = RegExp(r'pisen/(\d+)/');
final uniLinkSongbookRE = RegExp(r'zpevniky=(\d+)');

class LinksHandlerWrapper extends StatefulWidget {
  final Widget? child;

  const LinksHandlerWrapper({Key? key, this.child}) : super(key: key);

  @override
  State<LinksHandlerWrapper> createState() => _LinksHandlerWrapperState();
}

class _LinksHandlerWrapperState extends State<LinksHandlerWrapper> {
  late final StreamSubscription<Uri?> _sub;

  @override
  void initState() {
    super.initState();

    getInitialUri().then((link) => handleUniLink(context, link));

    _sub = uriLinkStream.listen((uri) => handleUniLink(context, uri));

    FlutterCoreSpotlight.instance.configure(
      onSearchableItemSelected: (userActivity) => _handleSpotlight(context, userActivity?.uniqueIdentifier),
    );
  }

  @override
  void dispose() {
    _sub.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child ?? Container();
}

void handleUniLink(BuildContext context, Uri? uri) async {
  if (uri != null) {
    final songLyricMatch = uniLinkSongLyricRE.firstMatch(uri.path);

    if (songLyricMatch != null) {
      _pushSongLyric(context, songLyricMatch);

      return;
    }

    final songbookMatch = uniLinkSongbookRE.firstMatch(uri.path);

    if (songbookMatch != null) {
      final songbook = context.read<DataProvider>().getSongbookById(int.parse(songbookMatch.group(1) ?? '0'));

      if (songbook != null) {
        Navigator.of(context).pushNamed('/songbook', arguments: songbook);

        return;
      }
    }
  }
}

void _handleSpotlight(BuildContext context, String? identifier) {
  if (identifier == null) return;

  final songLyricMatch = spotlightSongLyricRE.firstMatch(identifier);

  if (songLyricMatch != null) {
    _pushSongLyric(context, songLyricMatch);

    return;
  }
}

void _pushSongLyric(BuildContext context, RegExpMatch idMatch) {
  final songLyric = context.read<DataProvider>().getSongLyricById(int.parse(idMatch.group(1) ?? '0'));

  if (songLyric != null) {
    Navigator.of(context).pushNamed('/song_lyric', arguments: SongLyricScreenArguments([songLyric], 0));
  }
}
