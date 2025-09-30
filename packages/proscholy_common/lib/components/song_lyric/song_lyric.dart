import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:proscholy_common/components/song_lyric/song_lyric_chips.dart';
import 'package:proscholy_common/components/song_lyric/utils/active_player_controller.dart';
import 'package:proscholy_common/components/song_lyric/utils/auto_scroll.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/song_lyric.dart';
import 'package:proscholy_common/providers/display_screen_status.dart';
import 'package:proscholy_common/providers/presentation.dart';
import 'package:proscholy_common/providers/settings.dart';
import 'package:proscholy_common/components/song_lyric/utils/converter.dart';
import 'package:proscholy_common/components/song_lyric/utils/lyrics_controller.dart';
import 'package:proscholy_common/components/song_lyric/utils/parser.dart';
import 'package:proscholy_common/providers/svgs.dart';
import 'package:proscholy_common/utils/extensions.dart';

class SongLyricWidget extends ConsumerStatefulWidget {
  final SongLyric songLyric;
  final AutoScrollController autoScrollController;

  const SongLyricWidget({super.key, required this.songLyric, required this.autoScrollController});

  @override
  ConsumerState<SongLyricWidget> createState() => _SongLyricWidgetState();
}

class _SongLyricWidgetState extends ConsumerState<SongLyricWidget> {
  late final controller =
      LyricsController(widget.songLyric, context.providers.read(svgProvider(widget.songLyric.id)), context);

  final _presentationPartGlobalKeysMap = <int, GlobalKey>{};

