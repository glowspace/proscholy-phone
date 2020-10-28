import 'package:flutter/material.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class SongbooksProvider extends ChangeNotifier implements Searchable {
  final List<Songbook> _songbooks;

  String _searchText;

  SongbooksProvider(this._songbooks) : _searchText = '';

  List<Songbook> get songbooks => _songbooks
      .where((songbook) => songbook.name.contains(_searchText))
      .toList();

  @override
  void search(String searchText) {
    _searchText = searchText;

    notifyListeners();
  }
}
