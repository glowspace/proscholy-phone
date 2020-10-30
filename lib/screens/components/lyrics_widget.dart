import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/theme.dart';

class LyricsWidget extends StatelessWidget {
  final List<Verse> verses;

  const LyricsWidget({Key key, this.verses}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          verses.length,
          (index) => _verse(context, verses[index]),
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
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: AppTheme.shared.textColor(context)),
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
                offset: Offset(0, -23),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: block.shouldShowLine ? Colors.white : Colors.transparent),
                    ),
                  ),
                  child: Transform.translate(
                    offset: Offset(0, -8),
                    child: Text(
                      block.chord,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: AppTheme.shared.chordColor(context), height: 2.5),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                block.lyricsPart,
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: AppTheme.shared.textColor(context)),
              ),
            ),
          ],
        ),
      );
}
