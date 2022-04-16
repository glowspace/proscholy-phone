import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/scroll.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/song_lyric/utils/converter.dart';
import 'package:zpevnik/screens/song_lyric/utils/parser.dart';

final _styleRE = RegExp(r'\<style[^\<]*\<\/style\>');

class LyricsController extends ChangeNotifier {
  final SongLyric songLyric;
  final SettingsProvider settingsProvider;

  final scrollProvider = ScrollProvider(ScrollController());

  // needed so that lyrics widget does not rebuild after toggling full screen mode
  final lyricsGlobalKey = GlobalKey();

  LyricsController(this.songLyric, this.settingsProvider)
      : _isProjectionEnabled = false,
        _currentlyProjectedVerse = 0;

  String get title => songLyric.name;
  bool get hasLilypond => songLyric.lilypond != null;

  String prepareLilypond(Color textColor) {
    String lilypond = songLyric.lilypond ?? '';

    final color =
        '#${textColor.red.toRadixString(16)}${textColor.green.toRadixString(16)}${textColor.blue.toRadixString(16)}';

    return lilypond.replaceAll(_styleRE, '').replaceAll('currentColor', color);
  }

  bool _isProjectionEnabled;
  int _currentlyProjectedVerse;
  bool get isProjectionEnabled => _isProjectionEnabled;
  int get currentlyProjectedVerse => _currentlyProjectedVerse;

  void toggleisProjectionEnabled() {
    _isProjectionEnabled = !_isProjectionEnabled;

    if (isProjectionEnabled) _currentlyProjectedVerse = 0;

    notifyListeners();
  }

  void nextVerse() {
    // if (_currentlyProjectedVerse + 1 < (_preparedLyrics?.length ?? 0)) _currentlyProjectedVerse += 1;

    notifyListeners();
  }

  void previousVerse() {
    if (_currentlyProjectedVerse > 0) _currentlyProjectedVerse -= 1;

    notifyListeners();
  }

  bool get showChords => songLyric.showChords ?? settingsProvider.showChords;
  int get accidentals => songLyric.accidentals ?? settingsProvider.accidentals;

  void changeTransposition(int byValue) {
    songLyric.transposition += byValue;

    _convertChords();

    notifyListeners();
  }

  void accidentalsChanged(int accidentals) {
    songLyric.accidentals = accidentals;

    _convertChords();

    notifyListeners();
  }

  void showChordsChanged(bool showChords) {
    songLyric.showChords = showChords;

    notifyListeners();
  }

  void resetSettings() {
    songLyric.showChords = null;
    songLyric.accidentals = null;
    songLyric.transposition = 0;

    settingsProvider.fontSizeScale = 1;

    _convertChords();

    notifyListeners();
  }

  void _convertChords() {
    // for (final verse in _preparedLyrics ?? [])
    //   for (final line in verse.lines)
    //     for (final block in line.blocks)
    //       block.updatedChord = convertAccidentals(transpose(block.chord ?? '', songLyric.transposition), accidentals);
  }
}
