import 'package:zpevnik/models/songLyric.dart';

final RegExp _verseRE =
    RegExp(r'\s*(\d\.|\(?[BCR]\d?[:.]\)?)?\s*((?:=\s*(\d\.)|.|\n)*?)\n*(?=$|[^=]?\d\.|\(?[BCR]\d?[:.]\)?)');
final RegExp _chordsRE = RegExp(r'\[[^\]]+\]');
final RegExp _placeholderRE = RegExp(r'\[%\]');
final RegExp _firstVerseRE = RegExp(r'1\.(?:.|\n)+?(?=\n+\d\.|\n+\(?[BCR][:.]\)?)', multiLine: true);

final List<String> _plainChords = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'H'];
final RegExp _plainChordsRE = RegExp(r'[CDEFGAH]#?');

final Map<String, String> _toFlat = {'C#': 'Db', 'D#': 'Eb', 'F#': 'Gb', 'G#': 'Ab', 'A#': 'B'};
final RegExp _toFlatRE = RegExp(r'[CDEFGAH]#');

final Map<String, String> _fromFlat = {'Db': 'C#', 'Eb': 'D#', 'Gb': 'F#', 'Ab': 'G#', 'B': 'A#'};
final RegExp _fromFlatRE = RegExp(r'([CDEFGAH]b|B)');

final RegExp _parentheses = RegExp(r'\(?\)?');

class SongLyricsParser {
  SongLyricsParser._();

  static final SongLyricsParser shared = SongLyricsParser._();

  List<Verse> parseLyrics(String lyrics) =>
      _verses(_substituteChordsPlaceholders(lyrics.replaceAll('\r', '').replaceAll('@', '')));

  // replaces all placeholder chords with chords from first verse
  String _substituteChordsPlaceholders(String lyrics) {
    final chords = _firstVerseChords(lyrics);

    int index = 0;

    return lyrics.replaceAllMapped(_placeholderRE, (match) => chords[index++ % chords.length]);
  }

  // creates verses from lyrics
  List<Verse> _verses(String lyrics) {
    final verses = _verseRE.allMatches(lyrics).map((match) => Verse.fromMatch(match)).toList()
      ..removeWhere((verse) => verse == null);

    if (verses.isEmpty) return [Verse.withoutNumber(lyrics)];

    Map<String, Verse> substitutes = {};

    // replace empty verses, with substitutes
    for (int i = 0; i < verses.length; i++) {
      if (verses[i].number == '') continue;

      Verse substitute = substitutes[verses[i].number];

      // sometimes . and : are mixed, so check it with replaced
      if (substitute == null) substitute = substitutes[verses[i].number.replaceAll('.', ':')];

      // sometimes number is in parentheses, so check it as well
      if (substitute == null) substitute = substitutes[verses[i].number.replaceAll(_parentheses, '')];

      if ((verses[i].lines.isEmpty ||
              verses[i].lines[0].blocks.isEmpty ||
              verses[i].lines[0].blocks[0].lyricsPart.isEmpty) &&
          substitute != null) verses[i] = Verse(substitute.number, substitute.lines);

      substitutes[verses[i].number] = verses[i];
    }

    return verses;
  }

  // extracts chords from given lyrics
  List<String> _chords(String lyrics) =>
      _chordsRE.allMatches(lyrics).map((match) => lyrics.substring(match.start, match.end)).toList();

  // extracts chords from first verse, used to replace placeholders in next verses
  List<String> _firstVerseChords(String lyrics) {
    final match = _firstVerseRE.firstMatch(lyrics);

    if (match != null) return _chords(lyrics.substring(match.start, match.end));

    return null;
  }

  // extracts lines of verse
  List<Line> lines(String verse) => verse.split('\n').map((line) => Line(_blocks(line))).toList();

  // extracts blocks from verse lines, every block is either word or part of word with corresponding chord
  // it is generated like this only for easier displaying of song lyric
  List<Block> _blocks(String line) {
    List<Block> blocks = [];

    String previous = '';
    int index = 0;

    for (final match in _chordsRE.allMatches(line)) {
      final text = line.substring(index, match.start);

      // don't create empty blocks
      if (previous.length > 0 || text.length > 0) {
        final words = text.split(' ');

        int i = 0;
        // temporary solution to handle shorter chord than word
        if (words[i].length < 4 && words.length > 1)
          blocks.add(Block(previous, '${words[i++]} ${words[i++]}', true));
        else
          blocks.add(Block(previous, words[i++], true));

        for (; i < words.length; i++) blocks.add(Block('', ' ${words[i]}', true));
      }

      index = match.end;
      previous = line.substring(match.start + 1, match.end - 1);
    }

    blocks.add(Block(previous, line.substring(index), false));

    return blocks;
  }

  String transpose(String chord, int transposition) => chord.replaceAllMapped(
        _plainChordsRE,
        (match) => _plainChords[
            (_plainChords.indexOf(chord.substring(match.start, match.end)) + transposition) % _plainChords.length],
      );

  String convertAccidentals(String chord, bool accidental) => chord.replaceAllMapped(
      accidental ? _toFlatRE : _fromFlatRE,
      (match) => accidental
          ? _toFlat[chord.substring(match.start, match.end)]
          : _fromFlat[chord.substring(match.start, match.end)]);
}
