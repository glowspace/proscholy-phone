import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SelectionProvider with ChangeNotifier {
  bool _selectionEnabled;
  Map<int, SongLyric> _selected;

  SelectionProvider()
      : _selectionEnabled = false,
        _selected = {};

  bool get selectionEnabled => _selectionEnabled;

  bool isSelected(SongLyric songLyric) => _selected.containsKey(songLyric.id);

  bool get allFavorited => !_selected.values.any((songLyric) => !songLyric.isFavorite);

  int get selectedCount => _selected.length;

  List<SongLyric> get selected => _selected.values.toList();

  set selectionEnabled(bool value) {
    _selectionEnabled = value;

    if (!value) _selected.clear();

    notifyListeners();
  }

  void toggleSongLyric(SongLyric songLyric) {
    if (!_selectionEnabled) _selectionEnabled = true;

    if (_selected.containsKey(songLyric.id))
      _selected.remove(songLyric.id);
    else
      _selected[songLyric.id] = songLyric;

    notifyListeners();
  }

  void toggleFavorite() {
    bool favorite = !allFavorited;

    for (final songLyric in _selected.values) if (songLyric.isFavorite != favorite) songLyric.toggleFavorite();

    notifyListeners();
  }

  void toggleAll(List<SongLyric> songLyrics) {
    if (songLyrics.any((songLyric) => !_selected.containsKey(songLyric.id)))
      for (final songLyric in songLyrics) _selected[songLyric.id] = songLyric;
    else
      _selected.clear();

    notifyListeners();
  }
}
