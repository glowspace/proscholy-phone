import 'package:flutter/material.dart';

mixin Updateable<T extends StatefulWidget> on State<T> {
  late final List<Listenable> _listenables;

  @override
  void initState() {
    super.initState();

    _listenables = listenables;

    for (final listenable in _listenables) listenable.addListener(update);
  }

  @override
  void dispose() {
    for (final listenable in _listenables) listenable.removeListener(update);

    super.dispose();
  }

  List<Listenable> get listenables;

  void update() => setState(() => {});
}
