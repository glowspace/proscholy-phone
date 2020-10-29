import 'package:flutter/material.dart';

class ScrollProvider extends ChangeNotifier {
  final ScrollController scrollController;

  bool _scrolling;

  ScrollProvider(this.scrollController) : _scrolling = false;

  bool get scrolling => _scrolling;

  void scrollEnded() {
    _scrolling = false;
    notifyListeners();
  }

  void toggleScroll() {
    _scrolling = !_scrolling;
    notifyListeners();

    if (_scrolling) {
      final maxExtent = scrollController.position.maxScrollExtent;
      final distanceDifference = maxExtent - scrollController.offset;
      final durationDouble = distanceDifference / 20;

      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(seconds: durationDouble.toInt()), curve: Curves.linear);
    } else
      scrollController.position.hold(() => true);
  }
}
