import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const MenuSection({Key? key, this.title = '', this.children = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      padding: EdgeInsets.only(bottom: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(title, style: appTheme.subTitleTextStyle),
          ),
          SizedBox(height: kDefaultPadding),
          Column(children: children),
        ],
      ),
    );
  }
}
