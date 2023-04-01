import 'package:flutter/material.dart' hide showMenu, PopupMenuItem, PopupMenuEntry, PopupMenuPosition;
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/popup_menu.dart';

class CustomPopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final Function(BuildContext, T?) onSelected;
  final PopupMenuPosition menuPosition;

  final EdgeInsets? padding;

  const CustomPopupMenuButton({
    Key? key,
    required this.items,
    required this.onSelected,
    this.padding,
    this.menuPosition = PopupMenuPosition.under,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HighlightableIconButton(
      onTap: () => _showMenu(context),
      shrinkWrap: menuPosition == PopupMenuPosition.over,
      padding: padding ?? const EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
      icon: const Icon(Icons.more_vert),
    );
  }

  void _showMenu(BuildContext context) {
    final button = context.findRenderObject()! as RenderBox;
    final overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final Offset offset;
    switch (menuPosition) {
      case PopupMenuPosition.over:
        offset = const Offset(0, 0);
        break;
      case PopupMenuPosition.under:
        offset = Offset(0.0, button.size.height);
        break;
    }

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      items: items,
      shape: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      position: position,
      color: Theme.of(context).colorScheme.surface,
    ).then((value) => onSelected(context, value));
  }
}
