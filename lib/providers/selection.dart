import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SelectionProvider extends ChangeNotifier {
  final Map<int, SongLyric> _selected;

  bool _isSelectionEnabled;

  SelectionProvider()
      : _selected = Map<int, SongLyric>.from({}),
        _isSelectionEnabled = false;

  List<SongLyric> get selected => _selected.values.toList();
  bool get isSelectionEnabled => _isSelectionEnabled;
  String get title {
    if (selected.length == 0)
      return "Nic nevybráno";
    else if (selected.length == 1)
      return "1 píseň";
    else if (selected.length < 5) return "${selected.length} písně";

    return "${selected.length} písní";
  }

  bool get allFavorited => selected.every((songLyric) => songLyric.isFavorite);

  set isSelectionEnabled(bool value) {
    _isSelectionEnabled = value;
    _selected.clear();

    notifyListeners();
  }

  bool isSelected(SongLyric songLyric) => _selected.containsKey(songLyric.id);

  void toggleSelected(SongLyric songLyric) {
    if (_selected.containsKey(songLyric.id))
      _selected.remove(songLyric.id);
    else
      _selected[songLyric.id] = songLyric;

    notifyListeners();
  }

  void toggleAll(Iterable<SongLyric> songLyrics) {
    final allSelected = songLyrics.every((songLyric) => _selected.containsKey(songLyric.id));

    for (final songLyric in songLyrics) {
      if (allSelected)
        _selected.remove(songLyric.id);
      else
        _selected[songLyric.id] = songLyric;
    }

    notifyListeners();
  }

  void toggleFavorite() {
    final all = allFavorited;

    for (final songLyric in selected) if (all == songLyric.isFavorite) songLyric.toggleFavorite();

    notifyListeners();
  }
}
