import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';

final songLyricRE = RegExp(r'pisen/(\d+)/');
final songbookRE = RegExp(r'zpevniky=(\d+)');

class UniLinksHandlerWrapper extends StatefulWidget {
  final Widget? child;
  const UniLinksHandlerWrapper({Key? key, this.child}) : super(key: key);

  @override
  State<UniLinksHandlerWrapper> createState() => _UniLinksHandlerWrapperState();
}

class _UniLinksHandlerWrapperState extends State<UniLinksHandlerWrapper> {
  late final StreamSubscription<Uri?> _sub;

  @override
  void initState() {
    super.initState();

    _sub = uriLinkStream.listen((uri) => handleUniLink(context, uri));
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
    final songLyricMatch = songLyricRE.firstMatch(uri.path);

    if (songLyricMatch != null) {
      final songLyric = context.read<DataProvider>().getSongLyricById(int.parse(songLyricMatch.group(1) ?? '0'));

      if (songLyric != null) {
        Navigator.of(context).pushNamed('/song_lyric', arguments: SongLyricScreenArguments([songLyric], 0));

        return;
      }
    }

    final songbookMatch = songbookRE.firstMatch(uri.path);

    if (songbookMatch != null) {
      final songbook = context.read<DataProvider>().getSongbookById(int.parse(songbookMatch.group(1) ?? '0'));

      if (songbook != null) {
        Navigator.of(context).pushNamed('/songbook', arguments: songbook);

        return;
      }
    }
  }
}
