import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/song_lyrics_provider.dart';
import 'package:zpevnik/screens/components/song_lyric_row.dart';
import 'package:zpevnik/screens/filters/active_filters_row.dart';
import 'package:zpevnik/theme.dart';

class SongLyricsListView extends StatelessWidget {
  final String placeholder;

  const SongLyricsListView({Key key, this.placeholder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongLyricsProvider>(context);
    final text = provider.searchText.isEmpty && placeholder != null
        ? placeholder
        : 'Nebyla nalezena žádná píseň pro${unbreakableSpace}hledaný výraz: "${provider.searchText}"';

    final content = provider.songLyrics.isNotEmpty
        ? Scrollbar(
            child: ListView.builder(
              itemBuilder: (context, index) => SongLyricRow(
                key: provider.songLyrics[index].key,
                songLyric: provider.songLyrics[index],
              ),
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
}
