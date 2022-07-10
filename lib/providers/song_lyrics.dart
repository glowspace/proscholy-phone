import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/custom/sqlite-bm25/bm25.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/models/song_lyric.dart';
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

    _tagsSections.sort((first, second) => first.tags[0].type.index.compareTo(second.tags[0].type.index));
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

  void _updateRecentlySearched() {
    final songLyrics = dataProvider.prefs
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

    final recentSongLyricsIds = _recentSongLyrics.map((songLyric) => '${songLyric.id}').toList();
    dataProvider.prefs.setStringList(_recentSongLyricsKey, recentSongLyricsIds);

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

  void search(String searchText) async {
    _searchText = searchText;

    _matchedById = null;
    _songLyricsMatchedBySongbookNumber.clear();

    if (searchText.isEmpty) {
      _searchResults = null;

      notifyListeners();

      return;
    }

    final result = await dataProvider.songLyricsSearch.search(searchText);

    final Map<int, double> ranks = {};
    final List<SongLyric> searchResults = [];

    for (final value in result) {
      final songLyric = _songLyricsMap[value['id']];

      if (songLyric != null) {
        if (searchText == '${songLyric.id}') {
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

    notifyListeners();
  }
}

abstract class SongLyricsProvider extends ChangeNotifier {
  // TODO: should not store DataProvider, should use ChangeNotifierProxyProvider to get udpated data
  final DataProvider dataProvider;

  SongLyricsProvider(this.dataProvider) {
    dataProvider.addListener(_update);
  }

  late List<SongLyric> _songLyrics;
  late Map<int, SongLyric> _songLyricsMap;

  List<SongLyric> get songLyrics => _songLyrics;

  void _updateSongLyrics(List<SongLyric> songLyrics) {
    _songLyrics = songLyrics;

    _songLyricsMap = Map.fromIterable(songLyrics, key: (songLyric) => songLyric.id);
  }

  void _update() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();

    dataProvider.removeListener(_update);
  }
}

class AllSongLyricsProvider extends SongLyricsProvider with _Filterable, _RecentlySearched, _Searchable {
  AllSongLyricsProvider(DataProvider dataProvider, List<SongLyric> songLyrics, {Tag? initialTag})
      : super(dataProvider) {
    _updateSongLyrics(songLyrics);

    _updateRecentlySearched();

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

  @override
  void _update() {
    _updateSongLyrics(dataProvider.songLyrics);

    _updateRecentlySearched();

    _updateTags(dataProvider.tags);

    super._update();
  }
}

class PlaylistSongLyricsProvider extends SongLyricsProvider with _Searchable {
  final Playlist playlist;

  PlaylistSongLyricsProvider(DataProvider dataProvider, this.playlist) : super(dataProvider) {
    final songLyrics = (playlist.playlistRecords..sort())
        .map((playlistRecord) => dataProvider.getSongLyricById(playlistRecord.songLyric.targetId))
        .toList()
        .cast<SongLyric>();
    _updateSongLyrics(songLyrics);
  }

  @override
  List<SongLyric> get songLyrics => _searchResults ?? super.songLyrics;

  @override
  void _update() {
    final songLyrics = (playlist.playlistRecords..sort())
        .map((playlistRecord) => dataProvider.getSongLyricById(playlistRecord.songLyric.targetId))
        .toList()
        .cast<SongLyric>();
    _updateSongLyrics(songLyrics);

    super._update();
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

    _update();
  }
}

class SongbookSongLyricsProvider extends SongLyricsProvider with _Searchable {
  final Songbook songbook;

  SongbookSongLyricsProvider(DataProvider dataProvider, this.songbook) : super(dataProvider) {
    final songLyrics = (songbook.songbookRecords..sort())
        .map((songbookRecord) => dataProvider.getSongLyricById(songbookRecord.songLyric.targetId))
        .where((songLyric) => songLyric != null)
        .toList()
        .cast<SongLyric>();
    _updateSongLyrics(songLyrics);
  }

  @override
  List<SongLyric> get songLyrics => _searchResults ?? super.songLyrics;

  @override
  void _update() {
    final songLyrics = (songbook.songbookRecords..sort())
        .map((songbookRecord) => dataProvider.getSongLyricById(songbookRecord.songLyric.targetId))
        .where((songLyric) => songLyric != null)
        .toList()
        .cast<SongLyric>();
    _updateSongLyrics(songLyrics);

    super._update();
  }
}

class UpdatedSongLyricsProvider extends SongLyricsProvider {
  UpdatedSongLyricsProvider(DataProvider dataProvider) : super(dataProvider) {
    _updateSongLyrics(dataProvider.updatedSongLyrics);

    super._update();
  }
}
