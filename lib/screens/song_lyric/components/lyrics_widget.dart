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
              Text(songLyric.name,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: AppTheme.shared.textColor(context),
                        fontSize: 1.3 * settingsProvider.fontSize,
                        fontWeight: FontWeight.bold,
                      )),
              Container(
                color: AppThemeNew.of(context).backgroundColor,
                padding: EdgeInsets.only(top: 1.5 * settingsProvider.fontSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    songLyric.verses.length,
                    (index) => _verse(context, songLyric.verses[index], settingsProvider),
                  ),
                ),
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
              Text(
                verse.number,
                style: AppThemeNew.of(context).bodyTextStyle.copyWith(
                      color: AppTheme.shared.textColor(context),
                      fontSize: settingsProvider.fontSize,
                    ),
              ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: verse.number.isEmpty ? 0 : (kDefaultPadding)),
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
        ),
      );

  InlineSpan _blocks(BuildContext context, List<Block> blocks, SettingsProvider settingsProvider) => blocks.length == 1
      ? WidgetSpan(child: _block(context, blocks[0], settingsProvider))
      : WidgetSpan(
          child: Wrap(
          children: List.generate(
            blocks.length,
            (index) => _block(context, blocks[index], settingsProvider),
          ),
        ));

  // displays block of text with chords above it
  Widget _block(BuildContext context, Block block, SettingsProvider settingsProvider) => Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Transform.translate(
            offset: Offset(0, -1.45 * settingsProvider.fontSize),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: block.shouldShowLine ? AppThemeNew.of(context).textColor : Colors.transparent,
                  ),
                ),
              ),
              child: Transform.translate(
                offset: Offset(0, -0.5 * settingsProvider.fontSize),
                child: Text(
                  block.chord,
                  style: AppThemeNew.of(context).bodyTextStyle.copyWith(
                        color: AppThemeNew.of(context).chordColor,
                        fontSize: settingsProvider.fontSize,
                        height: songLyric.showChords ? 2.4 : 1,
                      ),
                ),
              ),
            ),
          ),
          Container(
            color: AppThemeNew.of(context).backgroundColor,
            child: Text(
              block.lyricsPart,
              style: AppThemeNew.of(context).bodyTextStyle.copyWith(fontSize: settingsProvider.fontSize),
            ),
          ),
        ],
      );
}
