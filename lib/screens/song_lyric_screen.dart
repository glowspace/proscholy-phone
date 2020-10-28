import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform_state.dart';

class SongLyricScreen extends StatefulWidget {
  final SongLyric songLyric;

  const SongLyricScreen({Key key, this.songLyric}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricScreen();
}

class _SongLyricScreen extends State<SongLyricScreen> with PlatformStateMixin {
  _SongLyricScreen();

  @override
  Widget androidWidget(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(widget.songLyric.id.toString())),
      body: _body(context));

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.songLyric.id.toString()),
        transitionBetweenRoutes: false,
      ),
      child: _body(context));

  Widget _body(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: kDefaultPadding, horizontal: kDefaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.songLyric.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: AppTheme.shared.textColor(context))),
                Container(
                  padding: EdgeInsets.only(top: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      widget.songLyric.parsedLyrics.length,
                      (index) =>
                          _verse(context, widget.songLyric.parsedLyrics[index]),
                    ),
                  ),
                ),
              ],
            ),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: AppTheme.shared.textColor(context)),
              ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(
                    left: verse.number.isEmpty ? 0 : (kDefaultPadding / 2)),
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
            Text(
              block.lyricsPart,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: AppTheme.shared.textColor(context)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 8),
              child: Transform.translate(
                offset: Offset(0, -31),
                child: Text(
                  block.chord,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: AppTheme.shared.chordColor(context), height: 2.5),
                ),
              ),
            )
          ],
        ),
      );
}
