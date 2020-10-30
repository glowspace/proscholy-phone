import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/scroll_provider.dart';
import 'package:zpevnik/screens/components/lyrics_widget.dart';
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
                          child: LyricsWidget(verses: widget.songLyric.verses),
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
