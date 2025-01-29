import 'package:flutter/material.dart';
import 'package:proscholy_common/components/highlightable_widget.dart';
import 'package:proscholy_common/constants.dart';
import 'package:proscholy_common/models/songbook.dart';
import 'package:proscholy_common/utils/extensions.dart';

const _songbookColorBoxSize = 16.0;

class SongbookRow extends StatelessWidget {
  final Songbook songbook;

  const SongbookRow({super.key, required this.songbook});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return HighlightableWidget(
      highlightBackground: true,
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: 1.25 * kDefaultPadding),
      onTap: () => context.push('/songbook', arguments: songbook),
      child: Row(children: [
        Container(
          width: _songbookColorBoxSize,
          height: _songbookColorBoxSize,
          decoration: BoxDecoration(
            color: HexColor.fromHex(songbook.color) ?? blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(child: Text(songbook.name, style: textTheme.bodyMedium)),
        Text(songbook.shortcut, style: textTheme.bodySmall),
      ]),
    );
  }
}
