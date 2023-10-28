import 'package:flutter/material.dart';
import 'package:zpevnik/routing/arguments.dart';

class SelectedDisplayableItemArguments extends InheritedWidget {
  final ValueNotifier<DisplayScreenArguments> displayableItemArgumentsNotifier;

  const SelectedDisplayableItemArguments({
    super.key,
    required super.child,
    required this.displayableItemArgumentsNotifier,
  });

  @override
  bool updateShouldNotify(SelectedDisplayableItemArguments oldWidget) {
    return displayableItemArgumentsNotifier != oldWidget.displayableItemArgumentsNotifier;
  }

  static ValueNotifier<DisplayScreenArguments>? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SelectedDisplayableItemArguments>()
        ?.displayableItemArgumentsNotifier;
  }
}
