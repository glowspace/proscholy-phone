import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/data_provider.dart';
import 'package:zpevnik/providers/tags_provider.dart';

class SongLyricsProvider extends ChangeNotifier {
  final List<SongLyric> allSongLyrics;

  final TagsProvider tagsProvider;

  List<SongLyric> _songLyrics;

  SongLyric _matchedById;

  String _searchText;

  SongLyricsProvider(this.allSongLyrics)
      : _searchText = '',
        _songLyrics = allSongLyrics,
        tagsProvider = TagsProvider(DataProvider.shared.tags) {
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

  List<bool Function(SongLyric, String)> get _predicates => [
        (songLyric, searchText) => songLyric.numbers.any((number) => number.toLowerCase() == searchText),
        (songLyric, searchText) => songLyric.numbers.any((number) => number.toLowerCase().startsWith(searchText)),
        (songLyric, searchText) => songLyric.numbers.any((number) => number.toLowerCase().contains(searchText)),
        (songLyric, searchText) => songLyric.name.toLowerCase().startsWith(searchText),
        (songLyric, searchText) => removeDiacritics(songLyric.name.toLowerCase()).startsWith(searchText),
        (songLyric, searchText) => songLyric.name.toLowerCase().contains(searchText),
        (songLyric, searchText) => removeDiacritics(songLyric.name.toLowerCase()).contains(searchText),
        (songLyric, searchText) => removeDiacritics(songLyric.entity.lyrics.toLowerCase()).contains(searchText),
      ];

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
    final predicates = _predicates;

    List<SongLyric> filtered = tagsProvider.selectedTags.isEmpty ? allSongLyrics : _filter(allSongLyrics);

    List<List<SongLyric>> searchResults = List<List<SongLyric>>.generate(predicates.length, (index) => []);

    _matchedById = null;
    for (final songLyric in filtered) {
      if (songLyric.numbers.any((number) => number.toLowerCase() == (searchText))) _matchedById = songLyric;

      for (int i = 0; i < predicates.length; i++) {
        if (predicates[i](songLyric, _searchText.toLowerCase())) {
          searchResults[i].add(songLyric);
          break;
        }
      }
    }

    _songLyrics = searchResults.reduce((result, list) {
      result.addAll(list);
      return result;
    }).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    tagsProvider.removeListener(_update);

    super.dispose();
  }
}
