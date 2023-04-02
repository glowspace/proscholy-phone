import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/models/presentation_settings.dart';

class PresentationProvider extends ChangeNotifier {
  final presentation = Presentation();

  SongLyricsParser? _songLyricsParser;
  Function? _nextAction;

  bool _isPresenting = false;
  bool _isPaused = false;

  bool get isPresenting => _isPresenting;
  bool get isPaused => _isPaused;

  int _verseOrder = 0;

  void start(SongLyricsParser songLyricsParser) {
    _isPresenting = true;
    _verseOrder = 0;

    _songLyricsParser = songLyricsParser;

    presentation.changeSettings({'id': '${songLyricsParser.songLyric.id}', 'name': songLyricsParser.songLyric.name});
    presentation.transferData(songLyricsParser.getVerse(_verseOrder));

    notifyListeners();
  }

  void stop() {
    _isPresenting = false;

    notifyListeners();
  }

  void nextVerse() {
    _verseOrder++;

    final verse = _songLyricsParser!.getVerse(_verseOrder);
    if (verse.isEmpty) _verseOrder--;

    if (isPaused) {
      _nextAction = () => presentation.transferData(verse);
    } else {
      presentation.transferData(verse);
    }
  }

  void prevVerse() {
    _verseOrder--;

    final verse = _songLyricsParser!.getVerse(_verseOrder);
    if (verse.isEmpty) _verseOrder++;

    if (isPaused) {
      _nextAction = () => presentation.transferData(verse);
    } else {
      presentation.transferData(verse);
    }
  }

  void togglePause() {
    _isPaused = !_isPaused;

    if (!_isPaused) _nextAction?.call();

    notifyListeners();
  }

  void changeSettings(PresentationSettings settings) {
    presentation.changeSettings(settings.toJson());
  }

  void changeSongLyric(SongLyricsParser songLyricsParser) {
    _verseOrder = 0;

    _songLyricsParser = songLyricsParser;

    if (isPaused) {
      _nextAction = () {
        presentation.changeSettings({
          'id': '${songLyricsParser.songLyric.id}',
          'name': songLyricsParser.songLyric.name,
        });
        presentation.transferData(songLyricsParser.getVerse(_verseOrder));
      };
    } else {
      presentation.changeSettings({'id': '${songLyricsParser.songLyric.id}', 'name': songLyricsParser.songLyric.name});
      presentation.transferData(songLyricsParser.getVerse(_verseOrder));
    }
  }
}
