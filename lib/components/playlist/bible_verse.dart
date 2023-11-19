import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/components/song_lyric/utils/auto_scroll.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/bible_verse.dart';
import 'package:zpevnik/providers/display_screen_status.dart';

class BibleVerseWidget extends StatelessWidget {
  final BibleVerse bibleVerse;
  final AutoScrollController autoScrollController;

  const BibleVerseWidget({super.key, required this.bibleVerse, required this.autoScrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: autoScrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding, vertical: kDefaultPadding),
              child: Text(bibleVerse.text),
            ),
          ),
        ),
        Consumer(
          builder: (_, ref, __) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding, vertical: kDefaultPadding) +
                EdgeInsets.only(
                    bottom: ref.watch(displayScreenStatusProvider
                        .select((status) => status.fullScreen ? MediaQuery.paddingOf(context).bottom : 0))),
            child: Text(
              'Chráněno autorskými právy; Oprávnění k distribuci uděleno společnosti CrossWire',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
