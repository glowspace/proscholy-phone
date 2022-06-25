import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/components/highlightable.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/platform/mixin.dart';

Future<T?> showPlatformDialog<T>(BuildContext context, Widget Function(BuildContext) builder) {
  if (Platform.isIOS) {
    return showCupertinoDialog<T>(context: context, barrierDismissible: false, builder: builder);
  }

  return showDialog<T>(context: context, barrierDismissible: false, builder: builder);
}

// class ConfirmDialog extends StatelessWidget with PlatformMixin {
//   final String title;
//   final String confirmText;

//   const ConfirmDialog({
//     Key? key,
//     this.title = '',
//     this.confirmText = '',
//   }) : super(key: key);

//   @override
//   Widget buildAndroid(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       actions: _buildActions(context),
//     );
//   }

//   @override
//   Widget buildIos(BuildContext context) {
//     return CupertinoAlertDialog(
//       title: Text(title),
//       actions: _buildActions(context),
//     );
//   }

//   List<Widget> _buildActions(BuildContext context) {

//     return [
//       TextButton(
//         child: Text('Zrušit', style: appTheme.bodyTextStyle?.copyWith(color: Colors.red)),
//         onPressed: () => Navigator.of(context).pop(false),
//       ),
//       TextButton(
//         child: Text(confirmText, style: appTheme.bodyTextStyle),
//         onPressed: () => Navigator.of(context).pop(true),
//       ),
//     ];
//   }
// }

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

  @override
  Widget buildAndroid(BuildContext context) {
    final theme = Theme.of(context);

    final textFieldController = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(border: InputBorder.none, hintText: 'Název'),
        controller: textFieldController,
      ),
      actions: [
        TextButton(
          child: Text('Zrušit', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: textFieldController,
          builder: (context, value, _) {
            final isEnabled = value.text.isNotEmpty;

            return TextButton(
              child: Text(
                submitText,
                style: theme.textTheme.bodyMedium?.copyWith(color: isEnabled ? null : theme.disabledColor),
              ),
              onPressed: isEnabled ? () => Navigator.of(context).pop(value.text) : null,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget buildIos(BuildContext context) {
    final theme = Theme.of(context);

    final textFieldController = TextEditingController();

    return CupertinoAlertDialog(
      title: Text(title),
      content: CupertinoTextField(
        autofocus: true,
        placeholder: 'Název',
        controller: textFieldController,
      ),
      actions: [
        Highlightable(
          highlightBackground: true,
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Center(child: Text('Zrušit', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red))),
          onTap: () => Navigator.of(context).pop(),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: textFieldController,
          builder: (context, value, _) {
            final isEnabled = value.text.isNotEmpty;

            return Highlightable(
              highlightBackground: true,
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Center(
                child: Text(
                  submitText,
                  style: theme.textTheme.bodyMedium?.copyWith(color: isEnabled ? null : theme.disabledColor),
                ),
              ),
              onTap: isEnabled ? () => Navigator.of(context).pop(value.text) : null,
            );
          },
        ),
      ],
    );
  }
}
