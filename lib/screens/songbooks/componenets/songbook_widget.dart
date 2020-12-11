import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/songbooks_provider.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/screens/songbooks/songbook_screen.dart';
import 'package:zpevnik/theme.dart';
import 'package:zpevnik/utils/preloader.dart';

class SongbookWidget extends StatelessWidget {
  final Songbook songbook;

  const SongbookWidget({Key key, @required this.songbook}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _pushSongbook(context),
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              _image(context),
              Container(
                padding: EdgeInsets.only(top: kDefaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(songbook.name, style: AppTheme.of(context).bodyTextStyle, maxLines: 2)),
                    Consumer<SongbooksProvider>(
                      builder: (context, provider, _) => Transform.scale(
                        scale: 0.75,
                        child: HighlightableButton(
                          onPressed: () => provider.togglePinned(songbook),
                          icon: Icon(songbook.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
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
            child: Image(image: Preloader.songbookLogo(songbook.shortcut.toLowerCase()), key: Key(songbook.shortcut)),
          ),
        ),
      );

  void _pushSongbook(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SongbookScreen(songbook: songbook)),
      );
}
