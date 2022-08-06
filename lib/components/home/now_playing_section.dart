import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/routes/arguments/song_lyric.dart';
import 'package:zpevnik/utils/extensions.dart';

const _backgroundColor = Color(0xff232380);
const _backgroundHighlightColor = Color(0xff1a1a60);

final _wssUri = Uri.parse('wss://mass-event.proscholy.cz');

class NowPlayingSection extends StatefulWidget {
  const NowPlayingSection({Key? key}) : super(key: key);

  @override
  State<NowPlayingSection> createState() => _NowPlayingSectionState();
}

class _NowPlayingSectionState extends State<NowPlayingSection> {
  late WebSocketChannel _channel;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  int reconnectTries = 0;

  SongLyric? _songLyric;

  @override
  void initState() {
    super.initState();

    _connectSocket(context.read<DataProvider>());

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) _channel.sink.close();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _channel.sink.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedCrossFade(
      duration: kDefaultAnimationDuration,
      crossFadeState: _songLyric == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(),
      secondChild: Container(
        margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Highlightable(
          onTap: _songLyric == null
              ? null
              : () => Navigator.of(context).pushNamed(
                    '/song_lyric',
                    arguments: SongLyricScreenArguments([_songLyric!], 0),
                  ),
          padding: const EdgeInsets.fromLTRB(2 * kDefaultPadding, kDefaultPadding, kDefaultPadding, kDefaultPadding),
          color: theme.brightness.isLight ? _backgroundColor : _backgroundHighlightColor,
          highlightColor: theme.brightness.isLight ? _backgroundHighlightColor : _backgroundColor,
          highlightBackground: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Právě teď na CSM',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      _songLyric?.name ?? '',
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: kDefaultPadding),
              Image.asset('assets/images/logos/csmhk.png', height: 56),
            ],
          ),
        ),
      ),
    );
  }

  void _connectSocket(DataProvider dataProvider) {
    print('connecting socket');

    _channel = WebSocketChannel.connect(_wssUri);
    _channel.sink.add('ask');

    _channel.stream.listen(
      (event) {
        reconnectTries = 0;
        setState(() => _songLyric = dataProvider.getSongLyricById(int.tryParse(event as String) ?? -1));
      },
      onError: (_) => {},
      onDone: () {
        print('waiting for ${Duration(seconds: min(60, pow(2, reconnectTries).toInt()))}');

        if (reconnectTries > 5) setState(() => _songLyric = null);

        // _channel.sink.close();

        Future.delayed(
            Duration(seconds: min(60, pow(2, reconnectTries++).toInt())), () => _connectSocket(dataProvider));
      },
    );
  }
}
