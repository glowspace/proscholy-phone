import 'package:flutter/material.dart';
import 'package:zpevnik/custom/sqlite-bm25/bm25.dart';
import 'package:zpevnik/models/model.dart' as model;
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/song_lyrics_search.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/platform/utils/route_builder.dart';
import 'package:zpevnik/providers/utils/searchable.dart';

class SongLyricsProvider extends ChangeNotifier with Searchable<SongLyric> {
  final List<SongLyric> allSongLyrics;
  final bool onlyFavorite;

  SongLyricsProvider(this.allSongLyrics, {this.onlyFavorite = false}) : _selectedTags = [];

  List<SongLyric>? _songLyrics;
  List<Tag> _selectedTags;

  List<Tag> get selectedTags => _selectedTags;

  SongLyric? _matchedById;

  @override
  set searchText(String newValue) {
    super.searchText = newValue;

    _matchedById = null;

    if (newValue.isEmpty) return _setSongLyrics(null);

    model.Model().searchSongLyrics(newValue).then(_handleSearchResults);
  }

  @override
  List<SongLyric> get items {
    final songLyrics = _filter(_songLyrics ?? allSongLyrics);

    if (onlyFavorite) return songLyrics.where((songLyric) => songLyric.isFavorite).toList();

    return songLyrics;
  }

  @override
  void onSubmitted(BuildContext context) {
    super.onSubmitted(context);

    final matchedById = _matchedById;
    // if (matchedById != null)
    // Navigator.of(context).push(platformRouteBuilder(context, SongLyricScreen(songLyric: matchedById)));
  }

  List<SongLyric> _filter(List<SongLyric> songLyrics) {
    if (selectedTags.isEmpty) return songLyrics;

    final tagGroups = Map<TagType, List<Tag>>.from({});

    for (final tag in selectedTags) {
      if (!tagGroups.containsKey(tag.type)) tagGroups[tag.type] = [];

      tagGroups[tag.type]!.add(tag);
    }

    final filtered = List<SongLyric>.empty(growable: true);

    for (final songLyric in songLyrics) {
      bool shouldAdd = true;
      for (final entry in tagGroups.entries) {
        if (entry.key == TagType.language)
          shouldAdd &= entry.value.map((tag) => tag.name).contains(songLyric.language);
        else
          shouldAdd &= entry.value.any((tag) => songLyric.tagIds.contains(tag.id));
      }

      if (shouldAdd) filtered.add(songLyric);
    }

    return filtered;
  }

  void _handleSearchResults(List<dynamic>? results) {
    if (results == null) return;

    final ranks = Map<int, double>.from({});
    final songLyricsMap = Map<int, SongLyric>.from({});
    final songLyrics = List<SongLyric>.empty(growable: true);

    for (final songLyric in allSongLyrics) {
      if (songLyric.id.toString().toLowerCase() == searchText) _matchedById = songLyric;

      songLyricsMap[songLyric.id] = songLyric;
    }

    for (final value in results) {
      final songLyric = songLyricsMap[value['id']];

      if (songLyric != null) {
        songLyrics.add(songLyric);

        ranks[value['id']] = bm25(value['info'], weights: [50.0, 40.0, 35.0, 30.0, 1.0, 48.0]);
      }
    }

    songLyrics.sort((first, second) => ranks[first.id]!.compareTo(ranks[second.id]!));

    _setSongLyrics(songLyrics);
  }

  void toggleSelected(Tag tag) {
    tag.toggleIsSelected();

    if (tag.isSelected)
      _selectedTags.add(tag);
    else
      _selectedTags.remove(tag);

    notifyListeners();
  }

  void clearTags() {
    for (final tag in _selectedTags) tag.toggleIsSelected();

    _selectedTags = [];

    notifyListeners();
  }

  void _setSongLyrics(List<SongLyric>? songLyrics) {
    _songLyrics = songLyrics;

    notifyListeners();
  }

  bool onReorder(Key key, Key other) {
    int index = allSongLyrics.indexWhere((songLyric) => songLyric.key == key);
    int otherIndex = allSongLyrics.indexWhere((songLyric) => songLyric.key == other);

    final songLyric = allSongLyrics.removeAt(index);
    allSongLyrics.insert(otherIndex, songLyric);

    notifyListeners();

    return true;
  }

  void onReorderDone(Key _, {Playlist? playlist}) {
    if (playlist != null)
      playlist.reorderSongLyrics(allSongLyrics);
    else {
      int rank = 0;

      for (final songLyric in allSongLyrics) if (songLyric.isFavorite) songLyric.favoriteRank = rank++;
    }
  }
}
