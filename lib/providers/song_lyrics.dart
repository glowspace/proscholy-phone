import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/custom/sqlite-bm25/bm25.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/song_lyrics_search.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/data.dart';

const _recentSongLyricsKey = 'recent_song_lyrics';
const _maxRecentSongLyrics = 5;

mixin _Filterable on SongLyricsProvider {
  final Map<TagType, List<Tag>> _selectedTagsByType = {};
  final Map<int, Tag> _selectedTags = {};

  List<TagsSection> _tagsSections = [];

  List<Tag> get selectedTags => _selectedTags.values.toList();

  List<TagsSection> get tagsSections => _tagsSections;

  bool isSelected(Tag tag) => _selectedTags.containsKey(tag.id);

  void toggleSelectedTag(Tag tag) {
    if (!isSelected(tag)) {
      if (!_selectedTagsByType.containsKey(tag.type)) _selectedTagsByType[tag.type] = [];

      _selectedTags[tag.id] = tag;
      _selectedTagsByType[tag.type]!.add(tag);
    } else {
      _selectedTags.remove(tag.id);
      _selectedTagsByType[tag.type]!.remove(tag);
    }

    notifyListeners();
  }

  void clearTags() {
    _selectedTags.clear();
    _selectedTagsByType.clear();

    notifyListeners();
  }

  void _updateTags(List<Tag> tags) {
    final Map<TagType, List<Tag>> tagsMap = {};

    for (final tag in tags) {
      if (!tag.type.supported) continue;

      final type = tag.type;

      if (tagsMap[type] == null) tagsMap[type] = List<Tag>.empty(growable: true);

      tagsMap[type]?.add(tag);
    }

    _tagsSections = tagsMap.entries.map((entry) => TagsSection(entry.key.description, entry.value)).toList();

    _tagsSections.sort((first, second) => first.tags[0].type.rawValue.compareTo(second.tags[0].type.rawValue));
  }

  List<SongLyric> _filter(List<SongLyric> songLyrics) {
    if (selectedTags.isEmpty) return songLyrics;

    final List<SongLyric> filtered = [];

    for (final songLyric in songLyrics) {
      bool shouldAdd = true;

      for (final entry in _selectedTagsByType.entries) {
        if (entry.value.isEmpty) continue;

        if (entry.key == TagType.language) {
          shouldAdd &= entry.value.any((tag) => tag.name == songLyric.langDescription);
        } else if (entry.key == TagType.songbook) {
          shouldAdd &= entry.value.any((tag) =>
              songLyric.songbookRecords.any((songbookRecord) => songbookRecord.songbook.target?.name == tag.name));
        } else {
          shouldAdd &= entry.value.any((tag) => songLyric.tags.contains(tag));
        }

        if (!shouldAdd) break;
      }

      if (shouldAdd) filtered.add(songLyric);
    }

    return filtered;
  }
}

mixin _RecentlySearched on SongLyricsProvider {
  late List<SongLyric> _recentSongLyrics = [];

  void _updateRecentlySearched(SharedPreferences prefs) {
    final songLyrics = prefs
        .getStringList(_recentSongLyricsKey)
        ?.map((songLyricId) => _songLyricsMap[int.parse(songLyricId)])
        .where((songLyric) => songLyric != null)
        .toList()
        .cast<SongLyric>();

    _recentSongLyrics = songLyrics ?? [];
  }

  void addRecentSongLyric(SongLyric songLyric) {
    _recentSongLyrics.remove(songLyric);
    _recentSongLyrics.insert(0, songLyric);

    if (_recentSongLyrics.length > _maxRecentSongLyrics) _recentSongLyrics.removeLast();

    SharedPreferences.getInstance().then((prefs) {
      List<int> recentSongLyricsIds =
          prefs.getStringList(_recentSongLyricsKey)?.map((id) => int.parse(id)).toList() ?? [];

      recentSongLyricsIds.remove(songLyric.id);
      recentSongLyricsIds.insert(0, songLyric.id);

      if (recentSongLyricsIds.length > _maxRecentSongLyrics) recentSongLyricsIds.removeLast();

      prefs.setStringList(_recentSongLyricsKey, recentSongLyricsIds.map((id) => '$id').toList());
    });

    Future.delayed(const Duration(milliseconds: 500), () => notifyListeners());
  }
}

