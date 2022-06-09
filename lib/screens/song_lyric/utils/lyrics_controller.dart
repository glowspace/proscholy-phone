import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/screens/song_lyric/utils/parser.dart';

final _styleRE = RegExp(r'\<style[^\<]*\<\/style\>');
final _heightRE = RegExp(r'height="([\d\.]+)mm"');
final _widthRE = RegExp(r'width="([\d\.]+)"');

class LyricsController extends ChangeNotifier {
  final SongLyric songLyric;
  final SongLyricsParser parser;

  LyricsController(this.songLyric) : parser = SongLyricsParser(songLyric);

  double? _lilypondWidth;
  String? _lilypond;

  String get title => songLyric.name;

  bool get hasLilypond => songLyric.lilypond != null;

  double get lilypondWidth => _lilypondWidth ?? 0;

  String lilypond(String hexColor) {
    if (_lilypond != null) return _lilypond!;

    _lilypond = (songLyric.lilypond ?? '')
        .replaceAll(_styleRE, '')
        .replaceAll('currentColor', hexColor)
        .replaceFirst(_heightRE, '')
        .replaceFirstMapped(_widthRE, (match) {
      _lilypondWidth = double.tryParse(match.group(1) ?? '');

      return '';
    });

    return _lilypond!;
  }

  bool _isProjectionEnabled = false;
  int _currentlyProjectedVerse = 0;
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

  bool get showChords => songLyric.showChords ?? true; // ?? settingsProvider.showChords;
  int get accidentals => songLyric.accidentals ?? 0; // ?? settingsProvider.accidentals;

  void changeTransposition(int byValue) {
    songLyric.transposition += byValue;

    notifyListeners();
  }

  void accidentalsChanged(int accidentals) {
    songLyric.accidentals = accidentals;

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

    // settingsProvider.fontSizeScale = 1;

    notifyListeners();
  }
}
