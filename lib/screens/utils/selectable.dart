import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/selection.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/playlists_sheet.dart';
import 'package:zpevnik/theme.dart';

mixin Selectable<T extends StatefulWidget> on State<T> {
  final SelectionProvider selectionProvider = SelectionProvider();

  Widget buildSelectableActions(
    List<SongLyric> songLyrics, {
    Function(BuildContext, List<SongLyric>)? removeSongLyrics,
  }) {
    final appTheme = AppTheme.of(context);
    final padding = EdgeInsets.all(kDefaultPadding / 2);

    final hasSelection = selectionProvider.selected.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Highlightable(
          child: Icon(selectionProvider.allFavorited ? Icons.star : Icons.star_outline),
          color: appTheme.chordColor,
          onPressed: hasSelection ? () => selectionProvider.toggleFavorite() : null,
        ),
        if (removeSongLyrics != null)
          Highlightable(
            child: Icon(Icons.delete),
            padding: padding,
            color: appTheme.chordColor,
            onPressed: hasSelection ? () => removeSongLyrics(context, selectionProvider.selected) : null,
          )
        else
          Highlightable(
            child: Icon(Icons.playlist_add),
            padding: padding,
            color: appTheme.chordColor,
            onPressed: hasSelection ? _showPlaylists : null,
          ),
        Highlightable(
          child: Icon(Icons.select_all),
          padding: padding,
          color: appTheme.chordColor,
          onPressed: () => selectionProvider.toggleAll(songLyrics),
        )
      ],
    );
  }

  void _showPlaylists() {
    final playlistsProvider = context.read<PlaylistsProvider>();

    return showPlatformBottomSheet(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: playlistsProvider,
        builder: (context, _) => PlaylistsSheet(selectedSongLyrics: selectionProvider.selected.toList()),
      ),
      height: 0.67 * MediaQuery.of(context).size.height,
    );
  }
}
