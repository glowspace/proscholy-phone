import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/utils/extensions.dart';

const _songbookColorBoxSize = 16.0;

class SongbookRow extends StatelessWidget {
  final Songbook songbook;

  const SongbookRow({super.key, required this.songbook});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => _pushSongbook(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: 1.25 * kDefaultPadding),
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
      ),
    );
  }

  void _pushSongbook(BuildContext context) {
    FocusScope.of(context).unfocus();

    context.push('/songbook', extra: songbook);
  }
}
