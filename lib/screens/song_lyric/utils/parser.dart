import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';

final _styleRE = RegExp(r'\<style[^\<]*\<\/style\>');
final _heightRE = RegExp(r'height="([\d\.]+)mm"');
final _widthRE = RegExp(r'width="([\d\.]+)"');

abstract class Token {}

class Comment extends Token {
  final String value;

  Comment(String value) : value = value.trim();

  @override
  String toString() => 'Comment($value)';
}

class Chord extends Token {
  final String value;

  Chord(this.value);

  @override
  String toString() => 'Chord($value)';
}

class ChordSubstitute extends Token {
  final int index;

  ChordSubstitute(this.index);

  @override
  String toString() => 'ChordSubstitute($index)';
}

class Interlude extends Token {
  late final String value;

  Interlude(String value) {
    value = value.trim();

    switch (value) {
      case 'mezihra:':
        this.value = 'M:';
        break;
      case 'dohra:':
        this.value = 'Z:';
        break;
      case 'předehra:':
        this.value = 'P:';
        break;
    }
  }

  @override
  String toString() => 'Interlude($value)';
}

class InterludeEnd extends Token {
  @override
  String toString() => 'InterludeEnd()';
}

class NewLine extends Token {
  @override
  String toString() => 'NewLine()';
}

class VerseNumber extends Token {
  final String value;

  VerseNumber(this.value);

  @override
  String toString() => 'VerseNumber($value)';
}

class VerseSubstitute extends Token {
  final String id;

  VerseSubstitute(this.id);

  @override
  String toString() => 'VerseSubstitute($id)';
}

class VersePart extends Token {
  final String value;

  VersePart(this.value);

  @override
  String toString() => 'Text($value)';
}

class VerseEnd extends Token {
  @override
  String toString() => 'VerseEnd()';
}

enum _ParserState { chord, comment, lineStart, interlude, possibleVerseNumber, verseNumber, verseSubstitute, verseLine }

class SongLyricsParser {
  final SongLyric songLyric;
  late final List<Token> _parsedSongLyrics;

  SongLyricsParser(this.songLyric) {
    final tokens = _parseTokens();

    _parsedSongLyrics = _fillSubstitutes(tokens);

    log(_parsedSongLyrics.toString());
  }

  int _currentTokenIndex = 0;
  bool _hasChords = false;

  double? _lilypondWidth;
  String? _lilypond;

  Token? get nextToken {
    if (_currentTokenIndex == _parsedSongLyrics.length) {
      _currentTokenIndex = 0;
      return null;
    }

    return _parsedSongLyrics[_currentTokenIndex++];
  }

  bool get hasChords => _hasChords;
  bool get hasLilypond => songLyric.lilypond != null;

  double get lilypondWidth => _lilypondWidth ?? 0;

  String lilypond(String hexColor) {
    if (_lilypond != null) return _lilypond!;

    _lilypond = (songLyric.lilypond ?? '')
        .replaceAll(_styleRE, '')
        .replaceAll('currentColor', hexColor)
        .replaceFirst(_heightRE, '')
        .replaceFirstMapped(_widthRE, (match) {
      _lilypondWidth = double.tryParse(match.group(1) ?? '');

      return '';
    });

    return _lilypond!;
  }

  List<Token> _parseTokens() {
    final lyrics = songLyric.lyrics;
    final List<Token> tokens = [];

    _ParserState state = _ParserState.lineStart;

    String currentString = '';
    int chordSubstituteIndex = 0;

    bool isInsideVerse = false;
    bool isInsideInterlude = false;

    for (final c in lyrics.characters) {
      // handles verse number start (digits)
      if (state == _ParserState.lineStart && int.tryParse(c) != null) {
        chordSubstituteIndex = 0;

        state = _ParserState.verseNumber;
        currentString += c;

        continue;
      }

      switch (c) {
        // handles verse number start
        case 'B':
        case 'C':
        case 'R':
          if (state == _ParserState.lineStart) {
            chordSubstituteIndex = 0;

            state = _ParserState.possibleVerseNumber;
          }

          currentString += c;
          break;
        // handles verse number end
        case ':':
        case '.':
          currentString += c;

          if (state == _ParserState.verseNumber || state == _ParserState.possibleVerseNumber) {
            if (isInsideVerse) tokens.add(VerseEnd());
            if (isInsideInterlude) tokens.add(InterludeEnd());

            tokens.add(VerseNumber(currentString));

            currentString = '';
            state = _ParserState.verseLine;

            isInsideVerse = true;
            isInsideInterlude = false;
          }

          break;
        // handles verse substitute start
        case '(':
          if (state == _ParserState.lineStart) {
            currentString = '';
            state = _ParserState.verseSubstitute;
          }
          break;
        // handles verse substitute end
        case ')':
          if (state == _ParserState.verseSubstitute) {
            if (isInsideVerse) tokens.add(VerseEnd());
            if (isInsideInterlude) tokens.add(InterludeEnd());

            tokens.add(VerseSubstitute(currentString));

            currentString = '';
            state = _ParserState.verseLine;

            isInsideVerse = true;
            isInsideInterlude = false;
          }
          break;
        // handles interlude
        case '@':
          if (state == _ParserState.lineStart) {
            if (isInsideVerse) tokens.add(VerseEnd());

            currentString = '';
            state = _ParserState.interlude;

            isInsideVerse = false;
            isInsideInterlude = true;
          } else {
            currentString += c;
          }
          break;
        // handles start of chord
        case '[':
          if (currentString.isNotEmpty) {
            if (state == _ParserState.interlude) {
              tokens.add(Interlude(currentString));
            } else {
              tokens.add(VersePart(currentString));
            }
          }

          currentString = '';
          state = _ParserState.chord;
          break;
        // handles end of chord
        case ']':
          if (currentString == '%') {
            tokens.add(ChordSubstitute(chordSubstituteIndex++));
          } else if (currentString.isNotEmpty) {
            tokens.add(Chord(currentString));
          }

          _hasChords = true;

          currentString = '';
          state = _ParserState.verseLine;
          break;
        // handles comments
        case '#':
          if (state == _ParserState.lineStart) {
            if (isInsideVerse) tokens.add(VerseEnd());
            if (isInsideInterlude) tokens.add(InterludeEnd());

            currentString = '';
            state = _ParserState.comment;

            isInsideVerse = false;
            isInsideInterlude = false;
          } else {
            currentString += c;
          }
          break;
        // handles end of line
        case '\r\n':
        case '\n':
          if (state == _ParserState.comment) {
            tokens.add(Comment(currentString));
          } else if (currentString.isNotEmpty) {
            tokens.add(VersePart(currentString));
          }

          tokens.add(NewLine());

          currentString = '';
          state = _ParserState.lineStart;
          break;
        default:
          if (state == _ParserState.lineStart) {
            state = _ParserState.verseLine;
          } else if (state == _ParserState.possibleVerseNumber && int.tryParse(c) == null) {
            state = _ParserState.verseLine;
          }

          currentString += c;
      }
    }

    if (state == _ParserState.comment) {
      tokens.add(Comment(currentString));
    } else if (currentString.isNotEmpty) {
      tokens.add(VersePart(currentString));
    }

    if (isInsideVerse) tokens.add(VerseEnd());
    if (isInsideInterlude) tokens.add(InterludeEnd());

    return tokens;
  }

