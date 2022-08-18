import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/models/song_lyric.dart';

const bleAdvertiseChannel = MethodChannel('cz.proscholy.zpevnik/ble_advertise');
const bleDiscoverChannel = MethodChannel('cz.proscholy.zpevnik/ble_discover');

const discoveredChannel = EventChannel('platform_channel_events/discovered_publishers');
const updatesChannel = EventChannel('platform_channel_events/updates');

@immutable
class NearbySongLyricsPublisher {
  final String publisherUUID;
  final String publisherName;
  final int songLyricId;

  const NearbySongLyricsPublisher(this.publisherUUID, this.publisherName, this.songLyricId);

  NearbySongLyricsPublisher copyWith({String? publisherUUID, String? publisherName, int? songLyricId}) {
    return NearbySongLyricsPublisher(
      publisherUUID ?? this.publisherUUID,
      publisherName ?? this.publisherName,
      songLyricId ?? this.songLyricId,
    );
  }

  @override
  int get hashCode => publisherUUID.hashCode;

  @override
  bool operator ==(Object other) => other is NearbySongLyricsPublisher && other.publisherUUID == publisherUUID;
}

final songLyricsAdvertiserProvider = StateNotifierProvider<SongLyricsAdvertiser, bool>((_) => SongLyricsAdvertiser());
final songLyricsDiscovererProvider =
    StateNotifierProvider<SongLyricsDiscoverer, Set<NearbySongLyricsPublisher>>((_) => SongLyricsDiscoverer());
final nearbySongLyricProvider = StateNotifierProvider<NearbySongLyricListener, int>((_) => NearbySongLyricListener());

class SongLyricsAdvertiser extends StateNotifier<bool> {
  SongLyricsAdvertiser() : super(false);

  void toggleAdvertising(SongLyric songLyric) {
    if (state) {
      stopAdvertising();
    } else {
      startAdvertising(songLyric);
    }
  }

  void startAdvertising(SongLyric songLyric) async {
    try {
      await bleAdvertiseChannel.invokeMethod('startAdvertising', '${songLyric.id}');
      state = true;
    } on PlatformException catch (e) {
      print(e);
      // TODO: inform user
    }
  }

  void stopAdvertising() async {
    try {
      await bleAdvertiseChannel.invokeMethod('stopAdvertising');
      state = false;
    } on PlatformException catch (e) {
      print(e);
      // TODO: inform user
    }
  }

  void onSongLyricChanged(SongLyric? songLyric) async {
    if (!state) return;

    try {
      bleAdvertiseChannel.invokeMethod('updateValue', songLyric?.id.toString());
    } on PlatformException catch (e) {
      print(e);
      // TODO: inform user
    }
  }
}

class SongLyricsDiscoverer extends StateNotifier<Set<NearbySongLyricsPublisher>> {
  SongLyricsDiscoverer() : super({});

  StreamSubscription? _discoveredSubscription;

  void startDiscovering() {
    try {
      _discoveredSubscription = discoveredChannel.receiveBroadcastStream().listen(
        (data) {
          if (data['msg_type'] == 1) {
            final publisher = NearbySongLyricsPublisher(
              data['uuid'],
              data['name'],
              int.parse(data['additional']),
            );

            state = {...state, publisher};
          } else if (data['msg_type'] == 5) {
            state = {...state..removeWhere((publisher) => publisher.publisherUUID == data['uuid'])};
          }
        },
      );
    }
    // FIXME: does not really catch anything
    on PlatformException catch (e) {
      print(e);
      // TODO: inform user
    }
  }

  void stopDiscovering() {
    _discoveredSubscription?.cancel();
  }
}

class NearbySongLyricListener extends StateNotifier<int> {
  NearbySongLyricListener() : super(-1);

  StreamSubscription? _songLyricSubscription;

  void connect(String publisherUUID) {
    bleDiscoverChannel.invokeMethod('connect', publisherUUID);

    _songLyricSubscription = updatesChannel.receiveBroadcastStream().listen((data) {
      if (data['msg_type'] == 2) {
        state = int.parse(data['data']);
      }
    });
  }

  void disconnect() {
    bleDiscoverChannel.invokeMethod('disconnect');

    _songLyricSubscription?.cancel();
  }
}
