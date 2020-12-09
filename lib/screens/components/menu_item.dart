import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/screens/components/highlightable_row.dart';
import 'package:zpevnik/theme.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onPressed;

  const MenuItem({Key key, this.title, this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => HighlightableRow(
        onPressed: onPressed,
        highlightColor: AppThemeNew.of(context).highlightColor,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
          child: Row(children: [
            Container(padding: EdgeInsets.only(right: kDefaultPadding), child: Icon(icon)),
            Text(title),
          ]),
        ),
      );
}