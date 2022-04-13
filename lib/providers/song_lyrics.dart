import 'package:flutter/material.dart';
import 'package:zpevnik/custom/sqlite-bm25/bm25.dart';
import 'package:zpevnik/models/model.dart' as model;
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/song_lyrics_search.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/data.dart';

mixin _Searchable on _SongLyricsProvider {
  final Map<int, SongLyric> _allSongLyricsMap = {};

  String _searchText = '';
  List<SongLyric>? _searchResults;

  SongLyric? _matchedById;

  String get searchText => _searchText;

  SongLyric? get matchedById => _matchedById;

  set searchText(String newValue) {
    _searchText = newValue;

    if (newValue.isEmpty) {
      _searchResults = null;

      notifyListeners();
      return;
    }

    _matchedById = _allSongLyricsMap[int.tryParse(newValue) ?? -1];

    model.Model().searchSongLyrics(newValue).then(_handleSearchResults);
  }

  void _initializeSearch() {
    _allSongLyricsMap.clear();

    for (final songLyric in _allSongLyrics) {
      _allSongLyricsMap[songLyric.id] = songLyric;
    }
  }

  void _handleSearchResults(List<dynamic>? results) {
    if (results == null) return;

    final Map<int, double> ranks = {};
    final List<SongLyric> songLyrics = [];

    for (final value in results) {
      final songLyric = _allSongLyricsMap[value['id']];

      if (songLyric != null) {
        songLyrics.add(songLyric);

        ranks[value['id']] = bm25(value['info'], weights: [50.0, 40.0, 35.0, 30.0, 1.0, 48.0]);
      }
    }

    _searchResults = songLyrics..sort((a, b) => ranks[a.id]!.compareTo(ranks[b.id]!));
    notifyListeners();
  }
}

mixin _Filterable on _SongLyricsProvider {
  final Map<TagType, List<Tag>> _selectedSongLyricsTags = {};

  List<Tag> get selectedSongLyricsTags {
    final List<Tag> tags = [];

    for (final _tags in _selectedSongLyricsTags.values) {
      tags.addAll(_tags);
    }

    return tags;
  }

  List<SongLyric> _filter(List<SongLyric> songLyrics) {
    if (selectedSongLyricsTags.isEmpty) return songLyrics;

    final List<SongLyric> filtered = [];

    for (final songLyric in songLyrics) {
      bool shouldAdd = true;

      for (final entry in _selectedSongLyricsTags.entries) {
        if (entry.key == TagType.language) {
          shouldAdd &= entry.value.map((tag) => tag.name).contains(songLyric.language);
        } else {
          shouldAdd &= entry.value.any((tag) => songLyric.tagIds.contains(tag.id));
        }
      }

      if (shouldAdd) filtered.add(songLyric);
    }

    return filtered;
  }

  void toggleSelectedTag(Tag tag) {
    tag.toggleIsSelected();

    if (tag.isSelected) {
      if (!_selectedSongLyricsTags.containsKey(tag.type)) _selectedSongLyricsTags[tag.type] = [];

      _selectedSongLyricsTags[tag.type]!.add(tag);
    } else {
      _selectedSongLyricsTags[tag.type]!.remove(tag);
    }

    notifyListeners();
  }

  void clearTags() {
    for (final tag in selectedSongLyricsTags) {
      tag.toggleIsSelected();
    }

    _selectedSongLyricsTags.clear();

    notifyListeners();
  }
}

