import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/selected_displayable_item_index.dart';
import 'package:zpevnik/components/selected_row_highlight.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/providers/search.dart';
import 'package:zpevnik/routing/arguments.dart';
import 'package:zpevnik/utils/extensions.dart';

const double _iconSize = 16;
const _disabledAlpha = 0x20;

class SongLyricRow extends StatelessWidget {
  final SongLyric songLyric;
  final bool isInsideTranslationSheet;

  final DisplayScreenArguments? displayScreenArguments;

  const SongLyricRow({
    super.key,
    required this.songLyric,
    this.displayScreenArguments,
    this.isInsideTranslationSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final blueScheme = ColorScheme.fromSeed(seedColor: blue, brightness: theme.brightness);
    final redScheme = ColorScheme.fromSeed(seedColor: red, brightness: theme.brightness);
    final greenScheme = ColorScheme.fromSeed(seedColor: green, brightness: theme.brightness);

    const textMargin = EdgeInsets.only(top: 2);

    Widget row = Highlightable(
      highlightBackground: true,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 3),
      onTap: () => _pushSongLyric(context),
      child: SelectedRowHighlight(
        selectedObjectNotifier: SelectedDisplayableItemArguments.of(context),
        object: isInsideTranslationSheet ? null : songLyric,
        mapSelectedObject: (arguments) => arguments.items[arguments.initialIndex] as SongLyric,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 3),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(songLyric.name, style: textTheme.bodyMedium),
                    Consumer(builder: (_, ref, __) {
                      final searchText = ref.watch(searchTextProvider);

                      if (searchText.isNotEmpty) {
                        for (final songbookRecord in songLyric.songbookRecords) {
                          if (searchText == songbookRecord.number) {
                            return Container(
                              margin: textMargin,
                              child: Text(songbookRecord.songbook.target!.name, style: textTheme.bodySmall),
                            );
                          }
                        }
                      }

                      return const SizedBox();
                    }),
                    if (songLyric.secondaryName1 != null)
                      Container(margin: textMargin, child: Text(songLyric.secondaryName1!, style: textTheme.bodySmall)),
                    if (songLyric.secondaryName2 != null)
                      Container(margin: textMargin, child: Text(songLyric.secondaryName2!, style: textTheme.bodySmall)),
                  ],
                ),
              ),
              const SizedBox(width: kDefaultPadding),
              FaIcon(
                songLyric.hasChords ? FontAwesomeIcons.guitar : FontAwesomeIcons.alignLeft,
                size: _iconSize,
                color: blueScheme.primary.withAlpha(songLyric.hasLyrics ? 0xFF : _disabledAlpha),
              ),
              const SizedBox(width: kDefaultPadding),
              FaIcon(
                FontAwesomeIcons.solidFileLines,
                size: _iconSize,
                color: redScheme.primary.withAlpha(songLyric.hasFiles ? 0xFF : _disabledAlpha),
              ),
              const SizedBox(width: kDefaultPadding),
              FaIcon(
                FontAwesomeIcons.headphones,
                size: _iconSize,
                color: greenScheme.primary.withAlpha(songLyric.hasRecordings ? 0xFF : _disabledAlpha),
              ),
            ],
          ),
        ),
      ),
    );

    return row;
  }

  void _pushSongLyric(BuildContext context) {
    FocusScope.of(context).unfocus();

    final arguments = ModalRoute.of(context)?.settings.arguments;
    final selectedDisplayableItemArgumentsNotifier = SelectedDisplayableItemArguments.of(context);

    if (arguments is SearchScreenArguments && arguments.shouldReturnSongLyric) {
      Navigator.of(context).pop(songLyric);
    } else if (selectedDisplayableItemArgumentsNotifier != null) {
      selectedDisplayableItemArgumentsNotifier.value =
          displayScreenArguments ?? DisplayScreenArguments.songLyric(songLyric);

      if (isInsideTranslationSheet) context.pop();
    } else {
      if (isInsideTranslationSheet) {
        context.popAndPush('/display',
            arguments: displayScreenArguments ?? DisplayScreenArguments.songLyric(songLyric));
      } else {
        context.push('/display', arguments: displayScreenArguments ?? DisplayScreenArguments.songLyric(songLyric));
      }
    }
  }
}
