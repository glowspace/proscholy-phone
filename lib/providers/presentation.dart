import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/models/presentation.dart';

class PresentationProvider extends ChangeNotifier {
  final presentation = Presentation();

  SongLyricsParser? _songLyricsParser;
  Function? _nextAction;

  bool _isPresenting = false;
  bool _isPaused = false;

  bool get isPresenting => _isPresenting;
  bool get isPaused => _isPaused;

  bool _isBeforeStart = false;
  bool _isAfterEnd = false;

  int _verseOrder = 0;

  PresentationData _showingData = defaultPresentationData;
  PresentationSettings get settings => _showingData.settings;

  void start(SongLyricsParser songLyricsParser) {
    _isPresenting = true;
    _verseOrder = 0;

    _songLyricsParser = songLyricsParser;

    presentation.startPresentation();
    _changeShowingData(_showingData.copyWith(
      songLyricId: songLyricsParser.songLyric.id,
      songLyricName: songLyricsParser.songLyric.name,
      lyrics: songLyricsParser.getVerse(_verseOrder),
    ));

    notifyListeners();
  }

  void stop() {
    _isPresenting = false;

    presentation.stopPresentation();

    notifyListeners();
  }

  void nextVerse() {
    if (_isAfterEnd) return;
    _isBeforeStart = false;

    _verseOrder++;

    final verse = _songLyricsParser!.getVerse(_verseOrder);
    if (verse.isEmpty) _isAfterEnd = true;

    if (isPaused) {
      _nextAction = () => _changeShowingData(_showingData.copyWith(lyrics: verse));
    } else {
      _changeShowingData(_showingData.copyWith(lyrics: verse));
    }
  }

  void prevVerse() {
    if (_isBeforeStart) return;
    _isAfterEnd = false;

    _verseOrder--;

    final verse = _songLyricsParser!.getVerse(_verseOrder);
    if (verse.isEmpty) _isBeforeStart = true;

    if (isPaused) {
      _nextAction = () => _changeShowingData(_showingData.copyWith(lyrics: verse));
    } else {
      _changeShowingData(_showingData.copyWith(lyrics: verse));
    }
  }

  void togglePause() {
    _isPaused = !_isPaused;

    if (!_isPaused) _nextAction?.call();

    notifyListeners();
  }

  void changeSettings(PresentationSettings settings) {
    _changeShowingData(_showingData.copyWith(settings: settings));
  }

  void changeSongLyric(SongLyricsParser songLyricsParser) {
    _verseOrder = 0;

    _songLyricsParser = songLyricsParser;

    if (isPaused) {
      _nextAction = () {
        _changeShowingData(_showingData.copyWith(
          songLyricId: songLyricsParser.songLyric.id,
          songLyricName: songLyricsParser.songLyric.name,
          lyrics: songLyricsParser.getVerse(_verseOrder),
        ));
      };
    } else {
      _changeShowingData(_showingData.copyWith(
        songLyricId: songLyricsParser.songLyric.id,
        songLyricName: songLyricsParser.songLyric.name,
        lyrics: songLyricsParser.getVerse(_verseOrder),
      ));
    }
  }

  void _changeShowingData(PresentationData data) {
    _showingData = data;
    presentation.transferData(jsonEncode(data));
  }

  Future<bool> get canPresent => presentation.canPresent();
}
