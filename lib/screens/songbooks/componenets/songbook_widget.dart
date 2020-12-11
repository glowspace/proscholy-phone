import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/songbooks_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/songbooks/songbook_screen.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/preloader.dart';

class SongbookWidget extends StatefulWidget {
  final Songbook songbook;

  const SongbookWidget({Key key, @required this.songbook}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongbookWidgetState();
}

class _SongbookWidgetState extends State<SongbookWidget> {
  bool _isHighlighted;

  @override
  void initState() {
    super.initState();

    _isHighlighted = false;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanDown: (_) => setState(() => _isHighlighted = true),
        onPanCancel: () => setState(() => _isHighlighted = false),
        onPanEnd: (_) => setState(() => _isHighlighted = false),
        onTap: () => _pushSongbook(context),
        child: Container(
          color: _isHighlighted ? AppTheme.of(context).highlightColor : null,
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              _image(context),
              Container(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(widget.songbook.name, style: AppTheme.of(context).bodyTextStyle, maxLines: 2)),
                    Consumer<SongbooksProvider>(
                      builder: (context, provider, _) => Transform.scale(
                        scale: 0.75,
                        child: HighlightableButton(
                          onPressed: () => provider.togglePinned(widget.songbook),
                          icon: Icon(widget.songbook.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _image(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: FittedBox(
            child: Image(
                image: Preloader.songbookLogo(widget.songbook.shortcut.toLowerCase()),
                key: Key(widget.songbook.shortcut)),
          ),
        ),
      );

  void _pushSongbook(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SongbookScreen(songbook: widget.songbook)),
      );
}
