import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
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

  Playlist get favorites => _favorites;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();

    store = await openStore();

    updater = Updater(store);

    songLyricsSearch = SongLyricsSearch();

    await songLyricsSearch.init();

    await _load();

    updater.update().then((_) => _load());
  }

  void toggleFavorite(SongLyric songLyric) {
    if (songLyric.isFavorite) {
      _favorites.removeSongLyric(songLyric);
    } else {
      final rank = PlaylistRecord.nextRank(store, _favorites);

      _favorites.addSongLyric(songLyric, rank);
    }
  }

  Playlist createPlaylist(String name) {
    final playlist = Playlist(name, Playlist.nextRank(store));

    store.box<Playlist>().put(playlist);
    _playlists.add(playlist);

    notifyListeners();

    return playlist;
  }

  Playlist duplicatePlaylist(Playlist playlist, String name) {
    final duplicatedPlaylist = Playlist(name, Playlist.nextRank(store));

    duplicatedPlaylist.playlistRecords.addAll(
        playlist.playlistRecords.map((playlistRecord) => playlistRecord.copyWith(playlist: duplicatedPlaylist)));

    store.box<Playlist>().put(duplicatedPlaylist);
    _playlists.add(duplicatedPlaylist);

    notifyListeners();

    return duplicatedPlaylist;
  }

  void renamePlaylist(Playlist playlist, String name) {
    playlist.name = name;

    store.box<Playlist>().put(playlist);

    notifyListeners();
  }

  void addToPlaylist(SongLyric songLyric, Playlist playlist) {
    final rank = PlaylistRecord.nextRank(store, playlist);

    playlist.addSongLyric(songLyric, rank);
  }

  void reorderedPlaylists() {
    _playlists.sort();

    store.box<Playlist>().putMany(_playlists);

    notifyListeners();
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

    // TODO: do this only for updated songlyrics
    await songLyricsSearch.update(_songLyrics);

    _addLanguagesToTags();

    if (currentVersion == null) {
      try {
        await _migrateOldDB();
        // ignore: empty_catches
      } catch (e) {}
    }
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

  Future<void> _migrateOldDB() async {
    final db = await openDatabase(join(await getDatabasesPath(), 'zpevnik_proscholy.db'));

    final oldFavorites =
        await db.query('song_lyrics', columns: ['id', 'favorite_rank'], where: 'favorite_rank IS NOT NULL');
    final oldPlaylists = await db.query('playlists', columns: ['id', 'name', 'rank', 'is_archived'], orderBy: 'rank');
    final oldPlaylistRecords =
        await db.query('playlist_records', columns: ['rank', 'playlistsId', 'song_lyricsId'], orderBy: 'rank');

    final List<Playlist> playlists = [];
    final List<PlaylistRecord> playlistRecords = [];

    for (final oldFavorite in oldFavorites) {
      final playlistRecord = PlaylistRecord(oldFavorite['favorite_rank'] as int)
        ..songLyric.targetId = oldFavorite['id'] as int
        ..playlist.target = _favorites;

      playlistRecords.add(playlistRecord);
    }

    for (final oldPlaylist in oldPlaylists) {
      final playlist = Playlist(oldPlaylist['name'] as String, oldPlaylist['rank'] as int)
        ..id = (oldPlaylist['id'] as int) + 1
        ..isArchived = oldPlaylist['is_archived'] as int == 1;

      playlists.add(playlist);
    }

    for (final oldPlaylistRecord in oldPlaylistRecords) {
      final playlistRecord = PlaylistRecord(oldPlaylistRecord['rank'] as int)
        ..songLyric.targetId = oldPlaylistRecord['song_lyricsId'] as int
        ..playlist.targetId = (oldPlaylistRecord['playlistsId'] as int) + 1;

      playlistRecords.add(playlistRecord);
    }

    store.box<Playlist>().putMany(playlists);
    store.box<PlaylistRecord>().putMany(playlistRecords);

    _playlists.addAll(playlists);
  }

  @override
  void dispose() {
    super.dispose();

    store.close();
  }
}
