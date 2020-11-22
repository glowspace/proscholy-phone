import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';
import 'package:zpevnik/screens/playlists/playlist_screen.dart';
import 'package:zpevnik/theme.dart';

class PlaylistRow extends StatefulWidget {
  final Playlist playlist;
  final Function(Playlist) select;
  final ValueNotifier<GlobalKey> showingMenuKey;

  const PlaylistRow({Key key, this.playlist, this.select, this.showingMenuKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaylistRowState();
}

class _PlaylistRowState extends State<PlaylistRow> {
  final _key = GlobalKey();

  bool _highlighted;

  @override
  void initState() {
    super.initState();

    _highlighted = false;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _pushPlaylist(context),
        // fixme: doesn't work well with menu button

        // onPanDown: (_) => setState(() => _highlighted = true),
        // onPanCancel: () => _highlighted = false,
        // onPanEnd: (_) => setState(() => _highlighted = false),
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: (_highlighted ? AppTheme.shared.highlightColor(context) : null),
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 2),
          child: Row(children: [
            Expanded(child: Text(widget.playlist.name, style: Theme.of(context).textTheme.bodyText1)),
            GestureDetector(
              onTap: () {
                widget.select(widget.playlist);
                widget.showingMenuKey.value = widget.showingMenuKey.value == null ? _key : null;
              },
              child: Icon(Icons.more_vert, key: _key),
            ),
          ]),
        ),
      );

  void _pushPlaylist(BuildContext context) {
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: widget.playlist)));
  }
}
