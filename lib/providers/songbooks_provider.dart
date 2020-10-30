import 'package:flutter/material.dart';
import 'package:zpevnik/models/songbook.dart';

class SongbooksProvider extends ChangeNotifier {
  final List<Songbook> _songbooks;

  String _searchText;

  SongbooksProvider(this._songbooks) : _searchText = '';

  List<Songbook> get songbooks => _songbooks.where((songbook) => songbook.name.contains(_searchText)).toList();

  void search(String searchText) {
    _searchText = searchText;

    notifyListeners();
  }
}
