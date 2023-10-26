import 'package:flutter/material.dart';

// big enough, so it is always round
const _selectedRowRadius = 32.0;

class SelectedRowHighlight<T, U> extends StatelessWidget {
  final ValueNotifier<U>? selectedObjectNotifier;
  final T object;
  final Widget child;

  final T Function(U)? mapSelectedObject;

  const SelectedRowHighlight({
    super.key,
    this.selectedObjectNotifier,
    required this.object,
    required this.child,
    this.mapSelectedObject,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedObjectNotifier == null) return child;

    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: selectedObjectNotifier!,
      builder: (_, selectedObject, child) {
        final selected = mapSelectedObject?.call(selectedObject) ?? selectedObject as T;

        return Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_selectedRowRadius),
            border: selected == object ? Border.all(color: theme.colorScheme.primary, width: 0.25) : null,
            color: selected == object ? theme.colorScheme.secondaryContainer : null,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
