import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/playlist_record.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/song_lyrics_search.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/utils/updater.dart';

const _versionKey = 'current_version';

class DataProvider extends ChangeNotifier {
  late final SharedPreferences prefs;
  late final PackageInfo packageInfo;

  late final Store store;

  late final Updater updater;
  late final SongLyricsSearch songLyricsSearch;

  List<NewsItem> _newsItems = [];
  List<SongLyric> _songLyrics = [];
  List<Tag> _tags = [];
  List<Playlist> _playlists = [];

  late Playlist _favorites;

  List<NewsItem> get newsItems => _newsItems;
  List<SongLyric> get songLyrics => _songLyrics;
  List<Tag> get tags => _tags;
  List<Playlist> get playlists => _playlists;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();

    store = await openStore();

    updater = Updater(store);

    songLyricsSearch = SongLyricsSearch();

    await songLyricsSearch.init();

    await _load();
  }

  void toggleFavorite(SongLyric songLyric) {
    if (songLyric.isFavorite) {
      _favorites.removeSongLyric(songLyric);
    } else {
      final rank = PlaylistRecord.nextRank(store, _favorites);

      _favorites.addSongLyric(songLyric, rank);
    }
  }

  Future<void> _load() async {
    final currentVersion = prefs.getString(_versionKey);
    final buildVersion = packageInfo.version;

    if (currentVersion != buildVersion) {
      await updater.loadInitial();

      store.box<Playlist>().put(Playlist.favorite());

      prefs.setString(_versionKey, buildVersion);
    }

    await Future.wait([
      store.runInTransactionAsync(TxMode.read, NewsItem.load, null).then((newsItems) => _newsItems = newsItems),
      store.runInTransactionAsync(TxMode.read, Tag.load, null).then((tags) => _tags = tags),
    ]);

    // TODO: find out how to load this asynchronously
    // once https://github.com/objectbox/objectbox-dart/issues/340 is fixed it can be run with runInTransactionAsync

    _songLyrics = SongLyric.load(store);

    _playlists = Playlist.load(store);
    _favorites = Playlist.loadFavorites(store);

    _playlists.insert(0, _favorites);

    // TODO: do this only for updated songlyrics
    await songLyricsSearch.update(_songLyrics);

    _addLanguagesToTags();
  }

  void _addLanguagesToTags() {
    final Map<String, int> languages = {};

    for (final songLyric in songLyrics) {
      if (songLyric.lang == null) continue;

      if (!languages.containsKey(songLyric.langDescription)) languages[songLyric.langDescription!] = 0;

      languages[songLyric.langDescription!] = languages[songLyric.langDescription!]! + 1;
    }

    final List<Tag> languageTags = [];

    // using negative ids to distinguish from other tags
    int id = -1;
    for (final language in languages.keys) {
      final tag = Tag(id--, language, TagType.language.rawValue);

      languageTags.add(tag);
    }

    languageTags.sort((first, second) => languages[second.name]!.compareTo(languages[first.name]!));

    _tags.addAll(languageTags);
  }

  @override
  void dispose() {
    super.dispose();

    store.close();
  }
}
