import 'package:flutter/material.dart';
import 'package:proscholy_common/utils/services/window.dart';

// moves the content below window controls of iPadOS, so they don't cover buttons of app bars
class WindowControlsWrapper extends StatefulWidget {
  final Widget child;

  const WindowControlsWrapper({super.key, required this.child});

  @override
  State<WindowControlsWrapper> createState() => _WindowControlsWrapperState();
}

class _WindowControlsWrapperState extends State<WindowControlsWrapper> {
  @override
  void initState() {
    super.initState();

    WindowService.instance.listen();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: WindowService.instance.windowControlsHeight,
      builder: (context, windowControlsHeight, child) {
        if (windowControlsHeight == 0) return child!;

        final mediaQuery = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQuery.copyWith(
            padding: mediaQuery.padding.copyWith(top: mediaQuery.padding.top + windowControlsHeight),
            viewPadding: mediaQuery.viewPadding.copyWith(top: mediaQuery.viewPadding.top + windowControlsHeight),
          ),
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}
