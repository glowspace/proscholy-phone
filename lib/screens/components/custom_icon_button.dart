import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/utils/platform.dart';

class CustomIconButton extends StatelessWidget with PlatformWidgetMixin {
  final Function() onPressed;
  final Widget icon;

  const CustomIconButton({Key key, this.onPressed, this.icon}) : super(key: key);

  @override
  Widget androidWidget(BuildContext context) => IconButton(
        onPressed: onPressed,
        icon: icon,
        visualDensity: VisualDensity.compact,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      );

  @override
  Widget iOSWidget(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
          child: icon,
        ),
      );
}
