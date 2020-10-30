import 'package:flutter/material.dart';
import 'package:zpevnik/models/songLyric.dart';

class SongLyricsProvider extends ChangeNotifier {
  final List<SongLyric> _songLyrics;

  String _searchText;

  SongLyricsProvider(this._songLyrics) : _searchText = '';

  List<SongLyric> get songLyrics => _songLyrics.where((songLyric) => songLyric.name.contains(_searchText)).toList();

  void search(String searchText) {
    _searchText = searchText;

    notifyListeners();
  }
}
