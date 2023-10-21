import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/bible_verse.dart';

class BibleVerseWidget extends StatelessWidget {
  final BibleVerse bibleVerse;

  const BibleVerseWidget({super.key, required this.bibleVerse});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding, vertical: kDefaultPadding) +
            EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Text(bibleVerse.text),
      ),
    );
  }
}
