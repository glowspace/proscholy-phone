import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/models/custom_text.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/presentation.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/utils/services/presentation.dart';

final presentationProvider = ChangeNotifierProvider((ref) => PresentationProvider());

class PresentationProvider extends ChangeNotifier {
  SongLyricsParser? _songLyricsParser;
  Function? _nextAction;

  bool _isPresenting = false;
  bool _isPresentingLocally = false;
  bool _isPaused = false;

  bool get isPresenting => _isPresenting;
  bool get isPresentingLocally => _isPresenting && _isPresentingLocally;
  bool get isPaused => _isPaused;
  bool get isVisible => _presentationData.settings.isVisible;

  bool get hasSongLyricsParser => _songLyricsParser != null;

  int _part = 0;
  int get part => _part;

  PresentationData _presentationData = defaultPresentationData;
  PresentationSettings get settings => _presentationData.settings;

  PresentationData get presentationData => _presentationData;

  void start() async {
    _isPresenting = true;
    _isPresentingLocally = !(await onExternalDisplay);
    _part = 0;

    if (!_isPresentingLocally) PresentationService.instance.startPresentation();

    notifyListeners();
  }

  void stop() {
    _isPresenting = false;

    PresentationService.instance.stopPresentation();

    notifyListeners();
  }

  void nextVerse() {
    final verse = _songLyricsParser!.getVerse(++_part);
    if (verse.isEmpty) {
      _part--;
      return;
    }

    if (isPaused) {
      _nextAction = () => _changeShowingData(_presentationData.copyWith(text: verse));
    } else {
      _changeShowingData(_presentationData.copyWith(text: verse));
    }
  }

  void prevVerse() {
    final verse = _songLyricsParser!.getVerse(--_part);
    if (verse.isEmpty) {
      _part++;
      return;
    }

    if (isPaused) {
      _nextAction = () => _changeShowingData(_presentationData.copyWith(text: verse));
    } else {
      _changeShowingData(_presentationData.copyWith(text: verse));
    }
  }

  void togglePause() {
    _isPaused = !_isPaused;

    if (!_isPaused) _nextAction?.call();

    notifyListeners();
  }

  void toggleVisibility() {
    _changeShowingData(
      _presentationData.copyWith(
        settings: _presentationData.settings.copyWith(isVisible: !_presentationData.settings.isVisible),
      ),
    );
  }

  void changePart(int part) {
    _part = part;

    final verse = _songLyricsParser!.getVerse(_part);
    if (verse.isEmpty) {
      _part++;
      return;
    }

    if (isPaused) {
      _nextAction = () => _changeShowingData(_presentationData.copyWith(text: verse));
    } else {
      _changeShowingData(_presentationData.copyWith(text: verse));
    }
  }

  void changeSettings(PresentationSettings settings) {
    _changeShowingData(_presentationData.copyWith(settings: settings));

    notifyListeners();
  }

  void change(DisplayableItem displayableItem) {
    _part = 0;

    final changeFunction = switch (displayableItem) {
      (BibleVerse bibleVerse) => () {
          _songLyricsParser = null;

          _changeShowingData(_presentationData.copyWith(
            songLyricId: null,
            isCustomText: false,
            name: bibleVerse.name,
            text: bibleVerse.text,
          ));
        },
      (CustomText customText) => () {
          _songLyricsParser = null;

          _changeShowingData(_presentationData.copyWith(
            songLyricId: null,
            isCustomText: true,
            name: customText.name,
            text: customText.content,
          ));
        },
      (SongLyric songLyric) => () {
          final songLyricsParser = SongLyricsParser(songLyric);

          _songLyricsParser = songLyricsParser;

          return _changeShowingData(_presentationData.copyWith(
            songLyricId: songLyricsParser.songLyric.id,
            isCustomText: false,
            name: songLyricsParser.songLyric.name,
            text: songLyricsParser.getVerse(_part),
          ));
        },
      _ => throw UnimplementedError(),
    };

    // if presentation is paused store it as pending action otherwise execute it immediately
    if (isPaused) {
      _nextAction = changeFunction;
    } else {
      changeFunction();
    }
  }

  void _changeShowingData(PresentationData data) {
    _presentationData = data;

    if (!isPresentingLocally) PresentationService.instance.transferData(data);

    notifyListeners();
  }

  Future<bool> get onExternalDisplay => PresentationService.instance.isExternalScreenConnected();
}