  List<Token> _fillSubstitutes(List<Token> tokens) {
    if (tokens.isEmpty) return [];

    // log(songLyric.lyrics);
    // log(tokens.toString());

    final List<Token> filledTokens = [];

    final Map<String, List<Token>> verseSubstitutes = {};
    final List<Token> chordSubstitutes = [];

    String currentVerseNumber = '';
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];

      if (token is VerseNumber) {
        // substitute empty verses
        final emptyVerseEnd = _emptyVerseEnd(i + 1, tokens);

        if (emptyVerseEnd != null) {
          final substitutes =
              verseSubstitutes[token.value] ?? verseSubstitutes[token.value.replaceFirst('.', ':')] ?? [];

          filledTokens.addAll(substitutes);
          i = emptyVerseEnd;
        } else {
          currentVerseNumber = token.value;
          verseSubstitutes[currentVerseNumber] = [token];

          filledTokens.add(token);
        }
      } else if (token is VerseSubstitute) {
        // substitute empty verses
        final emptyVerseEnd = _emptyVerseEnd(i + 1, tokens);

        if (emptyVerseEnd != null) {
          final substitutes = verseSubstitutes[token.id] ?? verseSubstitutes[token.id.replaceFirst('.', ':')] ?? [];

          filledTokens.addAll(substitutes);
          i = emptyVerseEnd;
        } else {
          currentVerseNumber = token.id;
          verseSubstitutes[currentVerseNumber] = [VerseNumber(token.id)];

          filledTokens.add(VerseNumber(token.id));
        }
      } else if (token is Chord) {
        verseSubstitutes[currentVerseNumber]?.add(token);
        chordSubstitutes.add(token);
        filledTokens.add(token);
      } else if (token is ChordSubstitute) {
        verseSubstitutes[currentVerseNumber]?.add(chordSubstitutes[token.index]);
        filledTokens.add(chordSubstitutes[token.index]);
      } else if (token is VerseEnd) {
        // make sure that before verse end there is a new line
        if (filledTokens.last is! NewLine) filledTokens.add(NewLine());

        verseSubstitutes[currentVerseNumber]?.add(token);
        filledTokens.add(token);
      } else if (token is NewLine) {
        // remove unintentional empty lines at the start and after verse numbers
        if (filledTokens.isNotEmpty && filledTokens.last is! VerseNumber) {
          verseSubstitutes[currentVerseNumber]?.add(token);
          filledTokens.add(token);
        }
      } else {
        // remove leading space from first string after verse number
        if (filledTokens.isNotEmpty && filledTokens.last is VerseNumber && token is VersePart) {
          final trimmedValue = token.value.trimLeft();

          if (trimmedValue.isNotEmpty) {
            final trimmedToken = VersePart(trimmedValue);

            verseSubstitutes[currentVerseNumber]?.add(trimmedToken);
            filledTokens.add(trimmedToken);
          }
        } else {
          verseSubstitutes[currentVerseNumber]?.add(token);
          filledTokens.add(token);
        }
      }
    }

    // make sure that verse start is indicated by verse number even when there is no number
    if (filledTokens.first is Chord || filledTokens.first is VersePart) {
      // and make sure that end of that verse is also indicated
      final nextVerseStartIndex = filledTokens.indexWhere((token) => token is VerseNumber);
      if (nextVerseStartIndex == -1) {
        if (filledTokens.last is! NewLine) filledTokens.add(NewLine());

        filledTokens.add(VerseEnd());
      } else {
        filledTokens.insert(nextVerseStartIndex, VerseEnd());

        if (filledTokens[nextVerseStartIndex - 1] is! NewLine) {
          filledTokens.add(NewLine());
        }
      }

      filledTokens.insert(0, VerseNumber(''));
    }

    return filledTokens;
  }

  int? _emptyVerseEnd(int i, List<Token> tokens) {
    while (true) {
      if (tokens[i] is Chord || tokens[i] is VersePart) {
        return null;
      } else if (tokens[i] is VerseEnd) {
        return i;
      }

      i++;
    }
  }
}
