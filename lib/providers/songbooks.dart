import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/data.dart';

mixin _Searchable on _SongbooksProvider {
  String _searchText = '';
  List<Songbook>? _searchResults;

  String get searchText => _searchText;

  set searchText(String newValue) {
    _searchText = newValue;

    if (searchText.isEmpty) {
      _searchResults = null;

      notifyListeners();

      return;
    }

    final Set<Songbook> songbooks = {};

    for (final predicate in _predicates) {
      for (final songbook in _allSongbooks) {
        if (predicate(songbook, searchText.toLowerCase())) songbooks.add(songbook);
      }
    }

    _searchResults = songbooks.toList();

    notifyListeners();
  }

  List<bool Function(Songbook, String)> get _predicates => [
        (songbook, searchText) => songbook.name.toLowerCase().startsWith(searchText),
        (songbook, searchText) => removeDiacritics(songbook.name.toLowerCase()).startsWith(searchText),
        (songbook, searchText) => songbook.name.toLowerCase().contains(searchText),
        (songbook, searchText) => removeDiacritics(songbook.name.toLowerCase()).contains(searchText),
      ];
}

class _SongbooksProvider extends ChangeNotifier {
  List<Songbook> _allSongbooks = [];

  List<Songbook> get songbooks => _allSongbooks;

  void update(DataProvider provider) {
    _allSongbooks = provider.songbooks;

    _sort();
  }

  void toggleIsPinned(Songbook songbook) {
    songbook.toggleIsPinned();

    _sort();

    notifyListeners();
  }

  void _sort() => _allSongbooks.sort((first, second) => first.compareTo(second));
}

class SongbooksProvider extends _SongbooksProvider with _Searchable {
  @override
  List<Songbook> get songbooks => _searchResults ?? super.songbooks;
}
