import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/utils/platform.dart';

class PlatformSwitch extends StatelessWidget with PlatformWidgetMixin {
  final bool value;
  final Function(bool) onChanged;

  const PlatformSwitch({Key key, this.value, this.onChanged}) : super(key: key);

  @override
  Widget androidWidget(BuildContext context) => Switch(value: value, onChanged: onChanged);

  @override
  Widget iOSWidget(BuildContext context) => CupertinoSwitch(value: value, onChanged: onChanged);
}
