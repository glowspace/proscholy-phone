import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/song_lyric/utils/parser.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/hex_color.dart';

class LyricsWidget extends StatelessWidget {
  final SongLyricsParser parser;

  const LyricsWidget({Key? key, required this.parser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final settingsProvider = context.watch<SettingsProvider>();

    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              parser.songLyric.name,
              style: appTheme.titleTextStyle,
              textScaleFactor: settingsProvider.fontSizeScale,
            ),
            SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale),
            if (parser.hasLilypond)
              SvgPicture.string(
                parser.lilypond(appTheme.textColor.hex),
                width: min(width - 2 * kDefaultPadding, parser.lilypondWidth),
              ),
            if (parser.hasLilypond) SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale / 2),
            _buildLyrics(context),
            SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale),
            _buildAuthors(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLyrics(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final settingsProvider = context.read<SettingsProvider>();

    final List<Widget> children = [];

    Token? currentToken = parser.nextToken;
    while (currentToken != null) {
      if (currentToken is Comment) {
        children.add(Text(
          currentToken.value,
          style: appTheme.commentTextStyle,
          textScaleFactor: settingsProvider.fontSizeScale,
        ));
      } else if (currentToken is Interlude) {
        children.add(_buildInterlude(context, currentToken));
      } else if (currentToken is VerseNumber) {
        children.add(_buildVerse(context, currentToken));
      }

      currentToken = parser.nextToken;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildInterlude(BuildContext context, Interlude interlude) {
    final settingsProvider = context.read<SettingsProvider>();

    final List<Widget> children = [];
    Token? currentToken = parser.nextToken;
    while (currentToken != null && currentToken is! InterludeEnd) {
      if (currentToken is Chord) {
        children.add(_buildLine(context, currentToken, isInterlude: true));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale));
      }

      currentToken = parser.nextToken;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding / 2),
          child: Text(
            interlude.value,
            style: _textStyle(context),
            textScaleFactor: settingsProvider.fontSizeScale,
          ),
        ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
      ],
    );
  }

  Widget _buildVerse(BuildContext context, VerseNumber number) {
    final settingsProvider = context.read<SettingsProvider>();

    final List<Widget> children = [];
    Token? currentToken = parser.nextToken;
    while (currentToken != null && currentToken is! VerseEnd) {
      if (currentToken is VersePart || currentToken is Chord) {
        children.add(_buildLine(context, currentToken));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * settingsProvider.fontSizeScale));
      }

      currentToken = parser.nextToken;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding / 2),
            child: Text(
              number.value,
              style: _textStyle(context),
              textScaleFactor: settingsProvider.fontSizeScale,
            ),
          ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
      ],
    );
  }

  Widget _buildLine(BuildContext context, Token token, {bool isInterlude = false}) {
    final settingsProvider = context.read<SettingsProvider>();

    final List<InlineSpan> children = [];

    Token? currentToken = token;
    Chord? currentChord;
    while (currentToken != null && currentToken is! NewLine) {
      if (currentToken is VersePart) {
        if (currentChord == null) {
          children.add(TextSpan(text: currentToken.value));
        } else {
          children.add(_buildChord(context, currentChord, versePart: currentToken));
          currentChord = null;
        }
      } else if (currentToken is Chord) {
        if (isInterlude) {
          children.add(_buildChord(context, currentToken, isInterlude: true));
        } else if (currentChord != null) {
          children.add(_buildChord(context, currentChord));
        }

        currentChord = currentToken;
      }

      currentToken = parser.nextToken;
    }

    if (!isInterlude && currentChord != null) {
      children.add(_buildChord(context, currentChord));
    }

    return RichText(
      text: TextSpan(text: '', style: _textStyle(context), children: children),
      textScaleFactor: settingsProvider.fontSizeScale,
    );
  }

  WidgetSpan _buildChord(BuildContext context, Chord chord, {VersePart? versePart, bool isInterlude = false}) {
    final appTheme = AppTheme.of(context);
    final settingsProvider = context.read<SettingsProvider>();

    final textStyle = _textStyle(context);

    final chordOffset = isInterlude ? 0.0 : -(textStyle?.fontSize ?? 0);

    int? chordNumberIndex;
    for (int i = 0; i < chord.value.length; i++) {
      if (int.tryParse(chord.value[i]) != null) {
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
              ? Text(chord.value, style: textStyle?.copyWith(color: appTheme.chordColor))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chord.value.substring(0, chordNumberIndex),
                      style: textStyle?.copyWith(color: appTheme.chordColor),
                    ),
                    Text(
                      chord.value.substring(chordNumberIndex),
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
      parser.songLyric.authorsText(dataProvider),
      style: appTheme.captionTextStyle,
      textScaleFactor: settingsProvider.fontSizeScale,
    );
  }

  TextStyle? _textStyle(BuildContext context) {
    // TODO: hasChords check should be done for every single line independently
    return AppTheme.of(context).bodyTextStyle?.copyWith(height: parser.hasChords ? 2.5 : 1.5);
  }
}
