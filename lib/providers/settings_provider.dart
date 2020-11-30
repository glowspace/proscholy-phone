import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data_provider.dart';

const String _fontSizeKey = 'font_size';
const String _showChordsKey = 'show_chords';
const String _accidentalsKey = 'accidentals';
const String _blockDisplayOffKey = 'block_display';
const String _showBottomOptionsKey = 'show_bottom_options';

class SettingsProvider extends ChangeNotifier {
  double _fontSize;
  double _fontSizeBeforeScale;
  bool _showChords;
  bool _accidentals;
  bool _blockDisplayOff;
  bool _showBottomOptions;

  SharedPreferences _prefs;

  SettingsProvider() {
    _prefs = DataProvider.shared.prefs;

    _fontSize = _prefs.getDouble(_fontSizeKey) ?? 17;
    _showChords = _prefs.getBool(_showChordsKey) ?? true;
    _accidentals = _prefs.getBool(_accidentalsKey) ?? false;
    _blockDisplayOff = _prefs.getBool(_blockDisplayOffKey) ?? false;
    _showBottomOptions = _prefs.getBool(_showBottomOptionsKey) ?? true;

    if (_blockDisplayOff) Wakelock.enable();
  }

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

  void fontScaleStarted(_) => _fontSizeBeforeScale = fontSize;

  void fontScaleUpdated(ScaleUpdateDetails details) => changeFontSize(_fontSizeBeforeScale * details.scale);
}
