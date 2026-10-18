import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/components/song_lyric/utils/auto_scroll.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/bible_passage.dart';
import 'package:proscholy_common/providers/display_screen_status.dart';

class BiblePassageWidget extends ConsumerWidget {
  final BiblePassage biblePassage;
  final AutoScrollController autoScrollController;

  const BiblePassageWidget({super.key, required this.biblePassage, required this.autoScrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: autoScrollController,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding, vertical: kDefaultPadding) +
                  EdgeInsets.only(
                    bottom: ref.watch(displayScreenStatusProvider.select((status) => status.fullScreen))
                        ? MediaQuery.paddingOf(context).bottom
                        : 0,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(biblePassage.text),
                  const SizedBox(height: 3 * kDefaultPadding),
                  Text(
                    'Chráněno autorskými právy; Oprávnění k distribuci uděleno společnosti CrossWire',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
