import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/models/entities/songbook.dart';
import 'package:zpevnik/models/entities/tag.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/utils/database.dart';

class DataProvider {
  DataProvider._();

  static final DataProvider shared = DataProvider._();

  List<SongLyric> _songLyrics;
  List<Songbook> _songbooks;
  List<Tag> _tags;

  Future<void> init({
    List<SongLyricEntity> songLyrics,
    List<Songbook> songbooks,
    List<TagEntity> tags,
  }) async {
    _songLyrics = (songLyrics ?? (await Database.shared.songLyrics))
        .map((songLyricEntity) => SongLyric(songLyricEntity))
        .toList();
    _songbooks = songbooks ?? await Database.shared.songbooks;
    _tags = (tags ?? (await Database.shared.tags))
        .map((tagEntity) => Tag(tagEntity))
        .toList();
  }

  List<SongLyric> get songLyrics => _songLyrics;
  List<Songbook> get songbooks => _songbooks;
  List<Tag> get tags => _tags;
}
