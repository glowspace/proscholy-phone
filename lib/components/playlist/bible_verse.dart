import 'package:flutter/material.dart';
import 'package:zpevnik/components/song_lyric/utils/auto_scroll.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/bible_verse.dart';

class BibleVerseWidget extends StatelessWidget {
  final BibleVerse bibleVerse;
  final AutoScrollController autoScrollController;

  const BibleVerseWidget({super.key, required this.bibleVerse, required this.autoScrollController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: autoScrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding, vertical: kDefaultPadding) +
            EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Text(bibleVerse.text),
      ),
    );
  }
}
