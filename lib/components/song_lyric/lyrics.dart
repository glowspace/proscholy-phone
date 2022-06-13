import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/song_lyric/utils/converter.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/screens/song_lyric/utils/parser.dart';
import 'package:zpevnik/utils/extensions.dart';
import 'package:zpevnik/utils/hex_color.dart';

class LyricsWidget extends StatelessWidget {
  final LyricsController controller;

  const LyricsWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    final settingsProvider = context.watch<SettingsProvider>();

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                controller.songLyric.name,
                style: theme.textTheme.titleLarge,
                textScaleFactor: settingsProvider.fontSizeScale,
              ),
            ),
            SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale),
            if (controller.hasLilypond)
              SvgPicture.string(
                controller.lilypond(theme.colorScheme.onBackground.hex),
                width: min(width, controller.lilypondWidth),
              ),
            if (controller.hasLilypond) SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale / 2),
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

    Token? currentToken = controller.parser.nextToken;
    while (currentToken != null) {
      if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, false));
      } else if (currentToken is Interlude) {
        if (controller.showChords) {
          children.add(_buildInterlude(context, currentToken));
        } else {
          while (currentToken is! InterludeEnd) {
            currentToken = controller.parser.nextToken;
          }
        }
      } else if (currentToken is VerseNumber) {
        children.add(_buildVerse(context, currentToken));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale));
      }

      currentToken = controller.parser.nextToken;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildInterlude(BuildContext context, Interlude interlude) {
    final settingsProvider = context.watch<SettingsProvider>();

    final List<Widget> children = [];
    Token? currentToken = controller.parser.nextToken;
    while (currentToken != null && currentToken is! InterludeEnd) {
      if (currentToken is Chord) {
        children.add(_buildLine(context, currentToken, _textStyle(context, false), isInterlude: true));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale));
      }

      currentToken = controller.parser.nextToken;
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
    Token? currentToken = controller.parser.nextToken;
    while (currentToken != null && currentToken is! VerseEnd) {
      if (currentToken is VersePart || currentToken is Chord) {
        children.add(_buildLine(context, currentToken, textStyle));
      } else if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, number.verseHasChord));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale));
      }

      currentToken = controller.parser.nextToken;
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
        if (currentChord == null || !controller.showChords) {
          children.add(WidgetSpan(child: Text(currentToken.value, style: textStyle)));
        } else {
          children.add(_buildChord(context, currentChord, textStyle, versePart: currentToken));
          currentChord = null;
        }
      } else if (currentToken is Chord && controller.showChords) {
        if (isInterlude) {
          children.add(_buildChord(context, currentToken, textStyle, isInterlude: true));
        } else if (currentChord != null) {
          children.add(_buildChord(context, currentChord, textStyle));
        }

        currentChord = currentToken;
      }

      currentToken = controller.parser.nextToken;
    }

    if (!isInterlude && currentChord != null && controller.showChords) {
      children.add(_buildChord(context, currentChord, textStyle));
    }

    return RichText(
      text: TextSpan(text: '', style: textStyle, children: children),
      textScaleFactor: settingsProvider.fontSizeScale,
    );
  }

  Widget _buildComment(BuildContext context, Comment comment, bool hasChords) {
    final settingsProvider = context.watch<SettingsProvider>();

    final showChords = hasChords && controller.showChords;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          height: showChords ? 2.5 : 1.5,
        );

    return Text(comment.value, style: textStyle, textScaleFactor: settingsProvider.fontSizeScale);
  }

  WidgetSpan _buildChord(BuildContext context, Chord chord, TextStyle? textStyle,
      {VersePart? versePart, bool isInterlude = false}) {
    final settingsProvider = context.watch<SettingsProvider>();

    final chordOffset = isInterlude ? 0.0 : -(textStyle?.fontSize ?? 0);

    // String chordText = convertAccidentals(
    //     transpose(chord.value, controller.songLyric.transposition), controller.accidentals);
    String chordText = chord.value;

    int? chordNumberIndex;
    for (int i = 0; i < chordText.length; i++) {
      if (int.tryParse(chordText[i]) != null) {
        chordNumberIndex = i;
        break;
      }
    }

    final chordColor = Theme.of(context).brightness.isLight ? const Color(0xff3961ad) : const Color(0xff4dc0b5);

    return WidgetSpan(
      child: Stack(children: [
        Container(
          transform: Matrix4.translationValues(0, chordOffset, 0),
          padding: EdgeInsets.only(right: settingsProvider.fontSizeScale * kDefaultPadding / 2),
          child: chordNumberIndex == null
              ? Text(chordText, style: textStyle?.copyWith(color: chordColor))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chordText.substring(0, chordNumberIndex),
                      style: textStyle?.copyWith(color: chordColor),
                    ),
                    Text(
                      chordText.substring(chordNumberIndex),
                      style: textStyle?.copyWith(
                        color: chordColor,
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
    final settingsProvider = context.watch<SettingsProvider>();

    return Text(
      'Autor', //controller.songLyric.authorsText(dataProvider),
      style: Theme.of(context).textTheme.caption,
      textScaleFactor: settingsProvider.fontSizeScale,
    );
  }

  TextStyle? _textStyle(BuildContext context, bool hasChords) {
    final showChords = hasChords && controller.showChords;

    return Theme.of(context).textTheme.bodyMedium?.copyWith(height: showChords ? 2.5 : 1.5);
  }
}
