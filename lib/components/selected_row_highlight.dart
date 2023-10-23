import 'package:flutter/material.dart';

// big enough, so it is always round
const _selectedRowRadius = 32.0;

class SelectedRowHighlight<T> extends StatelessWidget {
  final ValueNotifier<T>? selectedObjectNotifier;
  final T object;
  final Widget child;

  const SelectedRowHighlight({
    super.key,
    this.selectedObjectNotifier,
    required this.object,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedObjectNotifier == null) return child;

    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: selectedObjectNotifier!,
      builder: (_, selectedObject, child) => Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_selectedRowRadius),
          border: selectedObject == object ? Border.all(color: theme.colorScheme.primary, width: 0.25) : null,
          color: selectedObject == object ? theme.colorScheme.secondaryContainer : null,
        ),
        child: child,
      ),
      child: child,
    );
  }
}
