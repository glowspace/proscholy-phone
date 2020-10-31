import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key key,
    @required this.onPressed,
    @required this.icon,
  }) : super(key: key);

  final Function() onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onPressed,
        icon: icon,
        visualDensity: VisualDensity.compact,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      );
}
