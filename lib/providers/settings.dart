import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/constants.dart';

const String _darkModeKey = 'dark_mode_key';
const String _fontSizeScaleScaleKey = 'font_size_scale';
const String _showChordsKey = 'show_chords';
const String _accidentalsKey = 'accidentals';

class SettingsProvider extends ChangeNotifier {
  late final SharedPreferences _prefs;

  bool? _darkModeEnabled;

  // TODO: font size scale changes should be handled in song lyrics screen instead of here
  late double _fontSizeScale;
  late double _fontSizeScaleBeforeScale;
  late bool _showChords;
  late int _accidentals;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _darkModeEnabled = _prefs.getBool(_darkModeKey);

    _fontSizeScale = _prefs.getDouble(_fontSizeScaleScaleKey) ?? 1;
    _showChords = _prefs.getBool(_showChordsKey) ?? true;
    try {
      _accidentals = _prefs.getInt(_accidentalsKey) ?? 0;
    } on TypeError {
      _prefs.remove(_accidentalsKey);
      _accidentals = 0;
    }

    notifyListeners();
  }

  bool? get darkModeEnabled => _darkModeEnabled;

  double get fontSizeScale => _fontSizeScale;

  bool get showChords => _showChords;

  int get accidentals => _accidentals;

  set darkModeEnabled(bool? value) {
    _darkModeEnabled = value;

    if (value != null) {
      _prefs.setBool(_darkModeKey, value);
    } else {
      _prefs.remove(_darkModeKey);
    }

    notifyListeners();
  }

  set fontSizeScale(double value) {
    if (value < kMinimumFontSizeScale) {
      value = kMinimumFontSizeScale;
    } else if (value > kMaximumFontSizeScale) {
      value = kMaximumFontSizeScale;
    }

    _fontSizeScale = value;

    _prefs.setDouble(_fontSizeScaleScaleKey, value);

    notifyListeners();
  }

  set showChords(bool value) {
    _showChords = value;

    _prefs.setBool(_showChordsKey, value);

    notifyListeners();
  }

  set accidentals(int value) {
    _accidentals = value;

    _prefs.setInt(_accidentalsKey, value);

    notifyListeners();
  }

  void fontScaleStarted(ScaleStartDetails _) => _fontSizeScaleBeforeScale = fontSizeScale;

  void fontScaleUpdated(ScaleUpdateDetails details) => fontSizeScale = _fontSizeScaleBeforeScale * details.scale;
}
