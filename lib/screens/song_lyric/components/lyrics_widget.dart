import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/settings_provider.dart';
import 'package:zpevnik/theme.dart';

final _colorRE = RegExp(r'Color\(0xff(.+)\)');

class LyricsWidget extends StatefulWidget {
  final SongLyric songLyric;

  const LyricsWidget({Key key, this.songLyric}) : super(key: key);

  @override
  _LyricsWidgetState createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget> {
  String _preparedLilyPond;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    _preparedLilyPond ??= widget.songLyric.lilypond?.replaceAll(
        'currentColor', appTheme.textColor.toString().replaceAllMapped(_colorRE, (match) => '#${match.group(1)}'));

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(text: widget.songLyric.displayName, style: appTheme.titleTextStyle),
              textScaleFactor: settingsProvider.fontSizeScale,
            ),
            if (_preparedLilyPond != null)
              SvgPicture.string(_preparedLilyPond, width: MediaQuery.of(context).size.width),
            Container(
              color: appTheme.backgroundColor,
              padding: EdgeInsets.only(top: kDefaultPadding * settingsProvider.fontSizeScale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.songLyric.verses.length,
                  (index) => _verse(context, widget.songLyric.verses[index], settingsProvider),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                text: widget.songLyric.authorsText,
                style: appTheme.captionTextStyle,
              ),
              textScaleFactor: settingsProvider.fontSizeScale,
            ),
          ],
        ),
      ),
    );
  }

  Container _verse(BuildContext context, Verse verse, SettingsProvider settingsProvider) => Container(
        padding: verse.isComment ? null : EdgeInsets.only(bottom: 2 * kDefaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (verse.number.isNotEmpty)
              RichText(
                text: TextSpan(text: '', children: [
                  WidgetSpan(
                    child: RichText(
                      text: TextSpan(
                        text: verse.number,
                        style: AppTheme.of(context).bodyTextStyle.copyWith(
                              height: (widget.songLyric.showChords ? 2.25 : 1.5),
                            ),
                      ),
                    ),
                  ),
                ]),
                textScaleFactor: settingsProvider.fontSizeScale,
              ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(
                  left: verse.number.isEmpty ? 0 : (kDefaultPadding * settingsProvider.fontSizeScale),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    verse.lines.length,
                    (index) => _line(context, verse.lines[index], settingsProvider, verse.isComment),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _line(BuildContext context, Line line, SettingsProvider settingsProvider, bool isComment) => RichText(
        text: TextSpan(
          text: '',
          children: List.generate(
            line.groupedBlocks.length,
            (index) => _blocks(context, line.groupedBlocks[index], settingsProvider, isComment),
          ),
          style: AppTheme.of(context).bodyTextStyle,
        ),
        textScaleFactor: settingsProvider.fontSizeScale,
      );

  InlineSpan _blocks(BuildContext context, List<Block> blocks, SettingsProvider settingsProvider, bool isComment) =>
      blocks.length == 1
          ? (blocks[0].chord.isEmpty
              ? WidgetSpan(
                  child: RichText(
                    text: TextSpan(
                      text: blocks[0].lyricsPart,
                      style: (isComment ? AppTheme.of(context).commentTextStyle : AppTheme.of(context).bodyTextStyle)
                          .copyWith(height: (widget.songLyric.showChords ? 2.25 : 1.5)),
                    ),
                  ),
                )
              : WidgetSpan(child: _block(context, blocks[0], settingsProvider)))
          : WidgetSpan(
              child: Wrap(
              children: List.generate(
                blocks.length,
                (index) => _block(context, blocks[index], settingsProvider),
              ),
            ));

  Widget _block(BuildContext context, Block block, SettingsProvider settingsProvider) => Stack(
        children: [
          if (widget.songLyric.showChords)
            Transform.translate(
              offset: Offset(0, block.isInterlude ? 0 : -3),
              child: Container(
                // todo: disable line between divided word

                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(
                //         color: block.shouldShowLine ? appTheme.textColor : Colors.transparent),
                //   ),
                // ),
                child: Transform.translate(
                  offset: Offset(0, block.isInterlude ? 0 : -(AppTheme.of(context).bodyTextStyle.fontSize - 3)),
                  child: RichText(
                    text: TextSpan(
                      text: block.chord + (block.chord.length >= block.lyricsPart.trim().length ? ' ' : ''),
                      style: AppTheme.of(context).bodyTextStyle.copyWith(
                            color: AppTheme.of(context).chordColor,
                            height: (widget.songLyric.showChords ? 2.25 : 1.5),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          Transform.translate(
            offset: Offset(0, 0), // because of the border
            child: Container(
              child: RichText(
                text: TextSpan(
                  text: block.lyricsPart,
                  style:
                      AppTheme.of(context).bodyTextStyle.copyWith(height: (widget.songLyric.showChords ? 2.25 : 1.5)),
                ),
              ),
            ),
          )
        ],
      );
}
