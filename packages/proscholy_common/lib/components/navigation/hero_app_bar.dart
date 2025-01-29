import 'package:flutter/material.dart';

class HeroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String tag;
  final PreferredSizeWidget appBar;

  const HeroAppBar({super.key, required this.tag, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Hero(tag: tag, child: appBar);
  }

  @override
  Size get preferredSize => appBar.preferredSize;
}
