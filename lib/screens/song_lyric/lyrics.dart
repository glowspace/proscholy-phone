import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/settings.dart';
import 'package:zpevnik/screens/song_lyric/utils/lyrics_controller.dart';
import 'package:zpevnik/screens/song_lyric/utils/parser.dart';
import 'package:zpevnik/screens/utils/updateable.dart';
import 'package:zpevnik/theme.dart';

class LyricsWidget extends StatefulWidget {
  final LyricsController controller;
  final ScrollController? scrollController;

  const LyricsWidget({Key? key, required this.controller, this.scrollController}) : super(key: key);

  @override
  _LyricsWidgetState createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget> with Updateable {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    Widget lyrics = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(),
        if (controller.hasLilypond && !widget.controller.isProjectionEnabled)
          SvgPicture.string(
            controller.prepareLilypond(AppTheme.of(context).textColor),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        if (widget.controller.isProjectionEnabled) Expanded(child: _buildLyrics()) else _buildLyrics(),
      ],
    );

    if (!widget.controller.isProjectionEnabled)
      lyrics = Scrollbar(
        child: SingleChildScrollView(controller: widget.scrollController, child: lyrics),
      );

    return Container(child: lyrics);
  }

  Widget _buildTitle() {
    final settingsProvider = context.watch<SettingsProvider>();

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: RichText(
        text: TextSpan(
          text: widget.controller.title,
          style: AppTheme.of(context).titleTextStyle,
        ),
        textScaleFactor: settingsProvider.fontSizeScale,
      ),
    );
  }

  Widget _buildLyrics() {
    final verses = widget.controller.preparedLyrics;
    final isProjectionEnabled = widget.controller.isProjectionEnabled;

    final children = List<Widget>.empty(growable: true);

    if (isProjectionEnabled)
      children.add(_buildVerse(verses[widget.controller.currentlyProjectedVerse]));
    else
      children.addAll(verses.map((verse) => _buildVerse(verse)));

    if (!isProjectionEnabled) children.add(_buildAuthors());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      margin: EdgeInsets.only(bottom: 2 * kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _buildAuthors() {
    final appTheme = AppTheme.of(context);
    final dataProvider = context.watch<DataProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return RichText(
      text: TextSpan(
        text: widget.controller.songLyric.authorsText(dataProvider),
        style: appTheme.captionTextStyle,
      ),
      textScaleFactor: settingsProvider.fontSizeScale,
    );
  }

  Widget _buildVerse(Verse verse) {
    final verseNumber = verse.number;
    final settingsProvider = context.watch<SettingsProvider>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (verseNumber != null)
          SizedBox(
            width: (settingsProvider.fontSizeScale + 0.5) * kDefaultPadding,
            child: RichText(
              text: TextSpan(text: verseNumber, style: _textStyle(verse.hasChords)),
              textScaleFactor: settingsProvider.fontSizeScale,
            ),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: verse.lines.map((line) => _buildLine(line, verse.hasChords)).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildLine(Line line, bool hasChords) {
    final settingsProvider = context.watch<SettingsProvider>();

    return RichText(
      text: TextSpan(
        text: '',
        children: _buildBlocks(line.blocks, hasChords),
      ),
      textScaleFactor: settingsProvider.fontSizeScale,
    );
  }

  List<InlineSpan> _buildBlocks(List<Block> blocks, bool hasChords) {
    final spans = List<InlineSpan>.empty(growable: true);

    List<Widget> groupedBlocks = [];
    for (final block in blocks) {
      groupedBlocks.add(_buildBlock(block, hasChords));

      if (!block.endsInWordMiddle) {
        spans.add(WidgetSpan(child: Wrap(children: groupedBlocks)));

        groupedBlocks = [];
      }
    }

    return spans;
  }

  Widget _buildBlock(Block block, bool hasChords) {
    final textStyle = _textStyle(hasChords, isComment: block.isComment);
    final chordColor = AppTheme.of(context).chordColor;

    final chordOffset = block.isInterlude ? 0.0 : -(textStyle?.fontSize ?? 0);

    return Stack(
      children: [
        if (block.chord != null)
          Container(
            transform: Matrix4.translationValues(0, chordOffset, 0),
            padding: EdgeInsets.only(right: 0.5 * kDefaultPadding),
            child: RichText(text: TextSpan(text: block.updatedChord, style: textStyle?.copyWith(color: chordColor))),
          ),
        RichText(text: TextSpan(text: block.lyricsPart, style: textStyle)),
      ],
    );
  }

  TextStyle? _textStyle(bool hasChords, {bool isComment = false}) {
    final appTheme = AppTheme.of(context);
    final textStyle = isComment ? appTheme.commentTextStyle : appTheme.bodyTextStyle;

    return textStyle?.copyWith(height: hasChords ? 2.5 : 1.5);
  }

  @override
  List<Listenable> get listenables => [widget.controller];
}
