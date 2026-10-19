import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/song_lyric/utils/parser.dart';

import '../../../utils.dart';

List<String> _tokens(String lyrics) {
  final parser = SongLyricsParser(createSongLyric(lyrics: lyrics));

  return [for (var token = parser.nextToken; token != null; token = parser.nextToken) '$token'];
}

List<String> _verses(String lyrics, int count) {
  final parser = SongLyricsParser(createSongLyric(lyrics: lyrics));

  return [for (var part = 0; part < count; part++) parser.getVerse(part)];
}

void main() {
  group('tokens', () {
    test('verse with chords', () {
      expect(_tokens('1. [C]Ahoj [G]světe\n[Ami]druhý řádek'), [
        'PresentationBreakpoint(0)',
        'VerseNumber(1.)',
        'Chord(C)',
        'VersePart(Ahoj )',
        'Chord(G)',
        'VersePart(světe)',
        'NewLine()',
        'Chord(Ami)',
        'VersePart(druhý řádek)',
        'NewLine()',
        'VerseEnd()',
      ]);
    });

    test('lyrics without verse number', () {
      expect(_tokens('[C]bez čísla\ndalší'), [
        'PresentationBreakpoint(0)',
        'VerseNumber()',
        'Chord(C)',
        'VersePart(bez čísla)',
        'NewLine()',
        'VersePart(další)',
        'NewLine()',
        'VerseEnd()',
      ]);
    });

    test('flat chords are converted to sharps', () {
      expect(_tokens('1. [B]a [Es]b [Fsus4]c'), [
        'PresentationBreakpoint(0)',
        'VerseNumber(1.)',
        'Chord(A#)',
        'VersePart(a )',
        'Chord(D#)',
        'VersePart(b )',
        'Chord(Fsus4)',
        'VersePart(c)',
        'NewLine()',
        'VerseEnd()',
      ]);
    });

    test('comments', () {
      expect(_tokens('# úvodní\n1. sloka\n# na konci'), [
        'Comment(úvodní)',
        'PresentationBreakpoint(0)',
        'VerseNumber(1.)',
        'VersePart(sloka)',
        'NewLine()',
        'VerseEnd()',
        'Comment(na konci)',
      ]);
    });

    test('interlude', () {
      expect(_tokens('@mezihra: [C] [G]\n1. sloka'), [
        'Interlude(M:)',
        'Chord(C)',
        'Chord(G)',
        'NewLine()',
        'InterludeEnd()',
        'PresentationBreakpoint(0)',
        'VerseNumber(1.)',
        'VersePart(sloka)',
        'NewLine()',
        'VerseEnd()',
      ]);
    });

    test('empty lines split verse for presentation', () {
      expect(_tokens('1. první\n\n\ndruhý odstavec'), [
        'PresentationBreakpoint(0)',
        'VerseNumber(1.)',
        'VersePart(první)',
        'NewLine()',
        'NewLine()',
        'PresentationBreakpoint(1)',
        'NewLine()',
        'VersePart(druhý odstavec)',
        'NewLine()',
        'VerseEnd()',
      ]);
    });
  });

  group('substitutes', () {
    const refrain = ['VerseNumber(R:)', 'Chord(C)', 'VersePart(refrén)', 'NewLine()', 'VerseEnd()'];

    test('empty refrain is filled with first refrain', () {
      expect(_tokens('1. sloka\nR: [C]refrén\n2. druhá\nR:\n').skip(17), refrain);
    });

    test('verse substitute is filled with referenced verse', () {
      expect(_tokens('1. sloka\nR: [C]refrén\n2. druhá\n(R:)\n').skip(17), refrain);
    });

    test('chord substitutes reuse chords from first verse', () {
      expect(_tokens('1. [C]a [G]b\n2. [%]c [%]d').skip(8), [
        'PresentationBreakpoint(1)',
        'VerseNumber(2.)',
        'Chord(C)',
        'VersePart(c )',
        'Chord(G)',
        'VersePart(d)',
        'NewLine()',
        'VerseEnd()',
      ]);
    });
  });

  group('presentation', () {
    test('verses without chords', () {
      expect(_verses('1. [C]Ahoj [G]světe\n[Ami]druhý řádek', 2), ['1. Ahoj světe\ndruhý řádek', '']);
    });

    test('refrain is repeated', () {
      expect(_verses('1. sloka\nR: [C]refrén\n2. druhá\n(R:)\n', 5), [
        '1. sloka',
        'R: refrén',
        '2. druhá',
        'R: refrén',
        '',
      ]);
    });

    test('empty lines split verse', () {
      expect(_verses('1. první\n\n\ndruhý odstavec', 2), ['1. první', 'druhý odstavec']);
    });
  });
}
