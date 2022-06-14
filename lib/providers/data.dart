import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/song_lyrics_search.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/utils/updater.dart';

const _recentSongLyricsKey = 'recent_song_lyrics';
const _maxRecentSongLyrics = 5;

class DataProvider extends ChangeNotifier {
  late final SharedPreferences prefs;

  late final Store store;

  late final Updater updater;
  late final SongLyricsSearch songLyricsSearch;

  List<NewsItem> _newsItems = [];
  List<SongLyric> _songLyrics = [];
  List<Tag> _tags = [];

  Map<int, SongLyric> _songLyricsMap = {};

  List<NewsItem> get newsItems => _newsItems;
  List<SongLyric> get songLyrics => _songLyrics;
  List<Tag> get tags => _tags;

  List<SongLyric>? get recentSongLyrics => prefs
      .getStringList(_recentSongLyricsKey)
      ?.map((songLyricId) => getSongLyric(int.parse(songLyricId)))
      .where((songLyric) => songLyric != null)
      .toList()
      .cast();

  SongLyric? getSongLyric(int id) => _songLyricsMap[id];

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    store = await openStore();

    updater = Updater(store);

    // only on first run
    updater.loadInitial().then((_) => _load());

    songLyricsSearch = SongLyricsSearch();

    await songLyricsSearch.init();
  }

  void addRecentSongLyric(SongLyric songLyric) {
    final recentSongLyricsIds = prefs.getStringList(_recentSongLyricsKey) ?? [];

    recentSongLyricsIds.remove('${songLyric.id}');
    recentSongLyricsIds.insert(0, '${songLyric.id}');

    if (recentSongLyricsIds.length > _maxRecentSongLyrics) recentSongLyricsIds.removeLast();
    prefs.setStringList(_recentSongLyricsKey, recentSongLyricsIds);

    Future.delayed(const Duration(milliseconds: 500), () => notifyListeners());
  }

  Future<void> _load() async {
    await Future.wait([
      store.runInTransactionAsync(TxMode.read, NewsItem.load, null).then((newsItems) => _newsItems = newsItems),
      store.runInTransactionAsync(TxMode.read, Tag.load, null).then((tags) => _tags = tags),
    ]);

    // TODO: find out how to load this asynchronously
    // once https://github.com/objectbox/objectbox-dart/issues/340 is fixed it can be run with runInTransactionAsync
    _songLyrics = SongLyric.load(store);

    _songLyricsMap = {};
    for (final songLyric in _songLyrics) {
      _songLyricsMap[songLyric.id] = songLyric;
    }

    // TODO: do this only for updated songlyrics
    await songLyricsSearch.update(_songLyrics);

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();

    store.close();
  }
}
