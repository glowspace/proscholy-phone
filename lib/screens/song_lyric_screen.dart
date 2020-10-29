import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/scroll_provider.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/platform.dart';

import 'components/sliding_widget.dart';
import 'components/song_lyric_settings.dart';

class SongLyricScreen extends StatefulWidget {
  final SongLyric songLyric;

  const SongLyricScreen({Key key, this.songLyric}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongLyricScreen();
}

class _SongLyricScreen extends State<SongLyricScreen> with PlatformStateMixin {
  ScrollController _scrollController;
  ScrollProvider _scrollProvider;

  bool _fullScreen;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollProvider = ScrollProvider(_scrollController);

    _fullScreen = false;

    widget.songLyric.addListener(() => setState(() {}));
  }

  @override
  Widget androidWidget(BuildContext context) =>
      Scaffold(appBar: _fullScreen ? null : AppBar(title: Text(widget.songLyric.id.toString())), body: _body(context));

  @override
  Widget iOSWidget(BuildContext context) => CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.songLyric.id.toString()),
      ),
      child: _body(context));

  Widget _body(BuildContext context) => SafeArea(
        child: GestureDetector(
          onTap: () => setState(() => _fullScreen = !_fullScreen),
          child: Stack(
            children: [
              NotificationListener(
                onNotification: (notif) {
                  if (notif is ScrollEndNotification && _scrollProvider.scrolling)
                    setState(() => _scrollProvider.scrollEnded());

                  return true;
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: kDefaultPadding / 2),
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
                              widget.songLyric.verses.length,
                              (index) => _verse(context, widget.songLyric.verses[index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: kDefaultPadding,
                child: ChangeNotifierProvider.value(
                  value: _scrollProvider,
                  child: SlidingWidget(
                    showSettings: _showSettings,
                    showExternals: _showExternals,
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
              color: Colors.black, // Theme.of(context)
              // .scaffoldBackgroundColor, // needs to be same as background (hides part of chord line)
              child: Text(
                block.lyricsPart,
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: AppTheme.shared.textColor(context)),
              ),
            ),
          ],
        ),
      );

  void _showSettings() {
    if (!Platform.isIOS)
      showCupertinoModalBottomSheet(
        context: context,
        builder: (context, scrollController) => SizedBox(
          height: 0.67 * MediaQuery.of(context).size.height,
          child: SongLyricSettings(songLyric: widget.songLyric),
        ),
        useRootNavigator: true,
      );
    else
      showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          height: 0.67 * MediaQuery.of(context).size.height,
          child: SongLyricSettings(songLyric: widget.songLyric),
        ),
      );
  }

  void _showExternals() => showCupertinoModalBottomSheet(
        context: context,
        builder: (context, scrollController) => SizedBox(
          height: 0.67 * MediaQuery.of(context).size.height,
          child: Container(),
        ),
        useRootNavigator: true,
      );
}
