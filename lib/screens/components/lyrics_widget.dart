import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/theme.dart';

class LyricsWidget extends StatelessWidget {
  final SongLyric songLyric;

  const LyricsWidget({Key key, this.songLyric}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(songLyric.name,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: AppTheme.shared.textColor(context),
                    fontSize: 1.3 * songLyric.fontSize,
                    fontWeight: FontWeight.bold,
                  )),
          Container(
            padding: EdgeInsets.only(top: 1.5 * songLyric.fontSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                songLyric.verses.length,
                (index) => _verse(context, songLyric.verses[index]),
              ),
            ),
          ),
        ],
      );

  Container _verse(BuildContext context, Verse verse) => Container(
        padding: EdgeInsets.only(bottom: kDefaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (verse.number.isNotEmpty)
              Text(
                verse.number,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: AppTheme.shared.textColor(context),
                      fontSize: songLyric.fontSize,
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
            line.blocks.length,
            (index) => _block(context, line.blocks[index]),
          ),
        ),
      );

  InlineSpan _block(BuildContext context, Block block) => WidgetSpan(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 8),
              child: Transform.translate(
                offset: Offset(0, -1.5 * songLyric.fontSize),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: block.shouldShowLine ? Colors.white : Colors.transparent),
                    ),
                  ),
                  child: Transform.translate(
                    offset: Offset(0, -0.5 * songLyric.fontSize),
                    child: Text(
                      block.chord,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: AppTheme.shared.chordColor(context),
                            fontSize: songLyric.fontSize,
                            height: songLyric.showChords ? 2.5 : 1,
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
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: AppTheme.shared.textColor(context),
                      fontSize: songLyric.fontSize,
                    ),
              ),
            ),
          ],
        ),
      );
}
