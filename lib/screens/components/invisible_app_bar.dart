import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvisibleAppBar extends AppBar {
  InvisibleAppBar({SystemUiOverlayStyle? systemOverlayStyle})
      : super(systemOverlayStyle: systemOverlayStyle, shadowColor: Colors.transparent);

  @override
  Size get preferredSize => const Size.square(0);

  InvisibleAppBar copyWith({
    Key? key,
    List<BottomNavigationBarItem>? items,
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    double? iconSize,
    Border? border,
    int? currentIndex,
    ValueChanged<int>? onTap,
  }) =>
      InvisibleAppBar();
}