mixin _Searchable on SongLyricsProvider {
  String _searchText = '';

  SongLyric? _matchedById;

  List<SongLyric>? _searchResults;

  final List<SongLyric> _songLyricsMatchedBySongbookNumber = [];

  String get searchText => _searchText;

  SongLyric? get matchedById => _matchedById;

  void search(String searchText, {Songbook? songbook}) async {
    _searchText = searchText;

    _matchedById = null;
    _songLyricsMatchedBySongbookNumber.clear();

    if (searchText.isEmpty) {
      _searchResults = null;

      notifyListeners();

      return;
    }

    final songLyricsSearch = SongLyricsSearch();
    await songLyricsSearch.init();

    final result = await songLyricsSearch.search(searchText);

    final Map<int, double> ranks = {};
    final List<SongLyric> searchResults = [];

    for (final value in result) {
      final songLyric = _songLyricsMap[value['id']];

      if (songLyric != null) {
        if ((songbook == null && searchText == '${songLyric.id}') ||
            songLyric.songbookRecords.any((songbookRecord) =>
                songbookRecord.songbook.targetId == songbook?.id && searchText == songbookRecord.number)) {
          _matchedById = songLyric;
        } else if (songLyric.songbookRecords.any((songbookRecord) => searchText == songbookRecord.number)) {
          _songLyricsMatchedBySongbookNumber.add(songLyric);
        } else {
          searchResults.add(songLyric);
        }

        // weights: [id, name, secondary_name_1, secondary_name_2, lyrics, numbers_with_shortcut, numbers]
        ranks[value['id']] = bm25(value['info'], weights: [50.0, 40.0, 35.0, 30.0, 1.0, 48.0, 45.0]);
      }
    }

    _searchResults = searchResults;
    _searchResults?.sort((a, b) => ranks[a.id]!.compareTo(ranks[b.id]!));

    songLyricsSearch.close();

    notifyListeners();
  }
}

abstract class SongLyricsProvider extends ChangeNotifier {
  late List<SongLyric> _songLyrics;
  late Map<int, SongLyric> _songLyricsMap;

  List<SongLyric> get songLyrics => _songLyrics;

  void _updateSongLyrics(List<SongLyric> songLyrics) {
    _songLyrics = songLyrics;

    _songLyricsMap = Map.fromIterable(songLyrics, key: (songLyric) => songLyric.id);
  }
}

class AllSongLyricsProvider extends SongLyricsProvider with _Filterable, _RecentlySearched, _Searchable {
  AllSongLyricsProvider(DataProvider dataProvider, {List<SongLyric>? songLyrics, Tag? initialTag}) {
    _updateSongLyrics(songLyrics ?? dataProvider.songLyrics);

    _updateRecentlySearched(dataProvider.prefs);

    _updateTags(dataProvider.tags);

    if (initialTag != null) toggleSelectedTag(initialTag);
  }

  @override
  SongLyric? get matchedById {
    if (super.matchedById == null) return null;

    final filtered = _filter([super.matchedById!]);

    return filtered.isEmpty ? null : filtered.first;
  }

  List<SongLyric> get recentSongLyrics => _searchText.isEmpty && _selectedTags.isEmpty ? _recentSongLyrics : [];

  @override
  List<SongLyric> get songLyrics => _filter(_searchResults ?? super.songLyrics);

  List<SongLyric> get songLyricsMatchedBySongbookNumber => _filter(_songLyricsMatchedBySongbookNumber);

  void update(DataProvider dataProvider, {List<SongLyric>? songLyrics}) {
    _updateSongLyrics(songLyrics ?? dataProvider.songLyrics);

    _updateTags(dataProvider.tags);

    notifyListeners();
  }
}

class PlaylistSongLyricsProvider extends SongLyricsProvider with _Searchable {
  final Playlist playlist;

  PlaylistSongLyricsProvider(DataProvider dataProvider, this.playlist) {
    _updateSongLyrics(dataProvider.getPlaylistsSongLyrics(playlist));
  }

  @override
  List<SongLyric> get songLyrics => _searchResults ?? super.songLyrics;

  void update(DataProvider dataProvider) {
    _updateSongLyrics(dataProvider.getPlaylistsSongLyrics(playlist));

    notifyListeners();
  }

  void onReorder(BuildContext context, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final playlistRecord = playlist.playlistRecords.removeAt(oldIndex);
    playlist.playlistRecords.insert(newIndex, playlistRecord);

    final songLyric = _songLyrics.removeAt(oldIndex);
    _songLyrics.insert(newIndex, songLyric);

    for (int i = 0; i < playlist.playlistRecords.length; i++) {
      playlist.playlistRecords[i].rank = i;
    }

    context.read<DataProvider>().store.box<PlaylistRecord>().putMany(playlist.playlistRecords);

    notifyListeners();
  }

  void removeSongLyric(SongLyric songLyric) {
    playlist.removeSongLyric(songLyric);

    _songLyrics.remove(songLyric);
    _songLyricsMap.remove(songLyric.id);

    notifyListeners();
  }
}

class SongbookSongLyricsProvider extends SongLyricsProvider with _Searchable {
  final Songbook songbook;

  SongbookSongLyricsProvider(DataProvider dataProvider, this.songbook) {
    _updateSongLyrics(dataProvider.getSongbooksSongLyrics(songbook));
  }

  @override
  List<SongLyric> get songLyrics => _searchResults ?? super.songLyrics;

  void update(DataProvider dataProvider) {
    _updateSongLyrics(dataProvider.getSongbooksSongLyrics(songbook));

    notifyListeners();
  }
}

class UpdatedSongLyricsProvider extends SongLyricsProvider {
  UpdatedSongLyricsProvider(DataProvider dataProvider) {
    _updateSongLyrics(dataProvider.updatedSongLyrics);
  }
}
