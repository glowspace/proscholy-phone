import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';

class PlaylistActionButton extends SpeedDialChild {
  PlaylistActionButton({
    Key? key,
    required String label,
    required IconData icon,
    Function()? onTap,
  }) : super(
          key: key,
          onTap: onTap,
          label: label,
          labelWidget: Highlightable(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(label)),
                const SizedBox(width: kDefaultPadding),
                Icon(icon, size: 24),
              ],
            ),
          ),
        );
}
