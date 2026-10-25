import 'package:flutter/material.dart';
import 'package:proscholy_common/routing/arguments.dart';

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

  static ValueNotifier<DisplayScreenArguments>? of(BuildContext context, {bool listen = true}) {
    final widget = listen
        ? context.dependOnInheritedWidgetOfExactType<SelectedDisplayableItemArguments>()
        : context.getInheritedWidgetOfExactType<SelectedDisplayableItemArguments>();

    return widget?.displayableItemArgumentsNotifier;
  }
}
