import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/utils/database.dart';

class DataProvider {
  DataProvider._();

  static final DataProvider shared = DataProvider._();

  List<SongLyric> _songLyrics;
  List<Songbook> _songbooks;

  Future<void> init() async {
    _songLyrics = await Database.shared.songLyrics;
    _songbooks = await Database.shared.songbooks;
  }

  List<SongLyric> get songLyrics => _songLyrics;
  List<Songbook> get songbooks => _songbooks;
}
