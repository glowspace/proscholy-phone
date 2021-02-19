import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenProvider extends ChangeNotifier {
  bool _fullScreen = false;

  bool get fullScreen => _fullScreen;

  void toggle() => fullScreen = !fullScreen;

  set fullScreen(bool value) {
    if (_fullScreen != value) {
      _fullScreen = value;
      notifyListeners();
    }

    if (_fullScreen)
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    else
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }
}
