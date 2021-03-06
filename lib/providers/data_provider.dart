import 'package:zpevnik/models/entities/song.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/song_lyric.dart';
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

  Map<int, SongLyric> _songLyricsMap;
  Map<int, Songbook> _songbooksMap;

  Future<void> init() async {
    final songs = (await Database.shared.songs).map((key, value) => MapEntry(key, Song(value)));
    Set<String> languages = Set();
    Map<String, int> languageCounts = {};

    final songLyrics = await Database.shared.songLyrics;
    final songbooks = await Database.shared.songbooks;

    await Database.shared.updateSongLyricsSearchTable(songLyrics, songbooks);

    _songLyrics = songLyrics.map((songLyricEntity) {
      // fixme: temporary solution for empty songs
      if (!songs.containsKey(songLyricEntity.songId))
        songs[songLyricEntity.songId] = Song(SongEntity(id: 0, name: songLyricEntity.name));

      if (songs[songLyricEntity.songId].songLyrics == null) songs[songLyricEntity.songId].songLyrics = [];
      final songLyric = SongLyric(songLyricEntity, songs[songLyricEntity.songId]);

      languages.add(songLyricEntity.language);
      if (!languageCounts.containsKey(songLyricEntity.language)) languageCounts[songLyricEntity.language] = 0;

      languageCounts[songLyricEntity.language]++;

      songs[songLyricEntity.songId].songLyrics.add(songLyric);
      return songLyric;
    }).toList()
      ..sort((first, second) => first.name.compareTo(second.name));

    _songLyricsMap = {};
    for (final songLyric in _songLyrics) _songLyricsMap[songLyric.id] = songLyric;

    _songbooks = songbooks.map((songbookEntity) => Songbook(songbookEntity)).toList();
    _songbooksMap = {};
    for (final songbook in _songbooks) _songbooksMap[songbook.id] = songbook;

    _tags = (await Database.shared.tags).map((tagEntity) => Tag(tagEntity)).toList();

    _tags.addAll(languages.map((language) => Tag(TagEntity(name: language, type: TagType.language.rawValue))).toList()
      ..sort((first, second) => -languageCounts[first.name].compareTo(languageCounts[second.name])));

    _playlists = (await Database.shared.playlists).map((playlistEntity) => Playlist(playlistEntity)).toList();
  }

  List<SongLyric> get songLyrics => _songLyrics;
  List<Songbook> get songbooks => _songbooks;
  List<Tag> get tags => _tags;
  List<Playlist> get playlists => _playlists;

  SongLyric songLyric(int id) => _songLyricsMap[id];

  Songbook songbook(int id) => _songbooksMap[id];
}
