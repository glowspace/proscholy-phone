import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_core_spotlight/flutter_core_spotlight.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/utils/song_lyrics_search.dart';
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
  final int _tagId = -1;

  final List<NewsItem> _newsItems = [];
  List<SongLyric> _songLyrics = [];
  final List<Tag> _tags = [];

  List<SongLyric> _updatedSongLyrics = [];

  Map<int, SongLyric> _songLyricsById = {};
  final Map<int, Songbook> _songbooksById = {};
  final Map<String, Tag> _tagsBySongbookName = {};

  List<NewsItem> get newsItems => _newsItems;
  List<SongLyric> get songLyrics => _songLyrics;
  List<Tag> get tags => _tags;

  List<SongLyric> get updatedSongLyrics => _updatedSongLyrics;

  SongLyric? getSongLyricById(int id) => _songLyricsById[id];
  Songbook? getSongbookById(int id) => _songbooksById[id];
  Tag? getTagBySongbookName(String name) => _tagsBySongbookName[name];

  // List<SongLyric> getPlaylistsSongLyrics(Playlist playlist) {
  //   final songLyrics = (playlist.playlistRecords..sort())
  //       .map((playlistRecord) => getSongLyricById(playlistRecord.songLyric.targetId))
  //       .where((songLyric) => songLyric != null)
  //       .toList()
  //       .cast<SongLyric>();

  //   return songLyrics;
  // }

  // List<SongLyric> getSongbooksSongLyrics(Songbook songbook) {
  //   final songLyrics = (songbook.songbookRecords..sort())
  //       .map((songbookRecord) => getSongLyricById(songbookRecord.songLyric.targetId))
  //       .where((songLyric) => songLyric != null)
  //       .toList()
  //       .cast<SongLyric>();

  //   return songLyrics;
  // }

  Future<void> init(Store store) async {
    prefs = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();

    this.store = store;

    updater = Updater(store, prefs);
    songLyricsSearch = SongLyricsSearch();

    await songLyricsSearch.open();

    await _load();

    if (Platform.isIOS) _indexSpotlight();
  }

  void toggleFavorite(SongLyric songLyric) {
    if (songLyric.isFavorite) {
      // _favorites.removeSongLyric(songLyric);
    } else {
      // final rank = PlaylistRecord.nextRank(store, _favorites);

      // _favorites.addSongLyric(songLyric, rank);
    }

    notifyListeners();
  }

  void reorderedPlaylists(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // final playlist = _playlists.removeAt(oldIndex);
    // _playlists.insert(newIndex, playlist);

    // for (int i = 0; i < _playlists.length; i++) {
    //   // _playlists[i].rank = i;
    // }

    // _tags.removeWhere((tag) => tag.type == TagType.playlist && tag.name != _favorites.name);
    // _tags.addAll(_playlists.map((playlist) => Tag(_tagId--, playlist.name, TagType.playlist.rawValue)));

    // store.box<Playlist>().putMany(_playlists);

    notifyListeners();
  }

  // Stream<List<SongLyric>> watchPlaylistRecordsChanges(Playlist playlist) {
  //   final query = store.box<PlaylistRecord>().query(PlaylistRecord_.playlist.equals(playlist.id));

  //   return query.watch().map((_) => getPlaylistsSongLyrics(playlist));
  // }

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

      // store.box<Playlist>().put(Playlist.favorite());

      prefs.setString(_versionKey, buildVersion);
    }

    await Future.wait([
      // store.runInTransactionAsync(TxMode.read, NewsItem.load, null).then((newsItems) => _newsItems = newsItems),
      // store.runInTransactionAsync(TxMode.read, Tag.load, null).then((tags) => _tags = tags),
    ]);

    // TODO: find out how to load this asynchronously
    // UPDATE: the issue is resolved now
    // once https://github.com/objectbox/objectbox-dart/issues/340 is fixed it can be run with runInTransactionAsync

    // _songLyrics = SongLyric.load(store);
    _songLyrics = store.box<SongLyric>().getAll();

    // TODO: do this only for updated songlyrics
    await songLyricsSearch.update(_songLyrics);

    _songLyricsById = Map.fromIterable(_songLyrics, key: (songLyric) => songLyric.id);

    _addLanguagesToTags();

    // _tags.addAll(songbooks.map((songbook) {
    //   final tag = Tag(_tagId--, songbook.name, TagType.songbook.rawValue);

    //   _tagsBySongbookName[songbook.name] = tag;

    //   return tag;
    // }));
    // _tags.add(Tag(_tagId--, _favorites.name, TagType.playlist.rawValue));
    // _tags.addAll(playlists.map((playlist) => Tag(_tagId--, playlist.name, TagType.playlist.rawValue)));

    notifyListeners();

    // print(store.box<SongLyric>().get(149));
    // print(store.box<SongLyric>().get(149)?.externals);
    // print(store.box<SongLyric>().get(149)?.authors);
    // print(store.box<SongLyric>().get(149)?.tags);
    // print(store.box<Author>().count());
    // print(store.box<Tag>().count());
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
      // final tag = Tag(_tagId--, language, TagType.language.rawValue);

      // languageTags.add(tag);
    }

    languageTags.sort((first, second) => languages[second.name]!.compareTo(languages[first.name]!));

    _tags.addAll(languageTags);
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
