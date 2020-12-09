import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songLyric.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/reorderable.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/filters/active_filters_row.dart';
import 'package:zpevnik/theme.dart';

class SongLyricsListView extends StatelessWidget {
  final String placeholder;
  final bool reorderable;
  final bool showStar;

  const SongLyricsListView({Key key, this.placeholder, this.reorderable = false, this.showStar = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongLyricsProvider>(context);
    final text = provider.searchText.isNotEmpty
        ? 'Nebyla nalezena žádná píseň pro${unbreakableSpace}hledaný výraz: "${provider.searchText}"'
        : (placeholder != null ? placeholder : 'Seznam neobsahuje žádnou píseň.');

    final content = provider.songLyrics.isNotEmpty
        ? Scrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) => reorderable
                  ? Reorderable(
                      key: provider.songLyrics[index].key,
                      child: _row(context, provider.songLyrics[index]),
                    )
                  : _row(context, provider.songLyrics[index]),
              itemCount: provider.songLyrics.length,
            ),
          )
        : Container(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Center(child: Text(text, style: AppThemeNew.of(context).bodyTextStyle, textAlign: TextAlign.center)),
          );

    return Column(children: [
      ChangeNotifierProvider.value(
        value: provider.tagsProvider,
        child: ActiveFiltersRow(selectedTags: provider.tagsProvider.selectedTags),
      ),
      Expanded(child: content),
    ]);
  }

  Widget _row(BuildContext context, SongLyric songLyric) => SongLyricRow(
        key: songLyric.key,
        songLyric: songLyric,
        showStar: showStar,
        prefix: reorderable
            ? ReorderableListener(child: Icon(Icons.drag_handle, color: AppThemeNew.of(context).iconColor))
            : null,
      );
}
