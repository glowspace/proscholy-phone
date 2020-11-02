import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zpevnik/constants.dart';

const String _fontSizeKey = 'font_size';
const String _showChordsKey = 'show_chords';
const String _accidentalsKey = 'accidentals';
const String _blockDisplayOffKey = 'block_display';
const String _showBottomOptionsKey = 'show_bottom_options';

class SettingsProvider extends ChangeNotifier {
  double _fontSize;
  bool _showChords;
  bool _accidentals;
  bool _blockDisplayOff;
  bool _showBottomOptions;

  SharedPreferences _prefs;

  SettingsProvider._();

  static final SettingsProvider shared = SettingsProvider._();

  void init() => SharedPreferences.getInstance().then((prefs) {
        _prefs = prefs;

        _fontSize = prefs.getDouble(_fontSizeKey) ?? 17;
        _showChords = prefs.getBool(_showChordsKey) ?? true;
        _accidentals = prefs.getBool(_accidentalsKey) ?? false;
        _blockDisplayOff = prefs.getBool(_blockDisplayOffKey) ?? false;
        _showBottomOptions = prefs.getBool(_showBottomOptionsKey) ?? true;

        if (_blockDisplayOff) Wakelock.enable();
      });

  double get fontSize => _fontSize;

  bool get showChords => _showChords;

  bool get accidentals => _accidentals;

  bool get blockDisplayOff => _blockDisplayOff;

  bool get showBottomOptions => _showBottomOptions;

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

    if (_blockDisplayOff)
      Wakelock.enable();
    else
      Wakelock.disable();

    notifyListeners();
  }

  void changeShowBottomOptions(bool value) {
    _showBottomOptions = value;

    _prefs.setBool(_showBottomOptionsKey, value);

    notifyListeners();
  }
}
