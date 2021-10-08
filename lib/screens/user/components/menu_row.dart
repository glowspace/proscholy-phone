import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class MenuRow extends StatelessWidget {
  final String title;
  final Widget child;

  const MenuRow({Key? key, this.title = '', required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        color: appTheme.fillColor,
        border: Border.symmetric(
          horizontal: BorderSide(color: appTheme.borderColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Flexible(child: child),
        ],
      ),
    );
  }
}
