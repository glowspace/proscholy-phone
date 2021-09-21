import 'package:flutter/material.dart';

const double _defaultScrollSpeed = 20;
const double _minScrollSpeed = 10;
const double _maxScrollSpeed = 40;
const double _scrollSpeedChangeMult = 1.1;

class ScrollProvider {
  final ScrollController controller;
  final ValueNotifier<bool> scrolling;

  ScrollProvider(this.controller)
      : scrolling = ValueNotifier(false),
        _speed = _defaultScrollSpeed;

  double _speed;

  bool get canScroll =>
      !controller.position.hasContentDimensions || !(controller.position.atEdge && controller.position.pixels != 0);

  void toggleScroll() {
    scrolling.value = !scrolling.value;

    _scroll();
  }

  void faster() {
    if (_speed >= _maxScrollSpeed) return;

    _speed *= _scrollSpeedChangeMult;
    // Global.shared.prefs.setDouble('scroll_speed', _speed);

    _scroll();
  }

  void slower() {
    if (_speed <= _minScrollSpeed) return;

    _speed /= _scrollSpeedChangeMult;
    // Global.shared.prefs.setDouble('scroll_speed', _speed);

    _scroll();
  }

  void _scroll() {
    if (scrolling.value) {
      final maxExtent = controller.position.maxScrollExtent;
      final distanceDifference = maxExtent - controller.offset;
      final durationDouble = distanceDifference / _speed;

      controller.animateTo(controller.position.maxScrollExtent,
          duration: Duration(seconds: durationDouble.toInt()), curve: Curves.linear);
    } else
      controller.position.hold(() => true);
  }
}
