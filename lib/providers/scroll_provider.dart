import 'package:flutter/material.dart';
import 'package:zpevnik/providers/data_provider.dart';

const double _defaultScrollSpeed = 20;
const double _minScrollSpeed = 10;
const double _maxScrollSpeed = 40;
const double _scrollSpeedChangeMult = 1.1;

class ScrollProvider {
  final ScrollController scrollController;

  ValueNotifier<bool> _scrolling;

  double _speed;

  ScrollProvider(this.scrollController)
      : _scrolling = ValueNotifier(false),
        _speed = DataProvider.shared.prefs.getDouble('scroll_speed') ?? _defaultScrollSpeed;

  ValueNotifier<bool> get scrolling => _scrolling;

  bool get canScroll => !(scrollController.position.atEdge && scrollController.position.pixels != 0);

  void scrollEnded() {
    _scrolling.value = false;
  }

  void toggleScroll() {
    _scrolling.value = !_scrolling.value;

    _scroll();
  }

  void faster() {
    if (_speed >= _maxScrollSpeed) return;

    _speed *= _scrollSpeedChangeMult;
    DataProvider.shared.prefs.setDouble('scroll_speed', _speed);

    _scroll();
  }

  void slower() {
    if (_speed <= _minScrollSpeed) return;

    _speed /= _scrollSpeedChangeMult;
    DataProvider.shared.prefs.setDouble('scroll_speed', _speed);

    _scroll();
  }

  void _scroll() {
    if (_scrolling.value) {
      final maxExtent = scrollController.position.maxScrollExtent;
      final distanceDifference = maxExtent - scrollController.offset;
      final durationDouble = distanceDifference / _speed;

      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(seconds: durationDouble.toInt()), curve: Curves.linear);
    } else
      scrollController.position.hold(() => true);
  }
}
