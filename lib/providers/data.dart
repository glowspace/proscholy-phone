import 'dart:async';
import 'dart:io';

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

  // using negative ids to distinguish from other tags
  int _tagId = -1;

  List<NewsItem> _newsItems = [];
  List<SongLyric> _songLyrics = [];
  List<Songbook> _songbooks = [];
  List<Tag> _tags = [];
  List<Playlist> _playlists = [];

  List<SongLyric> _updatedSongLyrics = [];

  late Playlist _favorites;

  Map<int, SongLyric> _songLyricsById = {};
  Map<int, Songbook> _songbooksById = {};
  final Map<String, Tag> _tagsBySongbookName = {};

  List<NewsItem> get newsItems => _newsItems;
  List<SongLyric> get songLyrics => _songLyrics;
  List<Songbook> get songbooks => _songbooks;
  List<Tag> get tags => _tags;
  List<Playlist> get playlists => _playlists;

  List<SongLyric> get updatedSongLyrics => _updatedSongLyrics;

  Playlist get favorites => _favorites;

  SongLyric? getSongLyricById(int id) => _songLyricsById[id];
  Songbook? getSongbookById(int id) => _songbooksById[id];
  Tag? getTagBySongbookName(String name) => _tagsBySongbookName[name];

  List<SongLyric> getPlaylistsSongLyrics(Playlist playlist) {
    final songLyrics = (playlist.playlistRecords..sort())
        .map((playlistRecord) => getSongLyricById(playlistRecord.songLyric.targetId))
        .where((songLyric) => songLyric != null)
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

    updater = Updater(store, prefs);
    songLyricsSearch = SongLyricsSearch();

    await songLyricsSearch.open();

    await _load();

    if (Platform.isIOS) _indexSpotlight();
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
    _tags.add(Tag(_tagId--, playlist.name, TagType.playlist.rawValue));

    store.box<Playlist>().put(playlist);
    _playlists.add(playlist);

    notifyListeners();

    return playlist;
  }

  Playlist duplicatePlaylist(Playlist playlist, String name) {
    final duplicatedPlaylist = Playlist(name, Playlist.nextRank(store));
    _tags.add(Tag(_tagId--, duplicatedPlaylist.name, TagType.playlist.rawValue));

    duplicatedPlaylist.playlistRecords.addAll(
        playlist.playlistRecords.map((playlistRecord) => playlistRecord.copyWith(playlist: duplicatedPlaylist)));

    store.box<Playlist>().put(duplicatedPlaylist);
    _playlists.add(duplicatedPlaylist);

    notifyListeners();

    return duplicatedPlaylist;
  }

  void renamePlaylist(Playlist playlist, String name) {
    final index = _tags.indexWhere((tag) => tag.type == TagType.playlist && tag.name == playlist.name);

    playlist.name = name;

    _tags[index] = Tag(_tags[index].id, playlist.name, TagType.playlist.rawValue);

    store.box<Playlist>().put(playlist);

    notifyListeners();
  }

  void addToPlaylist(SongLyric songLyric, Playlist playlist) {
    final rank = PlaylistRecord.nextRank(store, playlist);

    playlist.addSongLyric(songLyric, rank);

    notifyListeners();
  }

  void reorderedPlaylists(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final playlist = _playlists.removeAt(oldIndex);
    _playlists.insert(newIndex, playlist);

    for (int i = 0; i < _playlists.length; i++) {
      _playlists[i].rank = i;
    }

    _tags.removeWhere((tag) => tag.type == TagType.playlist && tag.name != _favorites.name);
    _tags.addAll(_playlists.map((playlist) => Tag(_tagId--, playlist.name, TagType.playlist.rawValue)));

    store.box<Playlist>().putMany(_playlists);

    notifyListeners();
  }

  void removePlaylist(Playlist playlist) {
    store.box<Playlist>().remove(playlist.id);
    _playlists.remove(playlist);

    _tags.removeWhere((tag) => tag.type == TagType.playlist && tag.name == playlist.name);

    notifyListeners();
  }

  void togglePin(Songbook songbook) {
    songbook.isPinned = !songbook.isPinned;

    store.box<Songbook>().put(songbook);

    _songbooks.sort();

    _tags.removeWhere((tag) => tag.type == TagType.songbook);
    _tags.addAll(_songbooks.map((songbook) => Tag(_tagId--, songbook.name, TagType.songbook.rawValue)));

    notifyListeners();
  }

  Stream<List<SongLyric>> watchPlaylistRecordsChanges(Playlist playlist) {
    final query = store.box<PlaylistRecord>().query(PlaylistRecord_.playlist.equals(playlist.id));

    return query.watch().map((_) => getPlaylistsSongLyrics(playlist));
  }

  Future<int> update() async {
    final songLyrics = await updater.update(this);

    _updatedSongLyrics = songLyrics.where((songLyric) => songLyric.hasLyrics || songLyric.lilypond != null).toList();

    await _load();

    return _updatedSongLyrics.length;
  }

  Future<void> _load() async {
    final currentVersion = prefs.getString(_versionKey);
    final buildVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

    await songLyricsSearch.init(currentVersion != buildVersion);

    if (currentVersion != buildVersion) {
      await updater.loadInitial();

      store.box<Playlist>().put(Playlist.favorite());

      prefs.setString(_versionKey, buildVersion);

      try {
        await _migrateOldDB();
        // ignore: empty_catches
      } catch (e) {}
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

    _tags.addAll(songbooks.map((songbook) {
      final tag = Tag(_tagId--, songbook.name, TagType.songbook.rawValue);

      _tagsBySongbookName[songbook.name] = tag;

      return tag;
    }));
    _tags.add(Tag(_tagId--, _favorites.name, TagType.playlist.rawValue));
    _tags.addAll(playlists.map((playlist) => Tag(_tagId--, playlist.name, TagType.playlist.rawValue)));

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

    for (final language in languages.keys) {
      final tag = Tag(_tagId--, language, TagType.language.rawValue);

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

    // it was possible to have multiple playlists with the same name, so counter is used to make sure that names are unique
    final Map<String, int> playlistsByNameCounter = {};

    for (final oldPlaylist in oldPlaylists) {
      String name = oldPlaylist['name'] as String;

      if (playlistsByNameCounter.containsKey(name)) {
        name = '$name (${playlistsByNameCounter[name]})';
      }

      playlistsByNameCounter[name] ??= 0;
      playlistsByNameCounter[name] = playlistsByNameCounter[name]! + 1;

      final playlist = Playlist(name, oldPlaylist['rank'] as int);

      playlists.add(playlist);
    }

    store.box<Playlist>().putMany(playlists);

    final Map<int, int> playlistsIdMapping = {};
    for (var i = 0; i < playlists.length; i++) {
      playlistsIdMapping[oldPlaylists[i]['id'] as int] = playlists[i].id;
    }

    final List<PlaylistRecord> playlistRecords = [];

    final existingFavorites = store
        .box<PlaylistRecord>()
        .query(PlaylistRecord_.playlist.equals(1))
        .build()
        .find()
        .map((playlistRecord) => playlistRecord.songLyric.targetId)
        .toList();

    for (final oldFavorite in oldFavorites) {
      final songLyricId = oldFavorite['id'] as int;

      if (existingFavorites.contains(songLyricId)) continue;

      final playlistRecord = PlaylistRecord(oldFavorite['favorite_rank'] as int)
        ..songLyric.targetId = songLyricId
        ..playlist.targetId = 1;

      playlistRecords.add(playlistRecord);
    }

    // there was some bug in the old database where the playlist records were stored multiple times, this will keep track of inserted playlist records to avoid duplicates
    final Map<int, Set<int>> insertedPlaylistRecords = {};

    for (final oldPlaylistRecord in oldPlaylistRecords) {
      final playlistId = playlistsIdMapping[oldPlaylistRecord['playlistsId'] as int];
      final songLyricId = oldPlaylistRecord['song_lyricsId'] as int;

      if (playlistId == null || playlistId == 0) continue;

      if (insertedPlaylistRecords[playlistId]?.contains(songLyricId) ?? false) continue;

      final playlistRecord = PlaylistRecord(oldPlaylistRecord['rank'] as int)
        ..songLyric.targetId = songLyricId
        ..playlist.targetId = playlistId;

      playlistRecords.add(playlistRecord);

      insertedPlaylistRecords[playlistId] ??= {};
      insertedPlaylistRecords[playlistId]!.add(songLyricId);
    }

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
