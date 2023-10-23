import 'package:flutter/material.dart';

class SelectedDisplayableItemIndex extends InheritedWidget {
  final ValueNotifier<int?> displayableItemIndexNotifier;

  const SelectedDisplayableItemIndex({super.key, required super.child, required this.displayableItemIndexNotifier});

  @override
  bool updateShouldNotify(SelectedDisplayableItemIndex oldWidget) {
    return displayableItemIndexNotifier != oldWidget.displayableItemIndexNotifier;
  }

  static ValueNotifier<int?>? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SelectedDisplayableItemIndex>()?.displayableItemIndexNotifier;
  }
}
