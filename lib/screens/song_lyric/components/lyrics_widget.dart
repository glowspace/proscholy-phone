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
                        fontSize: 1.3 * SettingsProvider.shared.fontSize,
                        fontWeight: FontWeight.bold,
                      )),
              Container(
                padding: EdgeInsets.only(top: 1.5 * SettingsProvider.shared.fontSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    songLyric.verses.length,
                    (index) => _verse(context, songLyric.verses[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Container _verse(BuildContext context, Verse verse) => Container(
        padding: EdgeInsets.only(bottom: kDefaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (verse.number.isNotEmpty)
              Text(
                verse.number,
                style: AppThemeNew.of(context).bodyTextStyle.copyWith(
                      color: AppTheme.shared.textColor(context),
                      fontSize: SettingsProvider.shared.fontSize,
                    ),
              ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: verse.number.isEmpty ? 0 : (kDefaultPadding / 2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    verse.lines.length,
                    (index) => _line(context, verse.lines[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _line(BuildContext context, Line line) => RichText(
        text: TextSpan(
          text: '',
          children: List.generate(
            line.groupedBlocks.length,
            (index) => _blocks(context, line.groupedBlocks[index]),
          ),
        ),
      );

  InlineSpan _blocks(BuildContext context, List<Block> blocks) => blocks.length == 1
      ? WidgetSpan(
          child: _block(context, blocks[0]),
        )
      : WidgetSpan(
          child: Wrap(
          children: List.generate(
            blocks.length,
            (index) => _block(context, blocks[index]),
          ),
        ));

  Widget _block(BuildContext context, Block block) => Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 8),
            child: Transform.translate(
              offset: Offset(0, -1.45 * SettingsProvider.shared.fontSize),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: block.shouldShowLine ? Colors.white : Colors.transparent),
                  ),
                ),
                child: Transform.translate(
                  offset: Offset(0, -0.5 * SettingsProvider.shared.fontSize),
                  child: Text(
                    block.chord,
                    style: AppThemeNew.of(context).bodyTextStyle.copyWith(
                          color: AppThemeNew.of(context).chordColor,
                          fontSize: SettingsProvider.shared.fontSize,
                          height: songLyric.showChords ? 2.4 : 1,
                        ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Text(
              block.lyricsPart,
              style: AppThemeNew.of(context).bodyTextStyle.copyWith(fontSize: SettingsProvider.shared.fontSize),
            ),
          ),
        ],
      );
}
