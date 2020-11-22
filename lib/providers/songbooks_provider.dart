import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/models/songbook.dart';

class SongbooksProvider extends ChangeNotifier {
  final List<Songbook> _allSongbooks;
  List<Songbook> _songbooks;

  String _searchText;

  SongbooksProvider(this._allSongbooks)
      : _searchText = '',
        _songbooks = _allSongbooks {
    _sort();
  }

  List<Songbook> get songbooks => _songbooks.toList();

  void togglePinned(Songbook songbook) {
    songbook.pinned = !songbook.isPinned;

    _sort();

    notifyListeners();
  }

  void search(String searchText) {
    _searchText = searchText;

    final predicates = _predicates;
    List<List<Songbook>> searchResults = List<List<Songbook>>.generate(predicates.length, (index) => []);

    for (final songbook in _allSongbooks) {
      for (int i = 0; i < predicates.length; i++) {
        if (predicates[i](songbook, _searchText.toLowerCase())) {
          searchResults[i].add(songbook);
          break;
        }
      }
    }

    print(searchResults);

    _songbooks = searchResults.reduce((result, list) {
      result.addAll(list);
      return result;
    }).toList();

    notifyListeners();
  }

  List<bool Function(Songbook, String)> get _predicates => [
        (songbook, searchText) => songbook.name.toLowerCase().startsWith(searchText),
        (songbook, searchText) => removeDiacritics(songbook.name.toLowerCase()).startsWith(searchText),
        (songbook, searchText) => songbook.name.toLowerCase().contains(searchText),
        (songbook, searchText) => removeDiacritics(songbook.name.toLowerCase()).contains(searchText),
      ];

  void _sort() => _songbooks.sort((first, second) => first.compareTo(second));
}
