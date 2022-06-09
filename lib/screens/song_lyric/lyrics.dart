import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/song_lyric/utils/converter.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/screens/song_lyric/utils/parser.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/hex_color.dart';

class LyricsWidget extends StatelessWidget {
  final LyricsController lyricsController;

  const LyricsWidget({Key? key, required this.lyricsController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final settingsProvider = context.watch<SettingsProvider>();

    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                lyricsController.songLyric.name,
                style: appTheme.titleTextStyle,
                textScaleFactor: settingsProvider.fontSizeScale,
              ),
            ),
            SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale),
            if (lyricsController.hasLilypond)
              SvgPicture.string(
                lyricsController.lilypond(appTheme.textColor.hex),
                width: min(width, lyricsController.lilypondWidth),
              ),
            if (lyricsController.hasLilypond) SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale / 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: _buildLyrics(context),
            ),
            SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: _buildAuthors(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLyrics(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    final List<Widget> children = [];

    Token? currentToken = lyricsController.parser.nextToken;
    while (currentToken != null) {
      if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, false));
      } else if (currentToken is Interlude) {
        if (lyricsController.showChords) {
          children.add(_buildInterlude(context, currentToken));
        } else {
          while (currentToken is! InterludeEnd) {
            currentToken = lyricsController.parser.nextToken;
          }
        }
      } else if (currentToken is VerseNumber) {
        children.add(_buildVerse(context, currentToken));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale));
      }

      currentToken = lyricsController.parser.nextToken;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildInterlude(BuildContext context, Interlude interlude) {
    final settingsProvider = context.watch<SettingsProvider>();

    final List<Widget> children = [];
    Token? currentToken = lyricsController.parser.nextToken;
    while (currentToken != null && currentToken is! InterludeEnd) {
      if (currentToken is Chord) {
        children.add(_buildLine(context, currentToken, _textStyle(context, false), isInterlude: true));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale));
      }

      currentToken = lyricsController.parser.nextToken;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding / 2),
          child: Text(
            interlude.value,
            style: _textStyle(context, false),
            textScaleFactor: settingsProvider.fontSizeScale,
          ),
        ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
      ],
    );
  }

  Widget _buildVerse(BuildContext context, VerseNumber number) {
    final settingsProvider = context.watch<SettingsProvider>();

    final textStyle = _textStyle(context, number.verseHasChord);

    final List<Widget> children = [];
    Token? currentToken = lyricsController.parser.nextToken;
    while (currentToken != null && currentToken is! VerseEnd) {
      if (currentToken is VersePart || currentToken is Chord) {
        children.add(_buildLine(context, currentToken, textStyle));
      } else if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, number.verseHasChord));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale));
      }

      currentToken = lyricsController.parser.nextToken;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding / 2),
            child: Text(number.value, style: textStyle, textScaleFactor: settingsProvider.fontSizeScale),
          ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
      ],
    );
  }

  Widget _buildLine(BuildContext context, Token token, TextStyle? textStyle, {bool isInterlude = false}) {
    final settingsProvider = context.watch<SettingsProvider>();

    final List<InlineSpan> children = [];

    Token? currentToken = token;
    Chord? currentChord;
    while (currentToken != null && currentToken is! NewLine) {
      if (currentToken is VersePart) {
        if (currentChord == null || !lyricsController.showChords) {
          children.add(TextSpan(text: currentToken.value));
        } else {
          children.add(_buildChord(context, currentChord, textStyle, versePart: currentToken));
          currentChord = null;
        }
      } else if (currentToken is Chord && lyricsController.showChords) {
        if (isInterlude) {
          children.add(_buildChord(context, currentToken, textStyle, isInterlude: true));
        } else if (currentChord != null) {
          children.add(_buildChord(context, currentChord, textStyle));
        }

        currentChord = currentToken;
      }

      currentToken = lyricsController.parser.nextToken;
    }

    if (!isInterlude && currentChord != null && lyricsController.showChords) {
      children.add(_buildChord(context, currentChord, textStyle));
    }

    return RichText(
      text: TextSpan(text: '', style: textStyle, children: children),
      textScaleFactor: settingsProvider.fontSizeScale,
    );
  }

  Widget _buildComment(BuildContext context, Comment comment, bool hasChords) {
    final settingsProvider = context.watch<SettingsProvider>();

    final showChords = hasChords && lyricsController.showChords;
    final textStyle = AppTheme.of(context).commentTextStyle?.copyWith(height: showChords ? 2.5 : 1.5);

    return Text(comment.value, style: textStyle, textScaleFactor: settingsProvider.fontSizeScale);
  }

  WidgetSpan _buildChord(BuildContext context, Chord chord, TextStyle? textStyle,
      {VersePart? versePart, bool isInterlude = false}) {
    final appTheme = AppTheme.of(context);
    final settingsProvider = context.watch<SettingsProvider>();

    final chordOffset = isInterlude ? 0.0 : -(textStyle?.fontSize ?? 0);

    String chordText = convertAccidentals(
        transpose(chord.value, lyricsController.songLyric.transposition), lyricsController.accidentals);

    int? chordNumberIndex;
    for (int i = 0; i < chordText.length; i++) {
      if (int.tryParse(chordText[i]) != null) {
        chordNumberIndex = i;
        break;
      }
    }

    return WidgetSpan(
      child: Stack(children: [
        Container(
          transform: Matrix4.translationValues(0, chordOffset, 0),
          padding: EdgeInsets.only(right: settingsProvider.fontSizeScale * kDefaultPadding / 2),
          child: chordNumberIndex == null
              ? Text(chordText, style: textStyle?.copyWith(color: appTheme.chordColor))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chordText.substring(0, chordNumberIndex),
                      style: textStyle?.copyWith(color: appTheme.chordColor),
                    ),
                    Text(
                      chordText.substring(chordNumberIndex),
                      style: textStyle?.copyWith(
                        color: appTheme.chordColor,
                        fontSize: (textStyle.fontSize ?? 17) * 0.6,
                      ),
                    ),
                  ],
                ),
        ),
        if (versePart != null) Text(versePart.value, style: textStyle),
      ]),
    );
  }

  Widget _buildAuthors(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final dataProvider = context.watch<DataProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return Text(
      lyricsController.songLyric.authorsText(dataProvider),
      style: appTheme.captionTextStyle,
      textScaleFactor: settingsProvider.fontSizeScale,
    );
  }

  TextStyle? _textStyle(BuildContext context, bool hasChords) {
    final showChords = hasChords && lyricsController.showChords;

    return AppTheme.of(context).bodyTextStyle?.copyWith(height: showChords ? 2.5 : 1.5);
  }
}
