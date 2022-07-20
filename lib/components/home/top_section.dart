import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/components/logo.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/providers/navigation.dart';

const double _avatarRadius = 19;

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
          Highlightable(
            onTap: () => NavigationProvider.of(context).pushNamed('/user'),
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: const Icon(Icons.settings, size: 28),
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
