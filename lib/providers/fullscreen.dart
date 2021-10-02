import 'package:flutter/material.dart';

class FullScreenProvider extends ChangeNotifier {
  bool _isFullScreen;

  FullScreenProvider() : _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;

    notifyListeners();
  }
}
