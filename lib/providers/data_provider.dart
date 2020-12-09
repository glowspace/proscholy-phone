import 'package:shared_preferences/shared_preferences.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/utils/database.dart';

class DataProvider {
  DataProvider._();

  static final DataProvider shared = DataProvider._();

  List<SongLyric> _songLyrics;
  List<Songbook> _songbooks;
  List<Tag> _tags;
  List<Playlist> _playlists;

  Map<int, Songbook> _songbooksMap;

  // fixme: temporary solution, needed by `SongLyric`
  SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    final songs = (await Database.shared.songs).map((key, value) => MapEntry(key, Song(value)));
    Set<String> languages = Set();
    Map<String, int> languageCounts = {};

    _songLyrics = (await Database.shared.songLyrics).map((songLyricEntity) {
      if (songs[songLyricEntity.songId].songLyrics == null) songs[songLyricEntity.songId].songLyrics = [];
      final songLyric = SongLyric(songLyricEntity, songs[songLyricEntity.songId]);

      languages.add(songLyricEntity.language);
      if (!languageCounts.containsKey(songLyricEntity.language)) languageCounts[songLyricEntity.language] = 0;

      languageCounts[songLyricEntity.language]++;

      songs[songLyricEntity.songId].songLyrics.add(songLyric);
      return songLyric;
    }).toList()
      ..sort((first, second) => first.name.compareTo(second.name));

    _songbooks = (await Database.shared.songbooks).map((songbookEntity) => Songbook(songbookEntity)).toList();
    _songbooksMap = {};
    for (final songbook in songbooks) _songbooksMap[songbook.id] = songbook;

    _tags = (await Database.shared.tags).map((tagEntity) => Tag(tagEntity)).toList();

    _tags.addAll(languages.map((language) => Tag(TagEntity(name: language, type: TagType.language.rawValue))).toList()
      ..sort((first, second) => -languageCounts[first.name].compareTo(languageCounts[second.name])));

    _playlists = (await Database.shared.playlists).map((playlistEntity) => Playlist(playlistEntity)).toList();
  }

  List<SongLyric> get songLyrics => _songLyrics;
  List<Songbook> get songbooks => _songbooks;
  List<Tag> get tags => _tags;
  List<Playlist> get playlists => _playlists;

  Songbook songbook(int id) => _songbooksMap[id];
}
