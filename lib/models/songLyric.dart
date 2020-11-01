import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/utils/database.dart';
import 'package:zpevnik/utils/song_lyrics_parser.dart';

final RegExp _chordsRE = RegExp(r'\[[^\]]+\]');

class SongLyric extends ChangeNotifier {
  final SongLyricEntity _entity;

  List<Verse> _verses;

  List<Verse> _versesNoChords;

  List<String> _numbers;

  // todo: load saved
  double _fontSize = 17;

  int _transposition = 0;

  bool _hasChords;

  bool _showChords = true;

  bool _accidentals = false;

  SongLyric(this._entity) {
    // print(_entity.tags);
  }

  SongLyricEntity get entity => _entity;

  int get id => _entity.id;

  String get number => _entity.id.toString();

  // todo: add songbook shortcut
  List<String> get numbers =>
      _numbers ??= [id.toString()] + _entity.songbookRecords.map((record) => '${record.number}').toList();

  String get name => _entity.name;

  List<Verse> get verses => _showChords
      ? _verses ??= SongLyricsParser.shared.parseLyrics(_entity.lyrics)
      : _versesNoChords ??= SongLyricsParser.shared.parseLyrics(_entity.lyrics.replaceAll(_chordsRE, ''));

  bool get isFavorite => _entity.favoriteOrder != null;

  double get fontSize => _fontSize;

  int get transposition => _transposition;

  bool get hasChords => _hasChords ??= _entity.lyrics.contains(_chordsRE);

  bool get showChords => _showChords;

  bool get accidentals => _accidentals;

  void toggleFavorite() {
    if (isFavorite)
      _entity.favoriteOrder = null;
    else
      _entity.favoriteOrder = 1;

    Database.shared.updateSongLyric(_entity, ['favorite_order'].toSet());

    // fixme: it will also redraw lyrics because of this
    notifyListeners();
  }

  void changeFontSize(double value) {
    if (value < kMinimumFontSize)
      value = kMinimumFontSize;
    else if (value > kMaximumFontSize) value = kMaximumFontSize;

    _fontSize = value;

    notifyListeners();
  }

  void changeTransposition(int byValue) {
    _transposition += byValue;
    if (_transposition == 12 || _transposition == -12) _transposition = 0;

    verses.forEach(
        (verse) => verse.lines.forEach((line) => line.blocks.forEach((block) => block.transposition = _transposition)));

    notifyListeners();
  }

  set accidentals(bool accidentals) {
    _accidentals = accidentals;

    verses.forEach(
        (verse) => verse.lines.forEach((line) => line.blocks.forEach((block) => block.accidentals = accidentals)));

    notifyListeners();
  }

  set showChords(bool showChords) {
    _showChords = showChords;

    notifyListeners();
  }
}

class Verse {
  final String number;
  final List<Line> lines;

  Verse(this.number, this.lines);

  factory Verse.fromMatch(RegExpMatch match) {
    if (match.group(1) == null && match.group(2).isEmpty) return null;

    if (match.group(1) == null)
      return Verse(
        '',
        SongLyricsParser.shared.lines(match.group(2)),
      );

    return Verse(
      match.group(1),
      SongLyricsParser.shared.lines(match.group(2)),
    );
  }

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
  final bool _showShowLine;

  int transposition = 0;
  bool accidentals = false;

  Block(this._chord, this.lyricsPart, this._showShowLine);

  String get chord =>
      SongLyricsParser.shared.convertAccidentals(SongLyricsParser.shared.transpose(_chord, transposition), accidentals);

  bool get shouldShowLine => _showShowLine && lyricsPart.contains(new RegExp(r'[A-Za-z]'));
}
