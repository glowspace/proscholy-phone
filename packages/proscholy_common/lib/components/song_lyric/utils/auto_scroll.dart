import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proscholy_common/models/settings.dart';
import 'package:proscholy_common/providers/settings.dart';

class AutoScrollController extends ScrollController {
  final _scrollFutures = <Future<void>>{};

  ProviderSubscription<int>? _speedSubscription;

  bool _isDisposed = false;

  bool get canScroll =>
      (positions.isEmpty || !position.hasContentDimensions) ? true : offset < position.maxScrollExtent;
  bool get isScrolling => _scrollFutures.isNotEmpty;

  void toggle(WidgetRef ref) async {
    if (isScrolling) {
      // this will cancel the animation
      jumpTo(offset);

      return;
    }

    _speedSubscription = ref.listenManual(
      settingsProvider.select((settings) => autoScrollSpeeds[settings.autoScrollSpeedIndex]),
      // on speed change will start new animation, which cancels the previous
      (_, msPerPixel) => _start(msPerPixel),
    );

    _start(autoScrollSpeeds[ref.read(settingsProvider).autoScrollSpeedIndex]);
  }

  // listeners are notified only about scrolling, but whether it can scroll depends also on size of content
  void contentSizeChanged() => notifyListeners();

  @override
  void dispose() {
    _isDisposed = true;
    _speedSubscription?.close();

    super.dispose();
  }

  void _start(int msPerPixel) async {
    if (!hasClients) return;

    final scrollFuture = animateTo(
      position.maxScrollExtent,
      duration: Duration(milliseconds: msPerPixel * (position.maxScrollExtent - offset).round()),
      curve: Curves.linear,
    );

    _scrollFutures.add(scrollFuture);
    notifyListeners();

    await scrollFuture;

    // closing the scroll view ends the animation, but the controller might be already disposed
    if (_isDisposed) return;

    _scrollFutures.remove(scrollFuture);
    if (!isScrolling) _speedSubscription?.close();
    notifyListeners();
  }
}
