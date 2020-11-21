import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/providers/songbooks_provider.dart';
import 'package:zpevnik/screens/components/highlithtable_button.dart';
import 'package:zpevnik/screens/songbooks/songbook_screen.dart';
import 'package:zpevnik/theme.dart';

const List<String> _existingLogos = ['csach', 'csatr', 'csmom', 'csmta', 'csmzd', 'sdmkr'];

class SongbookWidget extends StatelessWidget {
  final Songbook songbook;

  const SongbookWidget({Key key, this.songbook}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _pushSongbook(context),
        child: Container(
          padding: EdgeInsets.all(kDefaultPadding / 2),
          child: Column(
            children: [
              _image(context),
              Container(
                padding: EdgeInsets.only(top: kDefaultPadding / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(songbook.name, style: Theme.of(context).textTheme.bodyText1)),
                    Consumer<SongbooksProvider>(
                      builder: (context, provider, _) => Transform.scale(
                        scale: 0.75,
                        child: HighlightableButton(
                          onPressed: () => provider.togglePinned(songbook),
                          color: Theme.of(context).textTheme.caption.color,
                          highlightedColor: AppTheme.shared.highlightColor(context),
                          icon: songbook.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
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
            child: Image.asset(_existingLogos.contains(songbook.shortcut.toLowerCase())
                ? '$imagesPath/songbooks/${songbook.shortcut.toLowerCase()}.png'
                : '$imagesPath/songbooks/default.png'),
          ),
        ),
      );

  void _pushSongbook(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SongbookScreen(songbook: songbook)),
      );
}