  @override
  void initState() {
    super.initState();

    // listen for changes in presented verse and make sure it is visible
    context.providers.listen(
        presentationProvider.select((presentation) =>
            presentation.isPresenting && presentation.songLyric == widget.songLyric ? presentation.part : -1),
        (_, presentationPart) {
      final context = _presentationPartGlobalKeysMap[presentationPart]?.currentContext;

      if (context != null) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.05,
          duration: kDefaultAnimationDuration,
          curve: Curves.easeInOut,
        );
      }
    });

    FirebaseAnalytics.instance.logScreenView(screenName: widget.songLyric.name);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fontSizeScaler = MediaQuery.textScalerOf(context);

    final showLilypond = ref.watch(songLyricSettingsProvider(widget.songLyric.id)
        .select((songLyricSettings) => songLyricSettings.showMusicalNotes));

    return SingleChildScrollView(
      controller: widget.autoScrollController,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: Text(widget.songLyric.displayName, style: theme.textTheme.titleLarge),
            ),
            SizedBox(height: fontSizeScaler.scale(kDefaultPadding / 2)),
            if (!widget.songLyric.hasHymnology || widget.songLyric.authors.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
                child: Text(widget.songLyric.authorsText, style: theme.textTheme.labelSmall),
              ),
              SizedBox(height: fontSizeScaler.scale(kDefaultPadding / 2)),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
              child: SongLyricChips(songLyric: widget.songLyric),
            ),
            if (controller.hasMusicNotes && showLilypond)
              ColorFiltered(
                colorFilter: Theme.of(context).brightness.isDark
                    ? const ColorFilter.matrix(<double>[
                        -1.0, 0.0, 0.0, 0.0, 255.0, //
                        0.0, -1.0, 0.0, 0.0, 255.0, //
                        0.0, 0.0, -1.0, 0.0, 255.0, //
                        0.0, 0.0, 0.0, 1.0, 0.0, //
                      ])
                    : const ColorFilter.matrix(<double>[
                        1.0, 0.0, 0.0, 0.0, 0.0, //
                        0.0, 1.0, 0.0, 0.0, 0.0, //
                        0.0, 0.0, 1.0, 0.0, 0.0, //
                        0.0, 0.0, 0.0, 1.0, 0.0, //
                      ]),
                child: ScalableImageWidget.fromSISource(
                  si: ScalableImageSource.fromSvg(controller, ''),
                  isComplex: true,
                  scale: min(MediaQuery.sizeOf(context).width, controller.musicNotesMaxWidth / (isZPS ? 1 : 2)) /
                      controller.musicNotesWidth,
                ),
              ),
            SizedBox(height: fontSizeScaler.scale(kDefaultPadding)),
            MediaQuery(
              // double the text scale factor for lyrics as they look wrong with text scale factor < 1 and minimum is 0.5
              // font size is changed according to it
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(MediaQuery.textScalerOf(context).scale(1) * 2)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
                child: _buildLyrics(context),
              ),
            ),
            SizedBox(height: fontSizeScaler.scale(kDefaultPadding)),
            // make sure lyrics are visible with bottom sheet
            SizedBox(
                height: (ref.watch(presentationProvider.select((presentation) => presentation.isPresenting)) ||
                        ref.watch(activePlayerProvider.select((activePlayer) => activePlayer != null)))
                    ? (4 * kDefaultPadding +
                        (ref.watch(displayScreenStatusProvider.select((status) => status.fullScreen))
                            ? MediaQuery.of(context).padding.bottom
                            : 0))
                    : 0),
          ],
        ),
      ),
    );
  }

  Widget _buildLyrics(BuildContext context) {
    if (!widget.songLyric.hasLyrics) return Text('Text písně připravujeme.', style: _textStyle(context, false));

    final List<Widget> children = [];

    Token? currentToken = controller.parser.nextToken;
    int presentationPart = 0;

    while (currentToken != null) {
      if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, false));
      } else if (currentToken is Interlude) {
        if (ref.watch(songLyricSettingsProvider(widget.songLyric.id)
            .select((songLyricSettings) => songLyricSettings.showChords))) {
          children.add(_buildInterlude(context, currentToken));
        } else {
          while (currentToken != null && currentToken is! InterludeEnd) {
            currentToken = controller.parser.nextToken;
          }
        }
      } else if (currentToken is VerseNumber) {
        children.add(_buildVerse(context, currentToken, presentationPart));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: MediaQuery.textScalerOf(context).scale(kDefaultPadding) / 2));
      } else if (currentToken is PresentationBreakpoint) {
        _presentationPartGlobalKeysMap.putIfAbsent(currentToken.part, () => GlobalKey());
        presentationPart = currentToken.part;
      }

      currentToken = controller.parser.nextToken;
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget _buildInterlude(BuildContext context, Interlude interlude) {
    final List<Widget> children = [];

    Token? currentToken = controller.parser.nextToken;

    while (currentToken != null && currentToken is! InterludeEnd) {
      if (currentToken is Chord) {
        children.add(
          _buildLine(context, currentToken, _textStyle(context, false), isInterlude: true),
        );
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: MediaQuery.textScalerOf(context).scale(kDefaultPadding) / 2));
      }

      currentToken = controller.parser.nextToken;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding / 2),
          child: Text(interlude.value, style: _textStyle(context, false)),
        ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)),
      ],
    );
  }

  Widget _buildVerse(BuildContext context, VerseNumber number, int presentationPart) {
    final textStyle = _textStyle(context, number.verseHasChord);

    final List<Widget> children = [];
    final originalPresentationPart = presentationPart;

    Token? currentToken = controller.parser.nextToken;
    bool isFirstLine = true;

    while (currentToken != null && currentToken is! VerseEnd) {
      if (currentToken is VersePart || currentToken is Chord) {
        children.add(
          _buildLine(context, currentToken, textStyle, presentationPart: presentationPart, isFirst: isFirstLine),
        );
        isFirstLine = false;
      } else if (currentToken is Comment) {
        children.add(_buildComment(context, currentToken, number.verseHasChord));
      } else if (currentToken is NewLine) {
        children.add(SizedBox(height: MediaQuery.textScalerOf(context).scale(kDefaultPadding) / 2));
      } else if (currentToken is PresentationBreakpoint) {
        _presentationPartGlobalKeysMap.putIfAbsent(currentToken.part, () => GlobalKey());
        presentationPart = currentToken.part;
        isFirstLine = true;
      }

      currentToken = controller.parser.nextToken;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number.value.isNotEmpty)
          Container(
            color: ref.watch(presentationProvider.select(
                    (presentation) => presentation.isPresenting && presentation.part == originalPresentationPart))
                ? Theme.of(context).colorScheme.secondaryContainer
                : null,
            padding: const EdgeInsets.only(right: kDefaultPadding / 2),
            child: Text(number.value, style: textStyle),
          ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)),
      ],
    );
  }

  Widget _buildLine(
    BuildContext context,
    Token token,
    TextStyle? textStyle, {
    int? presentationPart,
    bool? isFirst,
    bool isInterlude = false,
  }) {
    final List<InlineSpan> children = [];

    Token? currentToken = token;
    Chord? currentChord;
    while (currentToken != null && currentToken is! NewLine) {
      if (currentToken is VersePart) {
        if (currentChord == null ||
            ref.watch(songLyricSettingsProvider(widget.songLyric.id)
                .select((songLyricSettings) => !songLyricSettings.showChords))) {
          children.add(WidgetSpan(child: Text(currentToken.value, style: textStyle)));
        } else {
          children.add(_buildChord(context, currentChord, textStyle, versePart: currentToken));
          currentChord = null;
        }
      } else if (currentToken is Chord &&
          ref.watch(songLyricSettingsProvider(widget.songLyric.id)
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
        ref.watch(songLyricSettingsProvider(widget.songLyric.id)
            .select((songLyricSettings) => songLyricSettings.showChords))) {
      children.add(_buildChord(context, currentChord, textStyle));
    }

    return GestureDetector(
      onTap: ref.watch(presentationProvider.select((presentation) => presentation.isPresenting))
          ? () => ref.read(presentationProvider.notifier).changePart(presentationPart!)
          : null,
      child: Container(
        color: ref.watch(presentationProvider
                .select((presentation) => presentation.isPresenting && presentation.part == presentationPart))
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        child: RichText(
          key: (!isInterlude && isFirst!) ? _presentationPartGlobalKeysMap[presentationPart] : null,
          text: TextSpan(style: textStyle, children: children),
        ),
      ),
    );
  }

  Widget _buildComment(BuildContext context, Comment comment, bool hasChords) {
    final showChords = hasChords &&
        ref.watch(
            songLyricSettingsProvider(widget.songLyric.id).select((songLyricSettings) => songLyricSettings.showChords));
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 8,
          fontStyle: FontStyle.italic,
          height: showChords ? 2.5 : 1.5,
        );

    return Text(comment.value, style: textStyle);
  }

  WidgetSpan _buildChord(
    BuildContext context,
    Chord chord,
    TextStyle? textStyle, {
    VersePart? versePart,
    bool isInterlude = false,
  }) {
    final chordOffset = isInterlude || textStyle?.fontSize == null
        ? 0.0
        : -2 * MediaQuery.textScalerOf(context).scale(textStyle!.fontSize!);

    String chordText = convertAccidentals(
        transpose(
            chord.value,
            ref.watch(songLyricSettingsProvider(widget.songLyric.id)
                .select((songLyricSettings) => songLyricSettings.transposition))),
        ref.watch(songLyricSettingsProvider(widget.songLyric.id)
            .select((songLyricSettings) => songLyricSettings.accidentals ?? widget.songLyric.defaultAccidentals)));

    final chordColor = Theme.of(context).colorScheme.primary;

    final majIndex = chordText.indexOf('maj');
    final susIndex = chordText.indexOf('sus');

    bool shouldBeSuperscript(int index) {
      return (majIndex != -1 && index >= majIndex && index < majIndex + 3) ||
          (susIndex != -1 && index >= susIndex && index < susIndex + 3) ||
          int.tryParse(chordText[index]) != null;
    }

    return WidgetSpan(
      child: Stack(children: [
        Container(
          transform: Matrix4.translationValues(0, chordOffset, 0),
          padding: EdgeInsets.only(right: MediaQuery.textScalerOf(context).scale(kDefaultPadding) / 2),
          child: Text.rich(TextSpan(children: [
            for (int i = 0; i < chordText.length; i++)
              TextSpan(
                text: chordText[i],
                style: textStyle?.copyWith(
                  color: chordColor,
                  fontFeatures: [if (shouldBeSuperscript(i)) FontFeature.superscripts()],
                ),
              )
          ])),
        ),
        if (versePart != null) Text(versePart.value, style: textStyle),
      ]),
    );
  }

  TextStyle? _textStyle(BuildContext context, bool hasChords) {
    final showChords = hasChords &&
        ref.watch(
            songLyricSettingsProvider(widget.songLyric.id).select((songLyricSettings) => songLyricSettings.showChords));

    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 8,
          height: showChords ? 2.25 : 1.5,
        );
  }
}
