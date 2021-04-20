import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class SyncProvider extends ChangeNotifier {
  final nearbyService = NearbyService();

  Function(int) onSongChange;

  bool _isAdvertiser;
  bool _isRunning = false;

  List<Device> _availableDevices;
  List<Device> _connectedDevices;

  StreamSubscription _subscription;
  StreamSubscription _dataSubscription;

  List<Device> get availableDevices =>
      _availableDevices?.where((device) => !_connectedDevices.contains(device))?.toList() ?? List.empty();
  List<Device> get connectedDevices => _connectedDevices ?? List.empty();

  bool get isAdvertiser => _isAdvertiser ?? false;
  set isAdvertiser(bool value) {
    _isAdvertiser = value;

    if (_isAdvertiser)
      nearbyService.startAdvertisingPeer();
    else
      nearbyService.stopAdvertisingPeer();
  }

  @override
  void dispose() {
    stop(force: true);

    super.dispose();
  }

  void run(String deviceName) async {
    final callback = (isRunning) async {
      if (isRunning) {
        _isRunning = true;

        await nearbyService.stopBrowsingForPeers();
        nearbyService.startBrowsingForPeers();

        if (isAdvertiser) {
          await nearbyService.stopAdvertisingPeer();
          nearbyService.startAdvertisingPeer();
        }
      }
    };

    await nearbyService.init(
      serviceType: 'proscholy-conn',
      strategy: Strategy.P2P_STAR,
      deviceName: deviceName,
      callback: callback,
    );

    _subscription = nearbyService.stateChangedSubscription(callback: _stateChanged);
    _dataSubscription = nearbyService.dataReceivedSubscription(callback: _receivedData);
  }

  Future<void> stop({bool force = false}) async {
    if (_isRunning && (force || (!isAdvertiser))) {
      _subscription?.cancel();
      _dataSubscription?.cancel();

      await nearbyService.stopAdvertisingPeer();
      await nearbyService.stopBrowsingForPeers();
    }

    _isRunning = false;
  }

  void sendMessage(String message) {
    // only advertisers send messsages
    if (isAdvertiser) for (final device in connectedDevices) nearbyService.sendMessage(device.deviceId, message);
  }

  void _stateChanged(List<Device> devices) {
    _availableDevices = devices;
    _connectedDevices = devices.where((device) => device.state == SessionState.connected).toList();

    notifyListeners();
  }

  void _receivedData(dynamic data) {
    if (onSongChange != null) onSongChange(int.parse(data['message']));
  }
}
