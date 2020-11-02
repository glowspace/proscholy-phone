import 'package:flutter/material.dart';
import 'package:zpevnik/models/entities/song_lyric.dart';
import 'package:zpevnik/providers/settings_provider.dart';
import 'package:zpevnik/utils/database.dart';
import 'package:zpevnik/utils/song_lyrics_parser.dart';

final RegExp _chordsRE = RegExp(r'\[[^\]]+\]');

class SongLyric extends ChangeNotifier {
  final SongLyricEntity _entity;

  List<Verse> _verses;

  List<Verse> _versesNoChords;

  List<String> _numbers;

  bool _hasChords;

  SongLyric(this._entity);

  SongLyricEntity get entity => _entity;

  int get id => _entity.id;

  String get number => _entity.id.toString();

  // todo: add songbook shortcut
  List<String> get numbers =>
      _numbers ??= [id.toString()] + _entity.songbookRecords.map((record) => '${record.number}').toList();

  String get name => _entity.name;

  List<Verse> get verses => showChords
      ? _verses ??= SongLyricsParser.shared.parseLyrics(_entity.lyrics, transposition, accidentals)
      : _versesNoChords ??= SongLyricsParser.shared.parseLyrics(_entity.lyrics.replaceAll(_chordsRE, ''), 0, false);

  bool get isFavorite => _entity.favoriteOrder != null;

  int get transposition => _entity.transposition ??= 0;

  bool get hasChords => _hasChords ??= _entity.lyrics.contains(_chordsRE);

  bool get showChords => _entity.showChords ?? SettingsProvider.shared.showChords;

  bool get accidentals => _entity.accidentals ?? SettingsProvider.shared.accidentals;

  void toggleFavorite() {
    if (isFavorite)
      _entity.favoriteOrder = null;
    else
      _entity.favoriteOrder = 1;

    Database.shared.updateSongLyric(_entity, ['favorite_order'].toSet());

    // fixme: it will also redraw lyrics because of this
    notifyListeners();
  }

  void changeTransposition(int byValue) {
    _entity.transposition += byValue;
    if (_entity.transposition == 12 || _entity.transposition == -12) _entity.transposition = 0;

    verses.forEach((verse) =>
        verse.lines.forEach((line) => line.blocks.forEach((block) => block.transposition = _entity.transposition)));

    Database.shared.updateSongLyric(_entity, ['transposition'].toSet());

    notifyListeners();
  }

  set accidentals(bool accidentals) {
    _entity.accidentals = accidentals;

    Database.shared.updateSongLyric(_entity, ['accidentals'].toSet());

    verses.forEach(
        (verse) => verse.lines.forEach((line) => line.blocks.forEach((block) => block.accidentals = accidentals)));

    notifyListeners();
  }

  set showChords(bool showChords) {
    _entity.showChords = showChords;

    Database.shared.updateSongLyric(_entity, ['show_chords'].toSet());

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
  final bool _shouldShowLine;

  int transposition;
  bool accidentals;

  Block(this._chord, this.lyricsPart, this._shouldShowLine);

  String get chord =>
      SongLyricsParser.shared.convertAccidentals(SongLyricsParser.shared.transpose(_chord, transposition), accidentals);

  bool get shouldShowLine => _shouldShowLine && lyricsPart.contains(new RegExp(r'[A-Za-z]'));
}
