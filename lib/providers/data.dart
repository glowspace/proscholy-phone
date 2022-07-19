import 'package:flutter/material.dart';
import 'package:flutter_core_spotlight/flutter_core_spotlight.dart';
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
import 'package:zpevnik/models/songbook.dart';
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
  List<Songbook> _songbooks = [];
  List<Tag> _tags = [];
  List<Playlist> _playlists = [];

  List<SongLyric> _updatedSongLyrics = [];

  late Playlist _favorites;

  Map<int, SongLyric> _songLyricsById = {};
  Map<int, Songbook> _songbooksById = {};

  List<NewsItem> get newsItems => _newsItems;
  List<SongLyric> get songLyrics => _songLyrics;
  List<Songbook> get songbooks => _songbooks;
  List<Tag> get tags => _tags;
  List<Playlist> get playlists => _playlists;

  List<SongLyric> get updatedSongLyrics => _updatedSongLyrics;

  Playlist get favorites => _favorites;

  SongLyric? getSongLyricById(int id) => _songLyricsById[id];
  Songbook? getSongbookById(int id) => _songbooksById[id];

  List<SongLyric> getPlaylistsSongLyrics(Playlist playlist) {
    final songLyrics = (playlist.playlistRecords..sort())
        .map((playlistRecord) => getSongLyricById(playlistRecord.songLyric.targetId))
        .toList()
        .cast<SongLyric>();

    return songLyrics;
  }

  List<SongLyric> getSongbooksSongLyrics(Songbook songbook) {
    final songLyrics = (songbook.songbookRecords..sort())
        .map((songbookRecord) => getSongLyricById(songbookRecord.songLyric.targetId))
        .where((songLyric) => songLyric != null)
        .toList()
        .cast<SongLyric>();

    return songLyrics;
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();

    store = await openStore();

    updater = Updater(store);

    songLyricsSearch = SongLyricsSearch();

    await songLyricsSearch.init();

    await _load();

    updater.update(this).then((songLyrics) {
      _updatedSongLyrics = songLyrics;

      _load();
    });

    _indexSpotlight();
  }

  void toggleFavorite(SongLyric songLyric) {
    if (songLyric.isFavorite) {
      _favorites.removeSongLyric(songLyric);
    } else {
      final rank = PlaylistRecord.nextRank(store, _favorites);

      _favorites.addSongLyric(songLyric, rank);
    }

    notifyListeners();
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

    notifyListeners();
  }

  void reorderedPlaylists() {
    _playlists.sort();

    store.box<Playlist>().putMany(_playlists);

    notifyListeners();
  }

  void removePlaylist(Playlist playlist) {
    store.box<Playlist>().remove(playlist.id);
    _playlists.remove(playlist);

    notifyListeners();
  }

  Future<void> _load() async {
    final currentVersion = prefs.getString(_versionKey);
    final buildVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

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
    _songbooks = Songbook.load(store)..sort();

    _playlists = Playlist.load(store);
    _favorites = Playlist.loadFavorites(store);

    // TODO: do this only for updated songlyrics
    await songLyricsSearch.update(_songLyrics);

    _songLyricsById = Map.fromIterable(_songLyrics, key: (songLyric) => songLyric.id);
    _songbooksById = Map.fromIterable(_songbooks, key: (songbook) => songbook.id);

    _addLanguagesToTags();

    // FIXME: should depend on last id in language tags
    int id = -100;
    _tags.addAll(songbooks.map((songbook) => Tag(id--, songbook.name, TagType.songbook.rawValue)));

    if (currentVersion == null) {
      try {
        await _migrateOldDB();
        // ignore: empty_catches
      } catch (e) {}
    }

    notifyListeners();
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
        ..id = (oldPlaylist['id'] as int) + 1;

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

  void _indexSpotlight() {
    // TODO: index only updates, remove old song lyrics
    FlutterCoreSpotlight.instance.indexSearchableItems(_songLyrics
        .map((songLyric) => FlutterSpotlightItem(
              uniqueIdentifier: 'song_lyric_${songLyric.id}',
              domainIdentifier: 'cz.proscholy.id.zpevnik',
              attributeTitle: songLyric.name,
              attributeDescription: songLyric.lyrics?.replaceAll(RegExp(r'\[[^\]]+\]'), '') ?? '',
            ))
        .toList());
  }

  @override
  void dispose() {
    super.dispose();

    store.close();
  }
}
