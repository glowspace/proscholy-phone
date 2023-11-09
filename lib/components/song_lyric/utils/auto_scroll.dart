import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zpevnik/models/settings.dart';
import 'package:zpevnik/providers/settings.dart';

class AutoScrollController extends ScrollController {
  final _scrollFutures = <Future<void>>{};

  bool get canScroll =>
      (positions.isEmpty || !position.hasContentDimensions) ? true : offset < position.maxScrollExtent;
  bool get isScrolling => _scrollFutures.isNotEmpty;

  void toggle(WidgetRef ref) async {
    if (isScrolling) {
      // this will cancel the animation
      jumpTo(offset);

      return;
    }

    ref.listenManual(
      settingsProvider.select((settings) => autoScrollSpeeds[settings.autoScrollSpeedIndex]),
      // on speed change will start new animation, which cancels the previous
      (_, msPerPixel) => _start(msPerPixel),
    );

    _start(autoScrollSpeeds[ref.read(settingsProvider).autoScrollSpeedIndex]);
  }

  void _start(int msPerPixel) async {
    final scrollFuture = animateTo(
      position.maxScrollExtent,
      duration: Duration(milliseconds: msPerPixel * (position.maxScrollExtent - offset).round()),
      curve: Curves.linear,
    );

    _scrollFutures.add(scrollFuture);
    notifyListeners();

    await scrollFuture;

    _scrollFutures.remove(scrollFuture);
    notifyListeners();
  }
}
