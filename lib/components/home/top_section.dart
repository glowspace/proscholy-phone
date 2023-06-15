import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/logo.dart';
import 'package:zpevnik/constants.dart';

// const double _avatarRadius = 19;

class TopSection extends StatelessWidget {
  const TopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        const Logo(showFullName: false),
        const Spacer(),
        if (width <= kTabletSizeBreakpoint)
          HighlightableIconButton(
            onTap: () => context.push('/user'),
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            icon: const Icon(Icons.settings, size: 28),
            // CircleAvatar(
            //   backgroundImage: const AssetImage('assets/images/songbooks/default.png'),
            //   backgroundColor: Theme.of(context).colorScheme.surface,
            //   radius: _avatarRadius,
            // ),
          ),
      ],
    );
  }
}
