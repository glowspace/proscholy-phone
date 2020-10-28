import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/song_lyrics_parser.dart';

class SongLyric {
  final SongLyricEntity _entity;

  String _lyrics;

  SongLyric(this._entity);

  int get id => _entity.id;

  String get name => _entity.name;

  List<Verse> get parsedLyrics =>
      SongLyricsParser.shared.parseLyrics(_entity.lyrics);
}

class Verse {
  final String number;
  final List<Line> lines;

  Verse(this.number, this.lines);

  factory Verse.fromMatch(RegExpMatch match) => Verse(
        match.group(1),
        SongLyricsParser.shared.lines(match.group(2)),
      );

  factory Verse.withoutNumber(String verse) => Verse(
        '',
        SongLyricsParser.shared.lines(verse),
      );
}

class Line {
  final List<Block> blocks;

  Line(this.blocks);
}

class Block {
  final String chord;
  final String lyricsPart;

  Block(this.chord, this.lyricsPart);
}
