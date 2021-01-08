import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/reorderable.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/filters/active_filters_row.dart';
import 'package:zpevnik/theme.dart';

class SongLyricsListView extends StatelessWidget {
  final String placeholder;
  final String title;
  final Color titleColor;
  final bool reorderable;
  final bool showStar;

  const SongLyricsListView({
    Key key,
    this.placeholder,
    this.title,
    this.titleColor,
    this.reorderable = false,
    this.showStar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongLyricsProvider>(context);
    final text = provider.searchText.isNotEmpty
        ? 'Nebyla nalezena žádná píseň pro${unbreakableSpace}hledaný výraz: "${provider.searchText}"'
        : (placeholder != null ? placeholder : 'Seznam neobsahuje žádnou píseň.');

    final showTitle = title != null && provider.showingAll;

    final content = provider.songLyrics.isNotEmpty
        ? Scrollbar(
            child: ListView.builder(
              controller: provider.scrollController,
              itemBuilder: (context, index) {
                if (index == 0 && showTitle)
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 1.5 * kDefaultPadding, vertical: kDefaultPadding),
                    child: Text(title, style: AppTheme.of(context).bodyTextStyle.copyWith(color: titleColor)),
                  );

                if (showTitle) index -= 1;

                return reorderable
                    ? Reorderable(
                        key: provider.songLyrics[index].key,
                        child: _row(context, provider.songLyrics[index]),
                      )
                    : _row(context, provider.songLyrics[index]);
              },
              itemCount: provider.songLyrics.length + (showTitle ? 1 : 0),
            ),
          )
        : Container(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Center(child: Text(text, style: AppTheme.of(context).bodyTextStyle, textAlign: TextAlign.center)),
          );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Column(children: [
        ChangeNotifierProvider.value(
          value: provider.tagsProvider,
          child: ActiveFiltersRow(selectedTags: provider.tagsProvider.selectedTags),
        ),
        Expanded(child: content),
      ]),
    );
  }

  Widget _row(BuildContext context, SongLyric songLyric) => SongLyricRow(
        key: songLyric.key,
        songLyric: songLyric,
        showStar: showStar,
        prefix: reorderable
            ? ReorderableListener(child: Icon(Icons.drag_handle, color: AppTheme.of(context).iconColor))
            : null,
      );
}
