import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/components/filters/filter_tag.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_tag.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/components/song_lyric/utils/converter.dart';
import 'package:zpevnik/components/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/utils/extensions.dart';

class LyricsWidget extends StatefulWidget {
  final LyricsController controller;
  final ScrollController? scrollController;

  const LyricsWidget({Key? key, required this.controller, this.scrollController}) : super(key: key);

  @override
  State<LyricsWidget> createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_update);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.controller.updateLilypondColor(Theme.of(context).colorScheme.onBackground.hex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: Text(
                widget.controller.songLyric.name,
                style: theme.textTheme.titleLarge,
                textScaleFactor: fontSizeScale,
              ),
            ),
            if (widget.controller.hasLilypond)
              SvgPicture.string(
                widget.controller.lilypond(theme.colorScheme.onBackground.hex),
                width: min(width, widget.controller.lilypondWidth),
              ),
            if (widget.controller.hasLilypond) SizedBox(height: kDefaultPadding * fontSizeScale / 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: _buildLyrics(context),
            ),
            SizedBox(height: kDefaultPadding * fontSizeScale),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: _buildAuthors(context),
            ),
            SizedBox(height: kDefaultPadding * fontSizeScale),
          ],
        ),
      ),
    );
  }

  Widget _buildLyrics(BuildContext context) {
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    final List<Widget> children = [];

    Token? currentToken = widget.controller.parser.nextToken;
    while (currentToken != null) {
      if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, false));
      } else if (currentToken is Interlude) {
        if (widget.controller.showChords) {
          children.add(_buildInterlude(context, currentToken));
        } else {
          while (currentToken is! InterludeEnd) {
            currentToken = widget.controller.parser.nextToken;
          }
        }
      } else if (currentToken is VerseNumber) {
        children.add(_buildVerse(context, currentToken));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * fontSizeScale));
      }

      currentToken = widget.controller.parser.nextToken;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildInterlude(BuildContext context, Interlude interlude) {
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    final List<Widget> children = [];
    Token? currentToken = widget.controller.parser.nextToken;
    while (currentToken != null && currentToken is! InterludeEnd) {
      if (currentToken is Chord) {
        children.add(_buildLine(context, currentToken, _textStyle(context, false), isInterlude: true));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * fontSizeScale));
      }

      currentToken = widget.controller.parser.nextToken;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding / 2),
          child: Text(
            interlude.value,
            style: _textStyle(context, false),
            textScaleFactor: fontSizeScale,
          ),
        ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
      ],
    );
  }

  Widget _buildVerse(BuildContext context, VerseNumber number) {
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    final textStyle = _textStyle(context, number.verseHasChord);

    final List<Widget> children = [];
    Token? currentToken = widget.controller.parser.nextToken;
    while (currentToken != null && currentToken is! VerseEnd) {
      if (currentToken is VersePart || currentToken is Chord) {
        children.add(_buildLine(context, currentToken, textStyle));
      } else if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, number.verseHasChord));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * fontSizeScale));
      }

      currentToken = widget.controller.parser.nextToken;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding / 2),
            child: Text(number.value, style: textStyle, textScaleFactor: fontSizeScale),
          ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
      ],
    );
  }

  Widget _buildLine(BuildContext context, Token token, TextStyle? textStyle, {bool isInterlude = false}) {
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    final List<InlineSpan> children = [];

    Token? currentToken = token;
    Chord? currentChord;
    while (currentToken != null && currentToken is! NewLine) {
      if (currentToken is VersePart) {
        if (currentChord == null || !widget.controller.showChords) {
          children.add(WidgetSpan(child: Text(currentToken.value, style: textStyle)));
        } else {
          children.add(_buildChord(context, currentChord, textStyle, versePart: currentToken));
          currentChord = null;
        }
      } else if (currentToken is Chord && widget.controller.showChords) {
        if (isInterlude) {
          children.add(_buildChord(context, currentToken, textStyle, isInterlude: true));
        } else if (currentChord != null) {
          children.add(_buildChord(context, currentChord, textStyle));
        }

        currentChord = currentToken;
      }

      currentToken = widget.controller.parser.nextToken;
    }

    if (!isInterlude && currentChord != null && widget.controller.showChords) {
      children.add(_buildChord(context, currentChord, textStyle));
    }

    return RichText(
      text: TextSpan(text: '', style: textStyle, children: children),
      textScaleFactor: fontSizeScale,
    );
  }

  Widget _buildComment(BuildContext context, Comment comment, bool hasChords) {
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    final showChords = hasChords && widget.controller.showChords;
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontStyle: FontStyle.italic,
          height: showChords ? 2.5 : 1.5,
        );

    return Text(comment.value, style: textStyle, textScaleFactor: fontSizeScale);
  }

  WidgetSpan _buildChord(BuildContext context, Chord chord, TextStyle? textStyle,
      {VersePart? versePart, bool isInterlude = false}) {
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    final chordOffset = isInterlude ? 0.0 : -(textStyle?.fontSize ?? 0);

    String chordText = convertAccidentals(
        transpose(chord.value, widget.controller.songLyric.transposition), widget.controller.accidentals);

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
          padding: EdgeInsets.only(right: fontSizeScale * kDefaultPadding / 2),
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
    final fontSizeScale = context.select<SettingsProvider, double>((provider) => provider.fontSizeScale);

    return Text(
      widget.controller.songLyric.authorsText,
      style: Theme.of(context).textTheme.labelMedium,
      textScaleFactor: fontSizeScale,
    );
  }

  TextStyle? _textStyle(BuildContext context, bool hasChords) {
    final showChords = hasChords && widget.controller.showChords;

    return Theme.of(context).textTheme.bodyMedium?.copyWith(height: showChords ? 2.5 : 1.5);
  }

  void _update() => setState(() {});
}
