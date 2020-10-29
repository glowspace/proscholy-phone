import 'package:flutter/material.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/song_lyrics_parser.dart';

class SongLyric extends ChangeNotifier {
  final SongLyricEntity _entity;

  List<Verse> _verses;

  SongLyric(this._entity);

  int get id => _entity.id;

  String get name => _entity.name;

  List<Verse> get verses => _verses ??= SongLyricsParser.shared.parseLyrics(_entity.lyrics);

  int _transposition = 0;

  int get trasnposition => _transposition;

  void changeTransposition(int byValue) {
    _transposition += byValue;

    verses.forEach(
        (verse) => verse.lines.forEach((line) => line.blocks.forEach((block) => block.transposition = _transposition)));

    notifyListeners();
  }

  set accidentals(value) {
    notifyListeners();
  }

  set showChords(value) {
    notifyListeners();
  }
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
  final String _chord;
  final String lyricsPart;
  int transposition = 0;

  Block(this._chord, this.lyricsPart);

  String get chord => SongLyricsParser.shared.transpose(_chord, transposition);

  bool get shouldShowLine => lyricsPart.contains(new RegExp(r'[A-Za-z]'));
}
