import 'package:zpevnik/models/song_lyric.dart';

final _verseRE = RegExp(
    r'\s*(\d+\.|\(?[BCR]\d?[:.]\)?|@mezihra:|@dohra:|#(?!.?\]))?\s*((?:=\s*(\d\.)|.|\n)*?)\n*(?=$|[^=]?\d\.|\(?[BCR]\d?[:.]\)?|@mezihra:|@dohra:|#(?!.?\]))');
final _chordsRE = RegExp(r'\[[^\]]+\]');
final _placeholderRE = RegExp(r'\[%\]');
final _firstVerseRE = RegExp(r'1\.(?:.|\n)+?(?=\n+\d\.|\n+\(?[BCR][:.]\)?)', multiLine: true);

final _plainChords = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'H'];
final _plainChordsRE = RegExp(r'[CDEFGAH]#?');

final _toFlat = {'C#': 'Db', 'D#': 'Eb', 'F#': 'Gb', 'G#': 'Ab', 'A#': 'B'};
final _toFlatRE = RegExp(r'[CDEFGAH]#');

final _fromFlat = {'Db': 'C#', 'Eb': 'D#', 'Gb': 'F#', 'Ab': 'G#', 'B': 'A#'};
final _fromFlatRE = RegExp(r'([CDEFGAH]b|B)');

final _parenthesesRE = RegExp(r'\(?\)?');
final _multipleSpacesRE = RegExp(r' +');

final _letterRE = RegExp(r'[a-zA-ZěščřžýáíéĚŠČŘŽÝÁÍÉ]');

final _interludePartRE = RegExp(r'(/:\s?|:/\s?)');

class SongLyricsParser {
  SongLyricsParser._();

  static final SongLyricsParser shared = SongLyricsParser._();

  List<Verse> parseLyrics(String lyrics, int transposition, bool accidentals) =>
      _verses(_substituteChordsPlaceholders(lyrics.replaceAll('\r', '')))
        ..forEach(
          (verse) => verse.lines.forEach(
            (line) => line.blocks.forEach(
              (block) {
                block.transposition = transposition;
                block.accidentals = accidentals;
              },
            ),
          ),
        );

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
      if (substitute == null) substitute = substitutes[verses[i].number.replaceAll(_parenthesesRE, '')];

      if ((verses[i].lines.isEmpty ||
              verses[i].lines[0].blocks.isEmpty ||
              verses[i].lines[0].blocks[0].lyricsPart.isEmpty) &&
          substitute != null) verses[i] = Verse(substitute.number, substitute.lines, false);

      substitutes[verses[i].number] = verses[i];
    }

    List<Verse> finalizedVerses = [];
    for (final verse in verses) {
      if (verse.isComment) {
        finalizedVerses.add(Verse('', [verse.lines[0]], true));
        if (verse.lines.length > 1) finalizedVerses.add(Verse('', verse.lines.sublist(1), false));
      } else
        finalizedVerses.add(verse);
    }

    return finalizedVerses;
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
  List<Line> lines(String verse, bool isInterlude) =>
      verse.split('\n').map((line) => Line(_blocks(line, isInterlude))).toList();

  // extracts blocks from verse lines, every block is either word or part of word with corresponding chord
  // it is generated like this only for easier displaying of song lyric
  List<Block> _blocks(String line, bool isInterlude) {
    List<Block> blocks = [];

    if (isInterlude) line = line.replaceAll(_interludePartRE, '');

    String previous = '';
    int index = 0;

    for (final match in _chordsRE.allMatches(line)) {
      final text = line.substring(index, match.start);

      // don't create empty blocks
      if (previous.length > 0 || text.length > 0) {
        final words = text.split(_multipleSpacesRE);
        final isNextLetter = match.end != line.length && _letterRE.hasMatch(line[match.end]);
        final isLastSpace = text.length > 0 && !_letterRE.hasMatch(text.substring(text.length - 1));

        int i = 0;
        if (previous.isNotEmpty) {
          // temporary solution to handle shorter chord than word
          if (words[i].length <= previous.length && words.length > 1)
            blocks.add(Block(
                previous,
                '${words[i++]} ${words[i++]}' + (words.length > 2 || text.endsWith(' ') ? ' ' : ''),
                words.length == 2 && isNextLetter && !isLastSpace,
                isInterlude));
          else
            blocks.add(Block(previous, words[i++] + (words.length > 1 || text.endsWith(' ') ? ' ' : ''),
                words.length == 1 && isNextLetter && !isLastSpace, isInterlude));
        }

        // print('$words, $isNextLetter, $isLastSpace');
        if (words.length > i && (!isNextLetter || isLastSpace)) {
          final text = words.sublist(i).join(' ');

          if (isNextLetter || isLastSpace)
            blocks.add(Block('', '$text', isNextLetter && !isLastSpace, isInterlude));
          else
            blocks.add(Block('', '$text ', false, isInterlude));
        } else if (words.length > i) {
          final text = words.sublist(i, words.length - 1).join(' ');
          if (text.isNotEmpty) blocks.add(Block('', '$text ', false, isInterlude));

          blocks.add(Block('', '${words[words.length - 1]}', isNextLetter && !isLastSpace, isInterlude));
        }
      }

      index = match.end;
      // normalize chord to be in # accidentals and replace -is with #
      previous = convertAccidentals(line.substring(match.start + 1, match.end - 1), false).replaceFirst('is', '#');
    }

    final words = line.substring(index).split(' ');

    int i = 0;
    if (previous.isNotEmpty) {
      // temporary solution to handle shorter chord than word
      if (words[i].length < 4 && words.length > 1)
        blocks.add(Block(previous, '${words[i++]} ${words[i++]}' + (words.length > 2 ? ' ' : ''), false, isInterlude));
      else
        blocks.add(Block(previous, words[i++] + (words.length > 1 ? ' ' : ''), false, isInterlude));
    }

    if (words.length > i) {
      final text = words.sublist(i).join(' ');

      blocks.add(Block('', '$text', false, isInterlude));
    }

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
