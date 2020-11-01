import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/constants.dart';

const String _fontSizeKey = 'font_size';
const String _showChordsKey = 'show_chords';
const String _accidentalsKey = 'accidentals';
const String _blockDisplayOffKey = 'block_display';

class SettingsProvider extends ChangeNotifier {
  double _fontSize;
  bool _showChords;
  bool _accidentals;
  bool _blockDisplayOff;

  SharedPreferences _prefs;

  SettingsProvider._();

  static final SettingsProvider shared = SettingsProvider._();

  void init() => SharedPreferences.getInstance().then((prefs) {
        _prefs = prefs;

        _fontSize = prefs.getDouble(_fontSizeKey) ?? 17;
        _showChords = prefs.getBool(_showChordsKey) ?? true;
        _accidentals = prefs.getBool(_accidentalsKey) ?? false;
        _blockDisplayOff = prefs.getBool(_blockDisplayOffKey) ?? false;
      });

  double get fontSize => _fontSize;

  bool get showChords => _showChords;

  bool get accidentals => _accidentals;

  bool get blockDisplayOff => _blockDisplayOff;

  void changeFontSize(double value) {
    if (value < kMinimumFontSize)
      value = kMinimumFontSize;
    else if (value > kMaximumFontSize) value = kMaximumFontSize;

    _fontSize = value;

    _prefs.setDouble(_fontSizeKey, value);

    notifyListeners();
  }

  set showChords(bool value) {
    _showChords = value;

    _prefs.setBool(_showChordsKey, value);

    notifyListeners();
  }

  set accidentals(bool value) {
    _accidentals = value;

    _prefs.setBool(_accidentalsKey, value);

    notifyListeners();
  }

  void changeBlockDisplayOff(bool value) {
    _blockDisplayOff = value;

    _prefs.setBool(_blockDisplayOffKey, value);

    notifyListeners();
  }
}
