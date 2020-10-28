import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/screens/components/search_widget.dart';

class SongLyricsProvider extends ChangeNotifier implements Searchable {
  final List<SongLyric> _songLyrics;

  String _searchText;

  SongLyricsProvider(this._songLyrics) : _searchText = '';

  List<SongLyric> get songLyrics => _songLyrics
      .where((songLyric) => songLyric.name.contains(_searchText))
      .toList();

  @override
  void search(String searchText) {
    _searchText = searchText;

    notifyListeners();
  }
}
