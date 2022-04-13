import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/platform/mixin.dart';
import 'package:zpevnik/theme.dart';

Future<T?> showPlatformDialog<T>(BuildContext context, Widget Function(BuildContext) builder) {
  if (Platform.isIOS) {
    return showCupertinoDialog<T>(context: context, barrierDismissible: false, builder: builder);
  }

  return showDialog<T>(context: context, barrierDismissible: false, builder: builder);
}

class ConfirmDialog extends StatelessWidget with PlatformMixin {
  final String title;
  final String confirmText;

  const ConfirmDialog({
    Key? key,
    this.title = '',
    this.confirmText = '',
  }) : super(key: key);

  @override
  Widget buildAndroid(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return [
      TextButton(
        child: Text('Zrušit', style: appTheme.bodyTextStyle?.copyWith(color: Colors.red)),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      TextButton(
        child: Text(confirmText, style: appTheme.bodyTextStyle),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ];
  }
}

class PlatformDialog extends StatelessWidget with PlatformMixin {
  final String title;
  final String initialValue;
  final String submitText;

  PlatformDialog({
    Key? key,
    this.title = '',
    this.initialValue = '',
    this.submitText = '',
  }) : super(key: key);

  final _textFieldController = TextEditingController();

  @override
  Widget buildAndroid(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Název'),
        controller: _textFieldController,
      ),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: CupertinoTextField(
        autofocus: true,
        placeholder: 'Název',
        controller: _textFieldController,
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return [
      TextButton(
        child: Text('Zrušit', style: appTheme.bodyTextStyle?.copyWith(color: Colors.red)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: _textFieldController,
        builder: (context, value, _) {
          final isEnabled = value.text.isEmpty;

          return TextButton(
            child: Text(
              submitText,
              style: appTheme.bodyTextStyle?.copyWith(color: isEnabled ? appTheme.textColor.withAlpha(0x77) : null),
            ),
            onPressed: isEnabled ? null : () => Navigator.of(context).pop(_textFieldController.text),
          );
        },
      ),
    ];
  }
}
