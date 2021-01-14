import 'package:flutter/material.dart';

class FullScreenProvider extends ChangeNotifier {
  bool _fullScreen = false;

  bool get fullScreen => _fullScreen;

  void toggle() => fullScreen = !fullScreen;

  set fullScreen(bool value) {
    if (_fullScreen != value) {
      _fullScreen = value;
      notifyListeners();
    }
  }
}
