import 'package:presentation/presentation.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';

class PresentationProvider {
  final presentation = Presentation();

  void start(SongLyricsParser songLyricsParser) {
    presentation.transferData(songLyricsParser.getVerse(0));
  }

  void changeSongLyric(SongLyricsParser songLyricsParser) {
    presentation.transferData(songLyricsParser.getVerse(0));
  }
}
