import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/playlist.dart';

const double _iconSize = 20;

class PlaylistRow extends StatelessWidget {
  final Playlist playlist;

  const PlaylistRow({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      onTap: () => _pushPlaylist(context),
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: Row(
        children: [
          Icon(playlist.isFavorites ? Icons.star : Icons.playlist_play_rounded, size: _iconSize),
          const SizedBox(width: kDefaultPadding),
          Expanded(child: Text(playlist.name)),
        ],
      ),
    );
  }

  void _pushPlaylist(BuildContext context) {
    FocusScope.of(context).unfocus();

    Navigator.pushNamed(context, '/playlist', arguments: playlist);
  }
}
