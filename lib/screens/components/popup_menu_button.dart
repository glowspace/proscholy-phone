import 'package:flutter/material.dart';
import 'package:zpevnik/screens/components/highlightable.dart';
import 'package:zpevnik/theme.dart';

class PopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final Function(T?) onSelected;

  const PopupMenuButton({
    Key? key,
    required this.itemBuilder,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Highlightable(
      onPressed: () => _showButtonMenu(context),
      padding: EdgeInsets.zero,
      child: Icon(Icons.more_vert),
    );
  }

  void _showButtonMenu(BuildContext context) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<T>(
      context: context,
      elevation: popupMenuTheme.elevation,
      items: itemBuilder(context),
      position: position,
      shape: ContinuousRectangleBorder(side: BorderSide(color: AppTheme.of(context).borderColor)),
      color: AppTheme.of(context).backgroundColor,
      useRootNavigator: true,
    ).then<void>(onSelected);
  }
}
