import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/screens/utils/updateable.dart';
import 'package:zpevnik/theme.dart';

Future<T?> showPlatformDialog<T>(BuildContext context, Widget Function(BuildContext) builder) {
  if (Theme.of(context).platform == TargetPlatform.iOS)
    return showCupertinoDialog<T>(context: context, barrierDismissible: false, builder: builder);
  else
    return showDialog<T>(context: context, barrierDismissible: false, builder: builder);
}

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String confirmText;

  const ConfirmDialog({
    Key? key,
    this.title = '',
    this.confirmText = '',
  }) : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> with PlatformMixin {
  @override
  Widget buildAndroid(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: _actions(context),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      actions: _actions(context),
    );
  }

  List<Widget> _actions(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return [
      TextButton(
        child: Text('Zrušit', style: appTheme.bodyTextStyle?.copyWith(color: Colors.red)),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      TextButton(
        child: Text(widget.confirmText, style: appTheme.bodyTextStyle),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ];
  }
}

class PlatformDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final String submitText;

  const PlatformDialog({
    Key? key,
    this.title = '',
    this.initialValue = '',
    this.submitText = '',
  }) : super(key: key);

  @override
  _PlatformDialogState createState() => _PlatformDialogState();
}

class _PlatformDialogState extends State<PlatformDialog> with PlatformMixin, Updateable {
  final _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textFieldController.text = widget.initialValue;
  }

  @override
  Widget buildAndroid(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(border: InputBorder.none, hintText: 'Název'),
        controller: _textFieldController,
      ),
      actions: _actions(context),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: CupertinoTextField(
        autofocus: true,
        placeholder: 'Název',
        controller: _textFieldController,
      ),
      actions: _actions(context),
    );
  }

  List<Widget> _actions(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final confirmTextStyle = appTheme.bodyTextStyle
        ?.copyWith(color: _textFieldController.text.isEmpty ? appTheme.textColor.withAlpha(0x77) : null);

    return [
      TextButton(
        child: Text('Zrušit', style: appTheme.bodyTextStyle?.copyWith(color: Colors.red)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      TextButton(
        child: Text(widget.submitText, style: confirmTextStyle),
        onPressed:
            _textFieldController.text.isEmpty ? null : () => Navigator.of(context).pop(_textFieldController.text),
      ),
    ];
  }

  @override
  List<Listenable> get listenables => [_textFieldController];
}
