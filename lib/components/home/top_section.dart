import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';

const double _avatarRadius = 19;

class TopSection extends StatelessWidget {
  const TopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/title.png', height: 2 * _avatarRadius),
        const Spacer(),
        Highlightable(
          onTap: () => Navigator.of(context).pushNamed('/user'),
          child: CircleAvatar(
            backgroundImage: const AssetImage('assets/images/songbooks/default.png'),
            backgroundColor: Theme.of(context).colorScheme.surface,
            radius: _avatarRadius,
          ),
        ),
      ],
    );
  }
}
