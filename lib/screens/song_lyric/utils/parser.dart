import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class Verse {
  final String? number;
  final List<Line> lines;
  final bool hasChords;

  Verse({this.number, required this.lines, this.hasChords = false});

  bool get isInterlude => number?.startsWith('@') ?? false;
}

class Line {
  final List<Block> blocks;

  Line(this.blocks);
}

class Block {
  final String? chord;
  final String lyricsPart;
  final bool endsInWordMiddle;
  final bool isComment;
  final bool isInterlude;

  String? updatedChord;

  Block({
    this.chord,
    required this.lyricsPart,
    this.endsInWordMiddle = false,
    this.isComment = false,
    this.isInterlude = false,
  }) : updatedChord = chord;
}

final _verseRE = RegExp(
    r'\s*\(?(\d+\.|[BCR]\d?[:.]|@mezihra:|@dohra:|@předehra:|#(?!.*\]))?\)?\s*((?:=\s*(\d\.)|.|\n)*?)\n*(?=$|(?<=\n)[^=]?\d\.|\(?[BCR]\d?[:.]\)?|@mezihra:|@dohra:|@předehra:|[^a-zA-Z]#(?!.*\]))');

final _chordRE = RegExp(r'\[[^\]]+\]');
final _placeholderRE = RegExp(r'\[%\]');
final _firstVerseRE = RegExp(r'1\.(?:.|\n)+?(?=\n+\d\.|\n+\(?[BCR][:.]\)?)', multiLine: true);

final _multipleSpacesRE = RegExp(r' +');

final _multipleNewLinesRE = RegExp(r'\n\s*\n');

List<Verse> parseLyrics(String lyrics, {bool showChords = true}) {
  lyrics = lyrics.replaceAll('\r', '').replaceAll(_multipleNewLinesRE, '\n');

  final preparedLyrics = showChords ? _substituteChordsPlaceholders(lyrics) : _removeChords(lyrics);

  final verses = List<Verse>.empty(growable: true);
  final versesMap = Map<String, Verse>.from({});

  for (final match in _verseRE.allMatches(preparedLyrics)) {
    String? number = match.group(1);
    final text = match.group(2);

    final isComment = number == '#';
    final isInterlude = number?.startsWith('@') ?? false;

    if (number == '#') number = '';

    if (number == '@mezihra:')
      number = 'M:';
    else if (number == '@dohra:')
      number = 'Z:';
    else if (number == '@předehra:') number = 'P:';

    Verse? verse;

    if (text != null && text.isNotEmpty) {
      verse = Verse(
        number: number,
        lines: _lines('$text\n', isComment: isComment, isInterlude: isInterlude),
        hasChords: text.contains(_chordRE),
      );
    } else if (number != null) verse = versesMap[number];

    if (verse != null) {
      verses.add(verse);

      if (number != null) versesMap[number] = verse;
    }
  }

  if (verses.isEmpty) return [Verse(lines: _lines(preparedLyrics), hasChords: preparedLyrics.contains(_chordRE))];

  return verses;
}

// replaces all placeholder chords with chords from first verse
String _substituteChordsPlaceholders(String lyrics) {
  final firstVerse = _firstVerseRE.stringMatch(lyrics);

  if (firstVerse == null) return lyrics;

  final chords = _chordRE.allMatches(firstVerse).map((match) => firstVerse.substring(match.start, match.end)).toList();

  int index = 0;

  return lyrics.replaceAllMapped(_placeholderRE, (match) => chords[index++ % chords.length]);
}

String _removeChords(String lyrics) => lyrics.replaceAll(_chordRE, '');

List<Line> _lines(String verse, {bool isComment = false, bool isInterlude = false}) {
  int index = 0;

  return verse.split('\n').map((line) => Line(_blocks(line.trim(), isComment && (index++ == 0), isInterlude))).toList();
}

List<Block> _blocks(String line, bool isComment, bool isInterlude) {
  final blocks = List<Block>.empty(growable: true);

  String previousChord = '';
  int index = 0;

  for (final match in _chordRE.allMatches(line)) {
    final text = line.substring(index, match.start);

    if (previousChord.isNotEmpty || text.isNotEmpty) {
      final endsInWordMiddle = line[match.start - 1] != ' ';

      blocks.addAll(_splitToWords(previousChord, text, endsInWordMiddle, isComment, isInterlude));
    }

    index = match.end;
    previousChord = line.substring(match.start + 1, match.end - 1).replaceFirst('is', '#');
  }

  blocks.addAll(_splitToWords(previousChord, line.substring(index), false, isComment, isInterlude));

  return blocks;
}

List<Block> _splitToWords(String chord, String text, bool endsInWordMiddle, bool isComment, bool isInterlude) {
  final blocks = List<Block>.empty(growable: true);

  final words = text.trimRight().split(_multipleSpacesRE);

  String previousPart = '';

  for (int i = 0; i < words.length; i++) {
    final _endsInWordMiddle = endsInWordMiddle && i == words.length - 1;

    final lyricsPart = !_endsInWordMiddle ? '${words[i]} ' : words[i];

    if (i == 0) {
      if (words.length == 1 || _textWidth(chord) + 0.5 * kDefaultPadding < _textWidth(lyricsPart))
        blocks.add(Block(
          chord: chord,
          lyricsPart: lyricsPart,
          endsInWordMiddle: _endsInWordMiddle,
          isComment: isComment,
          isInterlude: isInterlude,
        ));
      else
        previousPart = lyricsPart;
    } else {
      blocks.add(Block(
        chord: previousPart.isNotEmpty ? chord : null,
        lyricsPart: '$previousPart$lyricsPart',
        endsInWordMiddle: _endsInWordMiddle,
        isComment: isComment,
        isInterlude: isInterlude,
      ));

      previousPart = '';
    }
  }

  return blocks;
}

double _textWidth(String text) {
  final textPainter = TextPainter(text: TextSpan(text: text), textDirection: TextDirection.ltr);

  textPainter.layout(maxWidth: double.infinity);

  return textPainter.width;
}
