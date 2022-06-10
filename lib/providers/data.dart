import 'package:flutter/material.dart';
import 'package:zpevnik/models/news_item.dart';
import 'package:zpevnik/models/objectbox.g.dart';

class DataProvider extends ChangeNotifier {
  late final Store store;

  Future<void> init() async {
    store = await openStore();
  }

  List<NewsItem> get newsItems => store
      .box<NewsItem>()
      .query(NewsItem_.expiresAt.greaterOrEqual(DateTime.now().millisecondsSinceEpoch))
      .build()
      .find();

  @override
  void dispose() {
    super.dispose();

    store.close();
  }
}


// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:zpevnik/models/author.dart';
// import 'package:zpevnik/models/external.dart';
// import 'package:zpevnik/models/model.dart' as model;
// import 'package:zpevnik/models/playlist.dart';
// import 'package:zpevnik/models/playlist_record.dart';
// import 'package:zpevnik/models/song_lyric.dart';
// import 'package:zpevnik/models/songbook.dart';
// import 'package:zpevnik/models/songbook_record.dart';
// import 'package:zpevnik/models/tag.dart';
// import 'package:zpevnik/providers/utils/updater.dart';
// import 'package:zpevnik/utils/exceptions.dart';

// class DataProvider extends ChangeNotifier {
//   final updater = Updater();

//   late Map<int, Playlist> _playlists;
//   late Map<int, SongLyric> _songLyrics;
//   late Map<int, Songbook> _songbooks;
//   late List<Tag> _tags;

//   late Map<int, List<SongLyric>> _songsSongLyrics;

//   List<Playlist> get playlists => _playlists.values.toList();
//   List<SongLyric> get songLyrics => _songLyrics.values.toList();
//   List<Songbook> get songbooks => _songbooks.values.toList();
//   List<Tag> get tags => _tags;

//   List<SongLyric> songbookSongLyrics(Songbook songbook) {
//     final songLyrics = List<SongLyric>.empty(growable: true);

//     for (final record in songbook.records) {
//       final songLyric = _songLyrics[record.songLyricId];

//       if (songLyric != null) songLyrics.add(songLyric);
//     }

//     return songLyrics;
//   }

//   List<SongLyric> playlistSongLyrics(Playlist playlist) {
//     final songLyrics = List<SongLyric>.empty(growable: true);

//     for (final playlistRecord in playlist.records.values) {
//       final songLyric = _songLyrics[playlistRecord.songLyricId];

//       if (songLyric != null) songLyrics.add(songLyric);
//     }

//     songLyrics.sort((first, second) => playlist.records[first.id]!.rank.compareTo(playlist.records[second.id]!.rank));

//     return songLyrics;
//   }

//   List<SongLyric>? songsSongLyrics(int songId) => _songsSongLyrics[songId];

//   SongLyric? songLyric(int songLyricId) => _songLyrics[songLyricId];

//   bool hasTranslations(SongLyric songLyric) => (_songsSongLyrics[songLyric.songId ?? -1]?.length ?? 1) > 1;

//   Future<bool> update({bool forceUpdate = false}) async {
//     bool updated;

//     try {
//       await updater.update(forceUpdate);

//       updated = true;
//     } on UpdateException {
//       Fluttertoast.showToast(
//         msg: 'Během aktualizace písní nastala chyba.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );

//       updated = false;
//     }

//     await _preload();

//     _addLanguagesToTags();

//     _songsSongLyrics = Map<int, List<SongLyric>>.from({});

//     for (final songLyric in songLyrics) {
//       final songId = songLyric.songId;
//       if (songId == null) continue;

//       if (!_songsSongLyrics.containsKey(songId)) _songsSongLyrics[songId] = List<SongLyric>.empty(growable: true);

//       _songsSongLyrics[songId]?.add(songLyric);
//     }

//     if (forceUpdate) notifyListeners();

//     return updated;
//   }

//   Future<void> _preload() async {
//     final futures = List<Future>.empty(growable: true);

//     List<Author> authors = [];
//     List<External> externals = [];
//     List<Playlist> playlists = [];
//     List<SongLyric> songLyrics = [];
//     List<Songbook> songbooks = [];
//     List<SongbookRecord> songbookRecords = [];
//     List<PlaylistRecord> playlistRecords = [];
//     List<Tag> tags = [];

//     List<model.Song_lyricsAuthors> songLyricAuthors = [];
//     List<model.Song_lyricsTags> songLyricTags = [];

//     futures.add((() async => authors = await Author.authors)());
//     futures.add((() async => externals = await External.externals)());
//     futures.add((() async => playlists = await Playlist.playlists)());
//     futures.add((() async => playlistRecords = await PlaylistRecord.playlistRecords)());
//     futures.add((() async => songLyrics = await SongLyric.songLyrics)());
//     futures.add((() async => songbooks = await Songbook.songbooks)());
//     futures.add((() async => songbookRecords = await SongbookRecord.songbookRecords)());
//     futures.add((() async => tags = await Tag.tags)());

//     futures.add((() async => songLyricAuthors = await model.Song_lyricsAuthors().select().toList())());
//     futures.add((() async => songLyricTags = await model.Song_lyricsTags().select().toList())());

//     await Future.wait(futures);

//     final authorsMap = Map<int, Author>.fromIterable(authors, key: (element) => element.id);
//     final playlistsMap = Map<int, Playlist>.fromIterable(playlists, key: (element) => element.id);
//     final songLyricsMap = Map<int, SongLyric>.fromIterable(songLyrics, key: (element) => element.id);
//     final songbooksMap = Map<int, Songbook>.fromIterable(songbooks, key: (element) => element.id);

//     for (final songLyricAuthor in songLyricAuthors)
//       if (authorsMap.containsKey(songLyricAuthor.authorsId))
//         songLyricsMap[songLyricAuthor.song_lyricsId]?.authors.add(authorsMap[songLyricAuthor.authorsId]!);

//     for (final songLyricTag in songLyricTags)
//       if (songLyricTag.tagsId != null) songLyricsMap[songLyricTag.song_lyricsId]?.tagIds.add(songLyricTag.tagsId!);

//     for (final external in externals) songLyricsMap[external.songLyricId]?.externals.add(external);

//     for (final songbookRecord in songbookRecords) {
//       songLyricsMap[songbookRecord.songLyricId]?.songbookRecords[songbookRecord.songbookId] = songbookRecord;
//       songbooksMap[songbookRecord.songbookId]?.records.add(songbookRecord);
//     }

//     for (final songbook in songbooks)
//       songbook.records.sort((first, second) => compareNatural(first.number, second.number));

//     for (final playlistRecord in playlistRecords)
//       playlistsMap[playlistRecord.playlistId]?.records[playlistRecord.songLyricId] = playlistRecord;

//     _playlists = playlistsMap;
//     _songLyrics = songLyricsMap;
//     _songbooks = songbooksMap;
//     _tags = tags;
//   }

//   void _addLanguagesToTags() {
//     final languages = Map<String, int>.from({});

//     for (final songLyric in songLyrics) {
//       if (!languages.containsKey(songLyric.language)) languages[songLyric.language] = 0;

//       languages[songLyric.language] = languages[songLyric.language]! + 1;
//     }

//     final languageTags = List<Tag>.empty(growable: true);

//     for (final language in languages.keys) {
//       final tag = Tag(model.Tag(name: language, type_enum: 'LANGUAGE'));

//       languageTags.add(tag);
//     }

//     languageTags.sort((first, second) => -languages[first.name]!.compareTo(languages[second.name]!));

//     _tags.addAll(languageTags);
//   }
// }
