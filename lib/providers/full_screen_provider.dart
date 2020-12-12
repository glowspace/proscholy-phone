import 'package:flutter/material.dart';

class FullScreenProvider extends ChangeNotifier {
  bool _fullScreen = false;

  bool get fullScreen => _fullScreen;

  void toggle() {
    _fullScreen = !_fullScreen;
    notifyListeners();
  }
}
