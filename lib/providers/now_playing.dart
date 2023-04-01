import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/data.dart';

final _wssUri = Uri.parse('wss://mass-event.proscholy.cz');

class NowPlayingController extends ValueNotifier<SongLyric?> {
  final DataProvider dataProvider;

  NowPlayingController(this.dataProvider) : super(null) {
    // _connectSocket(dataProvider);

    // _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
    //   if (result == ConnectivityResult.none) {
    //     _channel?.sink.close();
    //   } else if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
    //     _channel?.sink.close();

    //     _connectSocket(dataProvider);
    //   }
    // });
  }

  WebSocketChannel? _channel;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  int reconnectTries = 0;

  Timer? _reconnectTimer;

  void _connectSocket(DataProvider dataProvider) {
    _channel = WebSocketChannel.connect(_wssUri);
    _channel!.sink.add('ask');

    _channel!.stream.listen(
      (event) {
        reconnectTries = 0;
        value = dataProvider.getSongLyricById(int.tryParse(event as String) ?? -1);
      },
      onError: (_) => {},
      onDone: () {
        if (reconnectTries > 5) {
          value = null;
        }

        _reconnectTimer = Timer(
          Duration(seconds: min(60, pow(2, reconnectTries++).toInt())),
          () => _connectSocket(dataProvider),
        );
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _channel?.sink.close();

    _reconnectTimer?.cancel();

    super.dispose();
  }
}
