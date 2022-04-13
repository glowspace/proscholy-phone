import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/theme.dart';

class MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const MenuSection({Key? key, required this.title, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
          child: Text(title, style: appTheme.subTitleTextStyle),
        ),
        const SizedBox(height: kDefaultPadding / 2),
        Container(
          decoration: BoxDecoration(
            color: appTheme.fillColor,
            border: Border.symmetric(
              horizontal: BorderSide(color: appTheme.borderColor),
            ),
          ),
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: ListView.separated(
            itemCount: children.length,
            itemBuilder: (_, index) => children[index],
            separatorBuilder: (_, __) => const Divider(),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        )
      ],
    );
  }
}
