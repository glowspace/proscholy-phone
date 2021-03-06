import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_bm25/sqlite_bm25.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/tags_provider.dart';
import 'package:zpevnik/utils/database.dart';

final _numberRE = RegExp('[0-9]');

class SongLyricsProvider extends ChangeNotifier {
  final List<SongLyric> allSongLyrics;

  final TagsProvider tagsProvider;

  final ScrollController scrollController;

  List<SongLyric> _songLyrics;

  SongLyric _matchedById;

  String _searchText;

  SongLyricsProvider(this.allSongLyrics)
      : _searchText = '',
        _songLyrics = allSongLyrics,
        tagsProvider = TagsProvider(DataProvider.shared.tags),
        scrollController = ScrollController() {
    tagsProvider.addListener(_update);
  }

  List<SongLyric> get songLyrics => _songLyrics;

  SongLyric get matchedById => _matchedById;

  String get searchText => _searchText;

  bool get showingAll => _searchText.isEmpty && tagsProvider.selectedTags.isEmpty;

  void search(String searchText) {
    _searchText = searchText;

    _update();
  }

  List<SongLyric> _filter(List<SongLyric> songLyrics) {
    Map<TagType, List<Tag>> tagGroups = {};

    for (final tag in tagsProvider.selectedTags) {
      if (!tagGroups.containsKey(tag.type)) tagGroups[tag.type] = [];

      tagGroups[tag.type].add(tag);
    }

    return songLyrics
        .where((songLyric) => tagGroups.entries
            .map((entry) => entry.key == TagType.language
                ? entry.value.any((tag) => tag.name == songLyric.entity.language)
                : songLyric.entity.tags.any((tag) => entry.value.any((other) => tag.id == other.id)))
            .reduce((value, element) => value && element))
        .toList();
  }

  void _update() {
    List<SongLyric> filtered = tagsProvider.selectedTags.isEmpty ? allSongLyrics : _filter(allSongLyrics);

    if (_searchText.isEmpty) {
      _setSongLyricsAndNotify(filtered);

      return;
    }

    Map<int, SongLyric> songLyricsMap = {};

    _matchedById = null;
    for (final songLyric in filtered) {
      if (songLyric.numbers.any((number) => number.toLowerCase() == (searchText))) _matchedById = songLyric;

      songLyricsMap[songLyric.id] = songLyric;
      if (songLyric.id == 2) print(songLyric.name);
    }

    Database.shared.searchSongLyrics(_searchText.trim().replaceAll(' ', '* ') + '*').then((values) {
      List<SongLyric> songLyrics = [];
      Map<int, double> ranks = {};

      for (final value in values) {
        if (songLyricsMap.containsKey(value['id'])) {
          songLyrics.add(songLyricsMap[value['id']]);

          ranks[value['id']] = bm25(value['info'], weights: [50.0, 40.0, 35.0, 30.0, 1.0, 45.0]);
        }
      }

      // fixme: don't know how to return naturaly sorted results from FTS, so it will be sorted here
      if (_numberRE.hasMatch(_searchText))
        songLyrics.sort(
            (first, second) => compareNatural(first.showingNumber(_searchText), second.showingNumber(_searchText)));
      else
        songLyrics.sort((first, second) => ranks[first.id].compareTo(ranks[second.id]));

      _setSongLyricsAndNotify(songLyrics);
    });
  }

  void _setSongLyricsAndNotify(List<SongLyric> songLyrics) {
    if (_songLyrics.isNotEmpty) scrollController.jumpTo(0.0);

    _songLyrics = songLyrics;

    notifyListeners();
  }

  @override
  void dispose() {
    tagsProvider.removeListener(_update);

    super.dispose();
  }
}
