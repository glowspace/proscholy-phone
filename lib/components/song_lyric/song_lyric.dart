import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zpevnik/components/song_lyric/song_lyric_chips.dart';
import 'package:zpevnik/components/song_lyric/utils/auto_scroll.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/components/song_lyric/utils/converter.dart';
import 'package:zpevnik/components/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';
import 'package:zpevnik/utils/extensions.dart';

class SongLyricWidget extends ConsumerStatefulWidget {
  final SongLyric songLyric;
  final AutoScrollController autoScrollController;

  const SongLyricWidget({super.key, required this.songLyric, required this.autoScrollController});

  @override
  ConsumerState<SongLyricWidget> createState() => _SongLyricWidgetState();
}

class _SongLyricWidgetState extends ConsumerState<SongLyricWidget> {
  late final controller = LyricsController(widget.songLyric, context);

  @override
  void initState() {
    super.initState();

    controller.addListener(_update);
  }

  @override
  void dispose() {
    super.dispose();

    controller.removeListener(_update);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    controller.updateLilypondColor(Theme.of(context).colorScheme.onBackground.hex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    final fontSizeScale = ref.watch(settingsProvider.select((settings) => settings.fontSizeScale));

    final showLilypond = ref.watch(
        songLyricSettingsProvider(widget.songLyric).select((songLyricSettings) => songLyricSettings.showMusicalNotes));

    return SingleChildScrollView(
      controller: widget.autoScrollController,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: Text(
                controller.songLyric.name,
                style: theme.textTheme.titleLarge,
                textScaleFactor: fontSizeScale,
              ),
            ),
            SizedBox(height: kDefaultPadding / 2 * fontSizeScale),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: Text(
                controller.songLyric.authorsText,
                style: theme.textTheme.labelSmall,
                textScaleFactor: fontSizeScale,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: SongLyricChips(songLyric: widget.songLyric),
            ),
            if (controller.hasLilypond && showLilypond)
              SvgPicture.string(
                alignment: Alignment.centerLeft,
                controller.lilypond(theme.colorScheme.onBackground.hex),
                width: min(width, controller.lilypondWidth),
              ),
            SizedBox(height: kDefaultPadding * fontSizeScale),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: _buildLyrics(context),
            ),
            SizedBox(height: kDefaultPadding * fontSizeScale),
          ],
        ),
      ),
    );
  }

  Widget _buildLyrics(BuildContext context) {
    final fontSizeScale = ref.watch(settingsProvider.select((settings) => settings.fontSizeScale));

    final List<Widget> children = [];

    Token? currentToken = controller.parser.nextToken;
    while (currentToken != null) {
      if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, false));
      } else if (currentToken is Interlude) {
        if (ref.watch(songLyricSettingsProvider(controller.songLyric)
            .select((songLyricSettings) => songLyricSettings.showChords))) {
          children.add(_buildInterlude(context, currentToken));
        } else {
          while (currentToken != null && currentToken is! InterludeEnd) {
            currentToken = controller.parser.nextToken;
          }
        }
      } else if (currentToken is VerseNumber) {
        children.add(_buildVerse(context, currentToken));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * fontSizeScale));
      }

      currentToken = controller.parser.nextToken;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildInterlude(BuildContext context, Interlude interlude) {
    final fontSizeScale = ref.watch(settingsProvider.select((settings) => settings.fontSizeScale));

    final List<Widget> children = [];
    Token? currentToken = controller.parser.nextToken;
    while (currentToken != null && currentToken is! InterludeEnd) {
      if (currentToken is Chord) {
        children.add(_buildLine(context, currentToken, _textStyle(context, false), isInterlude: true));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * fontSizeScale));
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
            textScaleFactor: fontSizeScale,
          ),
        ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)),
      ],
    );
  }

  Widget _buildVerse(BuildContext context, VerseNumber number) {
    final fontSizeScale = ref.watch(settingsProvider.select((settings) => settings.fontSizeScale));

    final textStyle = _textStyle(context, number.verseHasChord);

    final List<Widget> children = [];
    Token? currentToken = controller.parser.nextToken;
    while (currentToken != null && currentToken is! VerseEnd) {
      if (currentToken is VersePart || currentToken is Chord) {
        children.add(_buildLine(context, currentToken, textStyle));
      } else if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, number.verseHasChord));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: kDefaultPadding * fontSizeScale));
      }

      currentToken = controller.parser.nextToken;
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
    final fontSizeScale = ref.watch(settingsProvider.select((settings) => settings.fontSizeScale));

    final List<InlineSpan> children = [];

    Token? currentToken = token;
    Chord? currentChord;
    while (currentToken != null && currentToken is! NewLine) {
      if (currentToken is VersePart) {
        if (currentChord == null ||
            ref.watch(songLyricSettingsProvider(controller.songLyric)
                .select((songLyricSettings) => !songLyricSettings.showChords))) {
          children.add(WidgetSpan(child: Text(currentToken.value, style: textStyle)));
        } else {
          children.add(_buildChord(context, currentChord, textStyle, versePart: currentToken));
          currentChord = null;
        }
      } else if (currentToken is Chord &&
          ref.watch(songLyricSettingsProvider(controller.songLyric)
              .select((songLyricSettings) => songLyricSettings.showChords))) {
        if (isInterlude) {
          children.add(_buildChord(context, currentToken, textStyle, isInterlude: true));
        } else if (currentChord != null) {
          children.add(_buildChord(context, currentChord, textStyle));
        }

        currentChord = currentToken;
      }

      currentToken = controller.parser.nextToken;
    }

    if (!isInterlude &&
        currentChord != null &&
        ref.watch(songLyricSettingsProvider(controller.songLyric)
            .select((songLyricSettings) => songLyricSettings.showChords))) {
      children.add(_buildChord(context, currentChord, textStyle));
    }

    return RichText(
      text: TextSpan(text: '', style: textStyle, children: children),
      textScaleFactor: fontSizeScale,
    );
  }

  Widget _buildComment(BuildContext context, Comment comment, bool hasChords) {
    final fontSizeScale = ref.watch(settingsProvider.select((settings) => settings.fontSizeScale));

    final showChords = hasChords &&
        ref.watch(songLyricSettingsProvider(controller.songLyric)
            .select((songLyricSettings) => songLyricSettings.showChords));
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontStyle: FontStyle.italic,
          height: showChords ? 2.5 : 1.5,
        );

    return Text(comment.value, style: textStyle, textScaleFactor: fontSizeScale);
  }

  WidgetSpan _buildChord(BuildContext context, Chord chord, TextStyle? textStyle,
      {VersePart? versePart, bool isInterlude = false}) {
    final fontSizeScale = ref.watch(settingsProvider.select((settings) => settings.fontSizeScale));

    final chordOffset = isInterlude ? 0.0 : -(textStyle?.fontSize ?? 0);

    String chordText = convertAccidentals(
        transpose(
            chord.value,
            ref.watch(songLyricSettingsProvider(controller.songLyric)
                .select((songLyricSettings) => songLyricSettings.transposition))),
        ref.watch(songLyricSettingsProvider(controller.songLyric)
            .select((songLyricSettings) => songLyricSettings.accidentals)));

    int chordNumberIndex = chordText.indexOf('maj');
    if (chordNumberIndex == -1) {
      for (int i = 0; i < chordText.length; i++) {
        if (int.tryParse(chordText[i]) != null) {
          chordNumberIndex = i;
          break;
        }
      }
    }

    final chordColor = Theme.of(context).brightness.isLight ? const Color(0xff3961ad) : const Color(0xff4dc0b5);

    return WidgetSpan(
      child: Stack(children: [
        Container(
          transform: Matrix4.translationValues(0, chordOffset, 0),
          padding: EdgeInsets.only(right: fontSizeScale * kDefaultPadding / 2),
          child: chordNumberIndex == -1
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

  TextStyle? _textStyle(BuildContext context, bool hasChords) {
    final showChords = hasChords &&
        ref.watch(songLyricSettingsProvider(controller.songLyric)
            .select((songLyricSettings) => songLyricSettings.showChords));

    return Theme.of(context).textTheme.bodyMedium?.copyWith(height: showChords ? 2.5 : 1.5);
  }

  void _update() => setState(() {});
}
