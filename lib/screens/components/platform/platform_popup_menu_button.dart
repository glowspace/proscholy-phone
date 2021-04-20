import 'package:flutter/material.dart';
import 'package:zpevnik/screens/components/highlightable_button.dart';
import 'package:zpevnik/theme.dart';

class PlatformPopupMenuButton<T> extends StatefulWidget {
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final Function(T) onSelected;

  const PlatformPopupMenuButton({
    Key key,
    @required this.itemBuilder,
    this.onSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlatformPopupMenuButtonState();
}

class _PlatformPopupMenuButtonState<T> extends State<PlatformPopupMenuButton<T>> {
  @override
  Widget build(BuildContext context) => HighlightableButton(
        onPressed: _showButtonMenu,
        padding: null,
        icon: Icon(Icons.more_vert),
      );

  void _showButtonMenu() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
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
      items: widget.itemBuilder(context),
      position: position,
      shape: ContinuousRectangleBorder(side: BorderSide(color: AppTheme.of(context).borderColor)),
      color: AppTheme.of(context).backgroundColor,
      // captureInheritedThemes: false,
      useRootNavigator: true,
    ).then<void>((T newValue) {
      if (!mounted) return null;
      if (newValue == null) return null;

      if (widget.onSelected != null) widget.onSelected(newValue);
    });
  }
}
