import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/utils/searchable.dart';

class SongbooksProvider extends ChangeNotifier with Searchable<Songbook> {
  List<Songbook> _allSongbooks;

  SongbooksProvider(this._allSongbooks) {
    _sort();
  }

  List<Songbook>? _songbooks;

  List<Songbook> get allSongbooks => _allSongbooks;

  set allSongbooks(List<Songbook> songbooks) {
    _allSongbooks = songbooks;

    notifyListeners();
  }

  @override
  List<Songbook> get items => _songbooks ?? allSongbooks;

  @override
  set searchText(String newValue) {
    super.searchText = newValue;

    _search();
  }

  void toggleIsPinned(Songbook songbook) {
    songbook.toggleIsPinned();

    _sort();

    notifyListeners();
  }

  void _search() {
    if (searchText.isEmpty) {
      _songbooks = null;

      notifyListeners();

      return;
    }

    final songbooks = Set<Songbook>.identity();

    for (final predicate in _predicates)
      for (final songbook in allSongbooks) if (predicate(songbook, searchText.toLowerCase())) songbooks.add(songbook);

    _songbooks = songbooks.toList();

    notifyListeners();
  }

  List<bool Function(Songbook, String)> get _predicates => [
        (songbook, searchText) => songbook.name.toLowerCase().startsWith(searchText),
        (songbook, searchText) => removeDiacritics(songbook.name.toLowerCase()).startsWith(searchText),
        (songbook, searchText) => songbook.name.toLowerCase().contains(searchText),
        (songbook, searchText) => removeDiacritics(songbook.name.toLowerCase()).contains(searchText),
      ];

  void _sort() => allSongbooks.sort((first, second) => first.compareTo(second));
}
