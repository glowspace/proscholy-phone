import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zpevnik/constants.dart';

const String _fontSizeScaleScaleKey = 'font_size_scale';
const String _showChordsKey = 'show_chords';
const String _accidentalsKey = 'accidentals';
const String _blockDisplayOffKey = 'block_display';
const String _showBottomOptionsKey = 'show_bottom_options';
const String _bottomOptionsCollapsedKey = 'bottom_options_collapsed';
const String _isDarkModeKey = 'dark_mode';

class SettingsProvider extends ChangeNotifier {
  late final SharedPreferences _prefs;

  late double _fontSizeScale;
  late double _fontSizeScaleBeforeScale;
  late bool _showChords;
  late int _accidentals;
  late bool _blockDisplayOff;
  late bool _showBottomOptions;
  late bool _bottomOptionsCollapsed;
  late bool? _isDarkMode;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _fontSizeScale = _prefs.getDouble(_fontSizeScaleScaleKey) ?? 1;
    _showChords = _prefs.getBool(_showChordsKey) ?? true;
    _accidentals = _prefs.getInt(_accidentalsKey) ?? 0;
    _blockDisplayOff = _prefs.getBool(_blockDisplayOffKey) ?? true;
    _showBottomOptions = _prefs.getBool(_showBottomOptionsKey) ?? true;
    _bottomOptionsCollapsed = _prefs.getBool(_bottomOptionsCollapsedKey) ?? false;
    _isDarkMode = _prefs.getBool(_isDarkModeKey);

    if (_blockDisplayOff) Wakelock.enable();
  }

  double get fontSizeScale => _fontSizeScale;

  bool get showChords => _showChords;

  int get accidentals => _accidentals;

  bool get blockDisplayOff => _blockDisplayOff;

  bool get showBottomOptions => _showBottomOptions;

  bool get bottomOptionsCollapsed => _bottomOptionsCollapsed;

  bool? get isDarkMode => _isDarkMode;

  // String get lastUpdate => _prefs.getString(lastUpdateKey) ?? 'neznámé';

  set fontSizeScale(double value) {
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

  set accidentals(int value) {
    _accidentals = value;

    _prefs.setInt(_accidentalsKey, value);

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

  void toggleBottomOptionsCollapsed() {
    _bottomOptionsCollapsed = !_bottomOptionsCollapsed;

    _prefs.setBool(_bottomOptionsCollapsedKey, bottomOptionsCollapsed);
  }

  void changeIsDarkMode(bool value) {
    _isDarkMode = value;

    _prefs.setBool(_isDarkModeKey, value);

    notifyListeners();
  }

  void fontScaleStarted() => _fontSizeScaleBeforeScale = fontSizeScale;

  void fontScaleUpdated(ScaleUpdateDetails details) => fontSizeScale = _fontSizeScaleBeforeScale * details.scale;
}
