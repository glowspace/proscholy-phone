import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// in windowed mode, iPadOS shows window controls in the top leading corner of the app, which isn't part of the safe area
class WindowService {
  final methodChannel = const MethodChannel('proscholyCommon/window');

  // space at the top of the app that the window controls need
  final windowControlsHeight = ValueNotifier(0.0);

  bool _isListening = false;

  WindowService._();

  static WindowService instance = WindowService._();

  void listen() async {
    if (_isListening || !Platform.isIOS) return;

    _isListening = true;

    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'windowControlsHeightChanged') windowControlsHeight.value = call.arguments as double;
    });

    windowControlsHeight.value = await methodChannel.invokeMethod<double>('getWindowControlsHeight') ?? 0;
  }
}
