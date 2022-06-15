import 'package:flutter/material.dart';
import 'package:zpevnik/constants.dart';

class BottomFormSheet extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Widget? bottomAction;
  final EdgeInsets contentPadding;

  const BottomFormSheet({
    Key? key,
    required this.title,
    this.items = const [],
    this.bottomAction,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: kDefaultPadding),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: contentPadding,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: items),
            ),
          ),
        ),
        if (bottomAction != null) bottomAction!,
      ],
    );
  }
}
