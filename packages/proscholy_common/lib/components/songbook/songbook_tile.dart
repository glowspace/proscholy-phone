import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/providers/songbooks.dart';
import 'package:proscholy_common/utils/extensions.dart';

const _logosPath = '$imagesPath/songbooks';
const _existingLogos = [
  '1ch',
  '2ch',
  '3ch',
  '4ch',
  '5ch',
  '6ch',
  '7ch',
  '8ch',
  '9ch',
  'c',
  'csach',
  'csatr',
  'csmom',
  'csmta',
  'csmzd',
  'csmhk',
  'dbl',
  'k',
  'kan',
  'sdmkr',
  'h1',
  'h2'
];

class SongbookTile extends StatelessWidget {
  final Songbook songbook;

  const SongbookTile({super.key, required this.songbook});

  @override
  Widget build(BuildContext context) {
    final shortcut = songbook.shortcut.toLowerCase();
    final imagePath = _existingLogos.contains(shortcut) ? '$_logosPath/$shortcut.png' : '$_logosPath/default.png';

    return HighlightableWidget(
      highlightBackground: true,
      padding: const EdgeInsets.all(kDefaultPadding),
      onTap: () => _pushSongbook(context),
      child: IntrinsicWidth(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: FittedBox(child: Image.asset(imagePath, package: 'proscholy_common')),
              ),
            ),
            const SizedBox(height: kDefaultPadding / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(songbook.name, maxLines: 2)),
                HighlightableWidget(
                  onTap: () => context.providers.read(pinnedSongbookIdsProvider.notifier).togglePin(songbook),
                  icon: Consumer(
                    builder: (_, ref, __) => Icon(
                      ref.watch(pinnedSongbookIdsProvider).contains(songbook.id)
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pushSongbook(BuildContext context) {
    context.push('/songbook', arguments: songbook);
  }
}
