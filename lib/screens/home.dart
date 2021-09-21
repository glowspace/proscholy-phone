import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/utils/bottom_sheet.dart';
import 'package:zpevnik/providers/data.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/selection.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/screens/components/playlists_sheet.dart';
import 'package:zpevnik/screens/components/searchable_list_view.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SongLyricsProvider _songLyricsProvider;
  late SelectionProvider _selectionProvider;

  @override
  void initState() {
    super.initState();

    _songLyricsProvider = SongLyricsProvider(context.read<DataProvider>().songLyrics);
    _selectionProvider = SelectionProvider();
  }

  @override
  Widget build(BuildContext context) {
    final itemBuilder = (songLyric) => SongLyricRow(songLyric: songLyric);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _songLyricsProvider),
        ChangeNotifierProvider.value(value: _selectionProvider),
      ],
      builder: (context, _) => SearchableListView(
        key: PageStorageKey('home_screen'),
        itemsProvider: _songLyricsProvider,
        itemBuilder: itemBuilder,
        searchPlaceholder: 'Zadejte slovo nebo číslo',
        trailingActions: AnimatedBuilder(
          animation: _selectionProvider,
          builder: (context, child) => _buildSelectableActions(),
        ),
      ),
    );
  }

  Widget _buildSelectableActions() {
    final appTheme = AppTheme.of(context);
    final padding = EdgeInsets.all(kDefaultPadding / 2);

    final hasSelection = _selectionProvider.selected.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Highlightable(
          child: Icon(_selectionProvider.allFavorited ? Icons.star : Icons.star_outline),
          color: appTheme.chordColor,
          onPressed: hasSelection ? () => _selectionProvider.toggleFavorite() : null,
        ),
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
          onPressed: () => _selectionProvider.toggleAll(_songLyricsProvider.items),
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
        builder: (context, _) => PlaylistsSheet(selectedSongLyrics: _selectionProvider.selected.toList()),
      ),
      height: 0.67 * MediaQuery.of(context).size.height,
    );
  }
}
