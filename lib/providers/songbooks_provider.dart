import 'package:flutter/material.dart';
import 'package:zpevnik/models/songbook.dart';

class SongbooksProvider extends ChangeNotifier {
  final List<Songbook> _songbooks;

  String _searchText;

  SongbooksProvider(this._songbooks) : _searchText = '' {
    _sort();
  }

  List<Songbook> get songbooks => _songbooks.where((songbook) => songbook.name.contains(_searchText)).toList();

  void togglePinned(Songbook songbook) {
    songbook.pinned = !songbook.isPinned;

    _sort();

    notifyListeners();
  }

  void search(String searchText) {
    _searchText = searchText;

    notifyListeners();
  }

  void _sort() => _songbooks.sort((first, second) => first.compareTo(second));
}
