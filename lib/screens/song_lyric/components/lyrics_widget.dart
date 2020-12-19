import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/settings_provider.dart';
import 'package:zpevnik/theme.dart';

class LyricsWidget extends StatelessWidget {
  final SongLyric songLyric;

  const LyricsWidget({Key key, this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(text: songLyric.displayName, style: AppTheme.of(context).titleTextStyle),
                textScaleFactor: settingsProvider.fontSizeScale,
              ),
              Container(
                color: AppTheme.of(context).backgroundColor,
                padding: EdgeInsets.only(top: kDefaultPadding * settingsProvider.fontSizeScale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    songLyric.verses.length,
                    (index) => _verse(context, songLyric.verses[index], settingsProvider),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(text: songLyric.authorsText, style: AppTheme.of(context).bodyTextStyle),
                textScaleFactor: settingsProvider.fontSizeScale,
              ),
            ],
          ),
        ),
      );

  Container _verse(BuildContext context, Verse verse, SettingsProvider settingsProvider) => Container(
        padding: EdgeInsets.only(bottom: kDefaultPadding),
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
                              height: (songLyric.showChords ? 2.25 : 1.5),
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
                    (index) => _line(context, verse.lines[index], settingsProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _line(BuildContext context, Line line, SettingsProvider settingsProvider) => RichText(
        text: TextSpan(
          text: '',
          children: List.generate(
            line.groupedBlocks.length,
            (index) => _blocks(context, line.groupedBlocks[index], settingsProvider),
          ),
          style: AppTheme.of(context).bodyTextStyle,
        ),
        textScaleFactor: settingsProvider.fontSizeScale,
      );

  InlineSpan _blocks(BuildContext context, List<Block> blocks, SettingsProvider settingsProvider) => blocks.length == 1
      ? (blocks[0].chord.isEmpty
          ? WidgetSpan(
              child: RichText(
                text: TextSpan(
                  text: blocks[0].lyricsPart,
                  style: AppTheme.of(context).bodyTextStyle.copyWith(height: (songLyric.showChords ? 2.25 : 1.5)),
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

  // displays block of text with chords above it
  Widget _block(BuildContext context, Block block, SettingsProvider settingsProvider) => Stack(
        children: [
          if (songLyric.showChords)
            Transform.translate(
              offset: Offset(0, -3),
              child: Container(
                // todo: disable line between divided word

                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(
                //         color: block.shouldShowLine ? AppTheme.of(context).textColor : Colors.transparent),
                //   ),
                // ),
                child: Transform.translate(
                  offset: Offset(0, -(AppTheme.of(context).bodyTextStyle.fontSize - 3)),
                  child: RichText(
                    text: TextSpan(
                      text: block.chord,
                      style: AppTheme.of(context).bodyTextStyle.copyWith(
                            color: AppTheme.of(context).chordColor,
                            height: (songLyric.showChords ? 2.25 : 1.5),
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
                  style: AppTheme.of(context).bodyTextStyle.copyWith(height: (songLyric.showChords ? 2.25 : 1.5)),
                ),
              ),
            ),
          )
        ],
      );
}