mixin _Selectable on _SongLyricsProvider {
  final Map<int, SongLyric> _selectedSongLyrics = {};

  bool _selectionEnabled = false;

  List<SongLyric> get selectedSongLyrics => _selectedSongLyrics.values.toList();

  bool get selectionEnabled => _selectionEnabled;

  String get title {
    if (selectedSongLyrics.isEmpty) {
      return "Nic nevybráno";
    } else if (selectedSongLyrics.length == 1) {
      return "1 píseň";
    } else if (selectedSongLyrics.length < 5) {
      return "${selectedSongLyrics.length} písně";
    }

    return "${selectedSongLyrics.length} písní";
  }

  bool get allFavorite => selectedSongLyrics.every((songLyric) => songLyric.isFavorite);

  set selectionEnabled(bool value) {
    _selectionEnabled = value;
    _selectedSongLyrics.clear();

    notifyListeners();
  }

  bool isSelected(SongLyric songLyric) => _selectedSongLyrics.containsKey(songLyric.id);

  void toggleSelected(SongLyric songLyric) {
    if (_selectedSongLyrics.remove(songLyric.id) == null) _selectedSongLyrics[songLyric.id] = songLyric;

    notifyListeners();
  }

  void toggleAll() {
    final allSelectedSongLyrics = songLyrics.every((songLyric) => _selectedSongLyrics.containsKey(songLyric.id));

    for (final songLyric in songLyrics) {
      if (allSelectedSongLyrics) {
        _selectedSongLyrics.remove(songLyric.id);
      } else {
        _selectedSongLyrics[songLyric.id] = songLyric;
      }
    }

    notifyListeners();
  }

  void toggleFavorite() {
    final all = allFavorite;

    for (final songLyric in selectedSongLyrics) {
      if (all == songLyric.isFavorite) songLyric.toggleFavorite();
    }

    notifyListeners();
  }
}

mixin Reorderable on _SongLyricsProvider {
  bool onReorder(Key key, Key other) {
    int index = _allSongLyrics.indexWhere((songLyric) => songLyric.key == key);
    int otherIndex = _allSongLyrics.indexWhere((songLyric) => songLyric.key == other);

    final songLyric = _allSongLyrics.removeAt(index);
    _allSongLyrics.insert(otherIndex, songLyric);

    notifyListeners();

    return true;
  }

  void onReorderDone(Key _, {Playlist? playlist}) {
    if (playlist != null) {
      playlist.reorderSongLyrics(_allSongLyrics);
    } else {
      int rank = 0;

      for (final songLyric in _allSongLyrics) {
        if (songLyric.isFavorite) songLyric.favoriteRank = rank++;
      }
    }
  }
}

class _SongLyricsProvider extends ChangeNotifier {
  List<SongLyric> _allSongLyrics = [];

  List<SongLyric> get songLyrics => _allSongLyrics;

  void update(DataProvider dataProvider, {Songbook? songbook, Playlist? playlist}) {
    if (songbook != null) {
      _allSongLyrics = dataProvider.songbookSongLyrics(songbook);
    } else if (playlist != null) {
      _allSongLyrics = dataProvider.playlistSongLyrics(playlist);
    } else {
      _allSongLyrics = dataProvider.songLyrics;
    }
  }
}

class SongLyricsProvider extends _SongLyricsProvider with _Filterable, _Searchable, _Selectable {
  SongLyricsProvider() {
    _initializeSearch();
  }

  @override
  List<SongLyric> get songLyrics => _filter(_searchResults ?? super.songLyrics);

  @override
  void update(DataProvider dataProvider, {Songbook? songbook, Playlist? playlist}) {
    super.update(dataProvider, songbook: songbook, playlist: playlist);

    _initializeSearch();
  }
}

class FavoriteSongLyricsProvider extends SongLyricsProvider with Reorderable {
  // TODO: this could be done better if isFavorite was check before calling super, or allSongLyrics should contain only favorite songlyrics
  @override
  List<SongLyric> get songLyrics => super.songLyrics.where((songLyric) => songLyric.isFavorite).toList();
}

class PlaylistSongLyricsProvider extends SongLyricsProvider with Reorderable {
  final Playlist playlist;

  PlaylistSongLyricsProvider(this.playlist) : super();

  void removeSongLyrics() => playlist.removeSongLyrics(selectedSongLyrics);
}
