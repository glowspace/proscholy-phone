import 'package:flutter/material.dart' hide showMenu, PopupMenuItem, PopupMenuEntry;
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/custom/popup_menu.dart';

class CustomPopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final Function(BuildContext, T?) onSelected;

  const CustomPopupMenuButton({
    Key? key,
    required this.items,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      onTap: () => _showMenu(context),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: const Icon(Icons.more_vert),
    );
  }

  void _showMenu(BuildContext context) {
    final theme = Theme.of(context);

    final button = context.findRenderObject()! as RenderBox;
    final overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final offset = Offset(0.0, button.size.height);

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final borderSide = BorderSide(color: theme.dividerColor);

    showMenu(
      context: context,
      items: items,
      shape: Border(bottom: borderSide, left: borderSide),
      position: position,
    ).then((value) => onSelected(context, value));
  }
}
