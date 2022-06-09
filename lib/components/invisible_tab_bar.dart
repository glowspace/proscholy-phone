import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// source: https://stackoverflow.com/a/56230540/8592888
class InvisibleCupertinoTabBar extends CupertinoTabBar {
  static const dummyIcon = Icon(Icons.select_all);

  const InvisibleCupertinoTabBar({Key? key})
      : super(
          key: key,
          items: const [
            BottomNavigationBarItem(icon: dummyIcon),
            BottomNavigationBarItem(icon: dummyIcon),
            BottomNavigationBarItem(icon: dummyIcon),
          ],
        );

  @override
  Size get preferredSize => const Size.square(0);

  @override
  Widget build(BuildContext context) => const SizedBox();

  @override
  InvisibleCupertinoTabBar copyWith({
    Key? key,
    List<BottomNavigationBarItem>? items,
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    double? iconSize,
    double? height,
    Border? border,
    int? currentIndex,
    ValueChanged<int>? onTap,
  }) =>
      InvisibleCupertinoTabBar();
}
