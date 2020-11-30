import 'package:flutter/material.dart';

class DataContainer<T> extends InheritedWidget {
  final T data;

  const DataContainer({Widget child, this.data}) : super(child: child);

  @override
  bool updateShouldNotify(DataContainer oldWidget) => data != oldWidget.data;

  static DataContainer<U> of<U>(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
}
