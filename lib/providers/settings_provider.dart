import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/global.dart';

const String _fontSizeScaleScaleKey = 'font_size_scale';
const String _showChordsKey = 'show_chords';
const String _accidentalsKey = 'accidentals';
const String _blockDisplayOffKey = 'block_display';
const String _showBottomOptionsKey = 'show_bottom_options';
const String _darkModeKey = 'dark_mode';

class SettingsProvider extends ChangeNotifier {
  double _fontSizeScale;
  double _fontSizeScaleBeforeScale;
  bool _showChords;
  bool _accidentals;
  bool _blockDisplayOff;
  bool _showBottomOptions;
  bool _darkMode;

  SharedPreferences _prefs;

  SettingsProvider() {
    _prefs = Global.shared.prefs;

    _fontSizeScale = _prefs.getDouble(_fontSizeScaleScaleKey) ?? 1;
    _showChords = _prefs.getBool(_showChordsKey) ?? true;
    _accidentals = _prefs.getBool(_accidentalsKey) ?? false;
    _blockDisplayOff = _prefs.getBool(_blockDisplayOffKey) ?? true;
    _showBottomOptions = _prefs.getBool(_showBottomOptionsKey) ?? true;
    _darkMode = _prefs.getBool(_darkModeKey);

    if (_blockDisplayOff) Wakelock.enable();
  }

  double get fontSizeScale => _fontSizeScale;

  bool get showChords => _showChords;

  bool get accidentals => _accidentals;

  bool get blockDisplayOff => _blockDisplayOff;

  bool get showBottomOptions => _showBottomOptions;

  bool get darkMode => _darkMode;

  void changeFontSizeScale(double value) {
    if (value < kMinimumFontSizeScale)
      value = kMinimumFontSizeScale;
    else if (value > kMaximumFontSizeScale) value = kMaximumFontSizeScale;

    _fontSizeScale = value;

    _prefs.setDouble(_fontSizeScaleScaleKey, value);

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

  void changeDarkMode(bool value) {
    _darkMode = value;

    _prefs.setBool(_darkModeKey, value);

    notifyListeners();
  }

  void fontScaleStarted(_) => _fontSizeScaleBeforeScale = fontSizeScale;

  void fontScaleUpdated(ScaleUpdateDetails details) => changeFontSizeScale(_fontSizeScaleBeforeScale * details.scale);
}
